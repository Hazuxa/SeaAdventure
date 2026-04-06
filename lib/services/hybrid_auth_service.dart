import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/sqlite_database_service.dart';
import 'session_manager.dart';

class HybridAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService _firestoreService = DatabaseService();
  final UserDatabaseService _sqliteService = UserDatabaseService();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _googleSignInInitialized = false;
  final Uuid _uuid = const Uuid();

  // Get current user (check Firebase first, then SQLite session)
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      // Try Firebase first
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        final userMap = {
          'id': firebaseUser.uid,
          'uid': firebaseUser.uid,
          'email': firebaseUser.email,
          'displayName': firebaseUser.displayName,
          'photoURL': firebaseUser.photoURL,
          'phoneNumber': firebaseUser.phoneNumber,
          'provider': 'firebase',
          'source': 'firebase',
          'isAdmin': false, // Firebase users are not admin by default
        };

        // Sync to SQLite for backup
        await _syncFirebaseUserToSQLite(userMap);

        return userMap;
      }

      // Fallback to SQLite session
      final sessionManager = SessionManager();
      final sessionUser = await sessionManager.getCurrentUser();

      if (sessionUser != null) {
        // Check if session is still valid
        final isExpired = await sessionManager.isSessionExpired();
        if (!isExpired) {
          // Check if user is admin
          final isAdmin = await _sqliteService.isAdmin(
            sessionUser['email'] ?? '',
          );
          sessionUser['isAdmin'] = isAdmin;
          return sessionUser;
        } else {
          // Clear expired session
          await sessionManager.clearSession();
        }
      }

      return null;
    } catch (e) {
      developer.log(
        'Error getting current user: $e',
        name: 'HybridAuthService',
      );
      return null;
    }
  }

  // Check if current user is admin
  Future<bool> isCurrentUserAdmin() async {
    final user = await getCurrentUser();
    if (user == null) return false;
    return user['isAdmin'] == true;
  }

  // Admin login check
  Future<bool> isAdminLogin(String email, String password) async {
    try {
      // Check if it's the hardcoded admin
      if (email == 'adminsea' && password == 'adminseaadventure') {
        return true;
      }

      // Check database for admin users
      final user = await _sqliteService.authenticateUser(email, password);
      if (user != null && user['is_admin'] == 1) {
        return true;
      }

      return false;
    } catch (e) {
      developer.log(
        'Error checking admin login: $e',
        name: 'HybridAuthService',
      );
      return false;
    }
  }

  // Sync Firebase user to SQLite for backup
  Future<void> _syncFirebaseUserToSQLite(Map<String, dynamic> user) async {
    try {
      // Check if user exists in SQLite
      final existingUser = await _sqliteService.getUserByEmail(
        user['email'] ?? '',
      );

      if (existingUser == null) {
        // Insert new user to SQLite
        await _sqliteService.insertUser(
          uid: user['uid'] ?? '',
          email: user['email'] ?? '',
          username: user['email']?.toString().split('@')[0] ?? 'user',
          password: '', // No password for Firebase users
          displayName: user['displayName'],
          photoUrl: user['photoURL'],
          phoneNumber: user['phoneNumber'],
          provider: user['provider'] ?? 'firebase',
        );
      } else {
        // Update existing user
        await _sqliteService.updateUser(
          existingUser['id'],
          displayName: user['displayName'],
          photoUrl: user['photoURL'],
          phoneNumber: user['phoneNumber'],
        );
      }
    } catch (e) {
      developer.log(
        'Error syncing Firebase user to SQLite: $e',
        name: 'HybridAuthService',
      );
    }
  }

  // Auth state changes stream (Firebase only)
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Ensure Google Sign-In is initialized
  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    
    // Always create a fresh GoogleSignIn instance
    _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      hostedDomain: '', // Allow any domain
    );
    
    _googleSignInInitialized = true;
  }

  // Sign up with Google (creates account but doesn't sign in)
  Future<Map<String, dynamic>?> signUpWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      
      // Force sign out to show account picker every time
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        developer.log(
          'Google sign-up cancelled by user',
          name: 'HybridAuthService',
        );
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in temporarily to get user info, then sign out immediately
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Save to Firestore ONLY - never to SQLite for Google users
        final userModel = UserModel.fromFirebaseUser(user, provider: 'google');
        await _firestoreService.saveUser(userModel);

        // Sign out immediately after creating account
        await _firebaseAuth.signOut();

        developer.log(
          'Google sign-up success: ${user.email}',
          name: 'HybridAuthService',
        );

        return {
          'id': user.uid,
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'phoneNumber': user.phoneNumber,
          'provider': 'google',
          'source': 'firebase',
          'isAdmin': false,
        };
      }

      return null;
    } catch (e) {
      developer.log('Error in Google sign-up: $e', name: 'HybridAuthService');
      return null;
    }
  }

  // Sign in with Google (Firebase only - completely separate from SQLite users)
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      
      // Force sign out to show account picker every time
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        developer.log(
          'Google sign-in cancelled by user',
          name: 'HybridAuthService',
        );
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Save to Firestore ONLY - never to SQLite for Google users
        final userModel = UserModel.fromFirebaseUser(user, provider: 'google');
        await _firestoreService.saveUser(userModel);

        developer.log(
          'Google sign-in success: ${user.email}',
          name: 'HybridAuthService',
        );

        // Return user data - Google users stay in Firebase only
        return {
          'id': user.uid,
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'phoneNumber': user.phoneNumber,
          'provider': 'google',
          'source': 'firebase',
          'isAdmin': false, // Google users are never admin
        };
      }

      return null;
    } catch (e) {
      developer.log('Error in Google sign-in: $e', name: 'HybridAuthService');
      return null;
    }
  }

  // Register with email and password (SQLite only for now, can be extended to Firebase)
  Future<Map<String, dynamic>?> registerWithEmailPassword(
    String email,
    String password,
    String? displayName,
    String? username,
  ) async {
    try {
      // Check if user already exists in SQLite
      final existingUser = await _sqliteService.getUserByEmailOrUsername(email);
      if (existingUser != null) {
        throw Exception('User with this email already exists');
      }

      // Check username availability
      if (username != null && username.isNotEmpty) {
        final usernameExists = await _sqliteService.usernameExists(username);
        if (usernameExists) {
          throw Exception('Username is already taken');
        }
      }

      // Generate UID
      final uid = _uuid.v4();
      final finalUsername =
          username?.toLowerCase() ?? email.split('@')[0].toLowerCase();

      // Check if this should be an admin user (only for the hardcoded admin)
      final isAdmin = (email == 'adminsea' && password == 'adminseaadventure');

      // Insert into SQLite
      final userId = await _sqliteService.insertUser(
        uid: uid,
        email: email.toLowerCase(),
        username: finalUsername,
        password: password, // In production, hash this password
        displayName: displayName,
        provider: 'local',
        isAdmin: isAdmin,
      );

      if (userId > 0) {
        developer.log(
          'Local registration success: $email username=$finalUsername isAdmin=$isAdmin',
          name: 'HybridAuthService',
        );

        // Get the created user
        final createdUser = await _sqliteService.getUserByEmail(email);
        if (createdUser != null) {
          final userMap = {
            'id': createdUser['id'],
            'uid': createdUser['uid'],
            'email': createdUser['email'],
            'username': createdUser['username'],
            'displayName': createdUser['display_name'],
            'photoURL': createdUser['photo_url'],
            'phoneNumber': createdUser['phone_number'],
            'provider': createdUser['provider'] ?? 'local',
            'source': 'sqlite',
            'isAdmin': isAdmin,
          };

          // Save session for SQLite user
          final sessionManager = SessionManager();
          await sessionManager.saveUserSession(userMap);

          return userMap;
        }
      }

      return null;
    } catch (e) {
      developer.log('Error in registration: $e', name: 'HybridAuthService');
      rethrow;
    }
  }

  // Sign in with email and password (SQLite only for now)
  Future<Map<String, dynamic>?> signInWithEmailPassword(
    String identifier,
    String password,
  ) async {
    try {
      // Check if it's the hardcoded admin login
      if (identifier == 'adminsea' && password == 'adminseaadventure') {
        final adminUser = await _sqliteService.getUserByEmail('adminsea');
        if (adminUser != null) {
          final userMap = {
            'id': adminUser['id'],
            'uid': adminUser['uid'],
            'email': adminUser['email'],
            'username': adminUser['username'],
            'displayName': adminUser['display_name'],
            'photoURL': adminUser['photo_url'],
            'phoneNumber': adminUser['phone_number'],
            'provider': adminUser['provider'] ?? 'local',
            'source': 'sqlite',
            'isAdmin': true,
          };

          // Save session for admin user
          final sessionManager = SessionManager();
          await sessionManager.saveUserSession(userMap);

          developer.log(
            'Admin login success: ${adminUser['email']}',
            name: 'HybridAuthService',
          );
          return userMap;
        }
      }

      // Try SQLite authentication for regular users
      final user = await _sqliteService.authenticateUser(identifier, password);

      if (user != null) {
        developer.log(
          'Local login success: ${user['email']} identifier=$identifier',
          name: 'HybridAuthService',
        );

        final userMap = {
          'id': user['id'],
          'uid': user['uid'],
          'email': user['email'],
          'username': user['username'],
          'displayName': user['display_name'],
          'photoURL': user['photo_url'],
          'phoneNumber': user['phone_number'],
          'provider': user['provider'] ?? 'local',
          'source': 'sqlite',
          'isAdmin': user['is_admin'] == 1,
        };

        // Save session for SQLite user
        final sessionManager = SessionManager();
        await sessionManager.saveUserSession(userMap);

        return userMap;
      }

      return null;
    } catch (e) {
      developer.log('Error in email login: $e', name: 'HybridAuthService');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Sign out from Google first (this clears the cached account)
      if (_googleSignInInitialized) {
        await _googleSignIn.signOut();
        await _googleSignIn.disconnect();
      }
      
      // Sign out from Firebase
      await _firebaseAuth.signOut();

      // Clear SQLite session
      final sessionManager = SessionManager();
      await sessionManager.clearSession();
      
      // Reset Google Sign-In initialization so it can be re-initialized on next login
      _googleSignInInitialized = false;

      developer.log('User signed out successfully', name: 'HybridAuthService');
    } catch (e) {
      developer.log('Error signing out: $e', name: 'HybridAuthService');
      // Still reset the flag even if there's an error
      _googleSignInInitialized = false;
    }
  }

  // Check if username exists
  Future<bool> usernameExists(String username) async {
    try {
      // Check SQLite
      final sqliteExists = await _sqliteService.usernameExists(username);
      if (sqliteExists) return true;

      // Check Firestore (for Firebase users)
      // This would require implementing a method in DatabaseService
      // For now, just return SQLite result

      return false;
    } catch (e) {
      developer.log(
        'Error checking username existence: $e',
        name: 'HybridAuthService',
      );
      return false;
    }
  }

  // Check if email exists
  Future<bool> emailExists(String email) async {
    try {
      // Check SQLite
      final sqliteExists = await _sqliteService.emailExists(email);
      if (sqliteExists) return true;

      // Check Firebase
      try {
        final methods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
        return methods.isNotEmpty;
      } catch (e) {
        // Firebase check failed, assume email doesn't exist in Firebase
        return false;
      }
    } catch (e) {
      developer.log(
        'Error checking email existence: $e',
        name: 'HybridAuthService',
      );
      return false;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    String? username,
  }) async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        // Update Firebase user
        if (displayName != null) {
          await currentUser.updateDisplayName(displayName);
        }
        if (photoURL != null) {
          await currentUser.updatePhotoURL(photoURL);
        }

        await currentUser.reload();

        // Update Firestore
        await _firestoreService.updateUserProfile(
          currentUser.uid,
          displayName: displayName,
          photoURL: photoURL,
          phoneNumber: phoneNumber,
          username: username,
        );

        // Update SQLite backup
        final sqliteUser = await _sqliteService.getUserByUid(currentUser.uid);
        if (sqliteUser != null) {
          await _sqliteService.updateUser(
            sqliteUser['id'],
            displayName: displayName,
            photoUrl: photoURL,
            phoneNumber: phoneNumber,
          );
        }

        developer.log(
          'Firebase user profile updated: ${currentUser.email}',
          name: 'HybridAuthService',
        );
        return true;
      } else {
        // For SQLite users, we'd need session management
        developer.log(
          'Cannot update SQLite user profile without session',
          name: 'HybridAuthService',
        );
        return false;
      }
    } catch (e) {
      developer.log(
        'Error updating user profile: $e',
        name: 'HybridAuthService',
      );
      return false;
    }
  }

  // Reset password (SQLite only for now)
  Future<bool> resetPassword(String email) async {
    try {
      // For Firebase users
      try {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
        developer.log(
          'Password reset email sent to Firebase user: $email',
          name: 'HybridAuthService',
        );
        return true;
      } catch (e) {
        // Firebase user not found, try SQLite
        final sqliteUser = await _sqliteService.getUserByEmail(email);
        if (sqliteUser != null) {
          // For SQLite users, you'd implement a different password reset mechanism
          developer.log(
            'Password reset requested for SQLite user: $email - implement custom flow',
            name: 'HybridAuthService',
          );
          return true;
        }
        return false;
      }
    } catch (e) {
      developer.log(
        'Error sending password reset: $e',
        name: 'HybridAuthService',
      );
      return false;
    }
  }

  // Get user statistics
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      // Get SQLite stats
      final sqliteStats = await _sqliteService.getUserStats();

      // Get Firestore stats
      final firestoreStats = await _firestoreService.getUserStats();

      final sqliteTotal = sqliteStats?['total'] as int? ?? 0;
      final sqliteLocal = sqliteStats?['local'] as int? ?? 0;
      final sqliteGoogle = sqliteStats?['google'] as int? ?? 0;

      final firestoreTotal = firestoreStats?['total'] as int? ?? 0;
      final firestoreGoogle = firestoreStats?['google'] as int? ?? 0;

      return {
        'total': sqliteTotal + firestoreTotal,
        'local': sqliteLocal,
        'google': sqliteGoogle + firestoreGoogle,
        'sqlite': sqliteTotal,
        'firebase': firestoreTotal,
      };
    } catch (e) {
      developer.log('Error getting user stats: $e', name: 'HybridAuthService');
      return {'total': 0, 'local': 0, 'google': 0, 'sqlite': 0, 'firebase': 0};
    }
  }

  // Delete user account
  Future<bool> deleteUserAccount() async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        // Delete from Firestore
        await _firestoreService.deleteUser(currentUser.uid);

        // Delete from SQLite backup
        final sqliteUser = await _sqliteService.getUserByUid(currentUser.uid);
        if (sqliteUser != null) {
          await _sqliteService.deleteUser(sqliteUser['id']);
        }

        // Delete from Firebase Auth
        await currentUser.delete();

        developer.log(
          'Firebase user account deleted: ${currentUser.email}',
          name: 'HybridAuthService',
        );
        return true;
      } else {
        // For SQLite users, you'd need session management
        developer.log(
          'Cannot delete SQLite user without session',
          name: 'HybridAuthService',
        );
        return false;
      }
    } catch (e) {
      developer.log(
        'Error deleting user account: $e',
        name: 'HybridAuthService',
      );
      return false;
    }
  }

  // Get user data by UID
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      // Try Firebase first
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null && firebaseUser.uid == uid) {
        return {
          'id': firebaseUser.uid,
          'uid': firebaseUser.uid,
          'email': firebaseUser.email,
          'displayName': firebaseUser.displayName,
          'photoURL': firebaseUser.photoURL,
          'phoneNumber': firebaseUser.phoneNumber,
          'provider': 'firebase',
          'source': 'firebase',
        };
      }

      // Try SQLite
      final sqliteUser = await _sqliteService.getUserByUid(uid);
      if (sqliteUser != null) {
        return {
          'id': sqliteUser['id'],
          'uid': sqliteUser['uid'],
          'email': sqliteUser['email'],
          'displayName': sqliteUser['display_name'],
          'photoURL': sqliteUser['photo_url'],
          'phoneNumber': sqliteUser['phone_number'],
          'provider': sqliteUser['provider'],
          'source': 'sqlite',
        };
      }

      return null;
    } catch (e) {
      developer.log('Error getting user data: $e', name: 'HybridAuthService');
      return null;
    }
  }

  // Check if user is new (first time login)
  Future<bool> isNewUser(String uid) async {
    try {
      final userData = await getUserData(uid);
      return userData == null;
    } catch (e) {
      developer.log(
        'Error checking if user is new: $e',
        name: 'HybridAuthService',
      );
      return true;
    }
  }
}
