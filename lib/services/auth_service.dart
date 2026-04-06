import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  bool _googleSignInInitialized = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Ensure Google Sign-In is initialized
  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    // No need to manually initialize in newer versions
    _googleSignInInitialized = true;
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        developer.log('Google sign-in cancelled by user', name: 'AuthService');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        // Save user to database
        final userModel = UserModel.fromFirebaseUser(user, provider: 'google');
        await _databaseService.saveUser(userModel);

        developer.log(
          'Google sign-in success: ${user.email} name=${user.displayName}',
          name: 'AuthService',
        );
      }

      return user;
    } catch (e, st) {
      developer.log(
        'Error in Google sign-in: $e',
        name: 'AuthService',
        stackTrace: st,
      );
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailPassword(
    String email,
    String password,
    String? displayName,
    String? username,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (displayName != null && displayName.trim().isNotEmpty) {
        await userCredential.user?.updateDisplayName(displayName.trim());
        await userCredential.user?.reload();
      }

      final User? updatedUser = _auth.currentUser;

      if (updatedUser != null) {
        // Save user to database
        final userModel = UserModel.fromFirebaseUser(
          updatedUser,
          provider: 'email',
          username: username,
        );
        await _databaseService.saveUser(userModel);

        developer.log(
          'Email registration success: ${updatedUser.email} username=$username name=${updatedUser.displayName}',
          name: 'AuthService',
        );
      }

      return updatedUser;
    } catch (e, st) {
      developer.log(
        'Error in registration: $e',
        name: 'AuthService',
        stackTrace: st,
      );
      return null;
    }
  }

  // Sign in with email and password (supports email or username)
  Future<User?> signInWithEmailPassword(
    String identifier,
    String password,
  ) async {
    try {
      String email = identifier;

      // If identifier is not an email, try to find user by username
      if (!identifier.contains('@')) {
        final userModel = await _databaseService.getUserByEmailOrUsername(
          identifier,
        );
        if (userModel != null) {
          email = userModel.email;
        } else {
          developer.log(
            'User not found for identifier: $identifier',
            name: 'AuthService',
          );
          return null;
        }
      }

      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        // Update last login time
        await _databaseService.updateLastLogin(user.uid);

        developer.log(
          'Email login success: ${user.email} identifier=$identifier',
          name: 'AuthService',
        );
      }

      return user;
    } catch (e, st) {
      developer.log(
        'Error in email login: $e',
        name: 'AuthService',
        stackTrace: st,
      );
      return null;
    }
  }

  // Check if username exists
  Future<bool> usernameExists(String username) async {
    return await _databaseService.usernameExists(username);
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _ensureGoogleSignInInitialized();
      await _googleSignIn.signOut();
      await _auth.signOut();

      developer.log('User signed out successfully', name: 'AuthService');
    } catch (e, st) {
      developer.log(
        'Error signing out: $e',
        name: 'AuthService',
        stackTrace: st,
      );
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      developer.log(
        'Password reset email sent to: $email',
        name: 'AuthService',
      );
      return true;
    } catch (e, st) {
      developer.log(
        'Error sending password reset: $e',
        name: 'AuthService',
        stackTrace: st,
      );
      return false;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return false;

      // Update in Firebase Auth
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      await user.reload();

      // Update in Firestore
      await _databaseService.updateUserProfile(
        user.uid,
        displayName: displayName,
        photoURL: photoURL,
      );

      developer.log('User profile updated: ${user.email}', name: 'AuthService');
      return true;
    } catch (e, st) {
      developer.log(
        'Error updating user profile: $e',
        name: 'AuthService',
        stackTrace: st,
      );
      return false;
    }
  }

  // Delete user account
  Future<bool> deleteUserAccount() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return false;

      // Delete from Firestore first
      await _databaseService.deleteUser(user.uid);

      // Delete from Firebase Auth
      await user.delete();

      developer.log('User account deleted: ${user.email}', name: 'AuthService');
      return true;
    } catch (e, st) {
      developer.log(
        'Error deleting user account: $e',
        name: 'AuthService',
        stackTrace: st,
      );
      return false;
    }
  }

  // Get user data from database
  Future<UserModel?> getUserData(String uid) async {
    return await _databaseService.getUser(uid);
  }

  // Check if user is new (first time login)
  Future<bool> isNewUser(String uid) async {
    final userExists = await _databaseService.userExists(uid);
    return !userExists;
  }
}
