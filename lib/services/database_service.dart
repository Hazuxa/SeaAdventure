import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  // Save or update user in Firestore
  Future<bool> saveUser(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(user.toFirestore(), SetOptions(merge: true));

      developer.log(
        'User saved/updated successfully: ${user.uid}',
        name: 'DatabaseService',
      );
      return true;
    } catch (e, st) {
      developer.log(
        'Error saving user: $e',
        name: 'DatabaseService',
        stackTrace: st,
      );
      return false;
    }
  }

  // Get user by UID
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e, st) {
      developer.log(
        'Error getting user: $e',
        name: 'DatabaseService',
        stackTrace: st,
      );
      return null;
    }
  }

  // Update user last login time
  Future<bool> updateLastLogin(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).update({
        'lastLoginAt': Timestamp.now(),
      });

      developer.log(
        'Last login updated for user: $uid',
        name: 'DatabaseService',
      );
      return true;
    } catch (e, st) {
      developer.log(
        'Error updating last login: $e',
        name: 'DatabaseService',
        stackTrace: st,
      );
      return false;
    }
  }

  // Check if username exists
  Future<bool> usernameExists(String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username.toLowerCase())
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e, st) {
      developer.log(
        'Error checking if username exists: $e',
        name: 'DatabaseService',
        stackTrace: st,
      );
      return false;
    }
  }

  // Get user by username
  Future<UserModel?> getUserByUsername(String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username.toLowerCase())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } catch (e, st) {
      developer.log(
        'Error getting user by username: $e',
        name: 'DatabaseService',
        stackTrace: st,
      );
      return null;
    }
  }

  // Get user by email or username
  Future<UserModel?> getUserByEmailOrUsername(String identifier) async {
    // First try to get by username
    final userByUsername = await getUserByUsername(identifier);
    if (userByUsername != null) {
      return userByUsername;
    }

    // If not found, try by email
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('email', isEqualTo: identifier.toLowerCase())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } catch (e, st) {
      developer.log(
        'Error getting user by email: $e',
        name: 'DatabaseService',
        stackTrace: st,
      );
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(
    String uid, {
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    String? username,
  }) async {
    try {
      Map<String, dynamic> updateData = {};

      if (displayName != null) updateData['displayName'] = displayName;
      if (photoURL != null) updateData['photoURL'] = photoURL;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (username != null) updateData['username'] = username.toLowerCase();

      await _firestore.collection(_usersCollection).doc(uid).update(updateData);

      developer.log('User profile updated: $uid', name: 'DatabaseService');
      return true;
    } catch (e, st) {
      developer.log(
        'Error updating user profile: $e',
        name: 'DatabaseService',
        stackTrace: st,
      );
      return false;
    }
  }

  // Delete user from Firestore
  Future<bool> deleteUser(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).delete();

      developer.log('User deleted: $uid', name: 'DatabaseService');
      return true;
    } catch (e, st) {
      developer.log(
        'Error deleting user: $e',
        name: 'DatabaseService',
        stackTrace: st,
      );
      return false;
    }
  }

  // Get all users (for admin purposes)
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e, st) {
      developer.log(
        'Error getting all users: $e',
        name: 'DatabaseService',
        stackTrace: st,
      );
      return [];
    }
  }

  // Check if user exists
  Future<bool> userExists(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();
      return doc.exists;
    } catch (e, st) {
      developer.log(
        'Error checking if user exists: $e',
        name: 'DatabaseService',
        stackTrace: st,
      );
      return false;
    }
  }

  // Get user statistics
  Future<Map<String, int>> getUserStats() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_usersCollection)
          .get();

      int totalUsers = snapshot.docs.length;
      int googleUsers = 0;
      int emailUsers = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String provider = data['provider'] ?? 'email';

        if (provider == 'google') {
          googleUsers++;
        } else {
          emailUsers++;
        }
      }

      return {'total': totalUsers, 'google': googleUsers, 'email': emailUsers};
    } catch (e, st) {
      developer.log(
        'Error getting user stats: $e',
        name: 'DatabaseService',
        stackTrace: st,
      );
      return {'total': 0, 'google': 0, 'email': 0};
    }
  }
}
