import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final String provider;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isActive;
  final bool isAdmin; // New admin role field

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    required this.provider,
    required this.createdAt,
    required this.lastLoginAt,
    this.isActive = true,
    this.isAdmin = false, // Default to false
  });

  // Create from Firebase User
  factory UserModel.fromFirebaseUser(
    firebaseUser, {
    required String provider,
    String? username,
    bool isAdmin = false,
  }) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      username: username ?? firebaseUser.email?.split('@')[0] ?? 'user',
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      phoneNumber: firebaseUser.phoneNumber,
      provider: provider,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      isAdmin: isAdmin,
    );
  }

  // Create from Firestore Document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      phoneNumber: data['phoneNumber'],
      provider: data['provider'] ?? 'email',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  // Convert to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'provider': provider,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      'isActive': isActive,
      'isAdmin': isAdmin,
    };
  }

  // Create copy with updated fields
  UserModel copyWith({
    String? email,
    String? username,
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    String? provider,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isActive,
    bool? isAdmin,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      provider: provider ?? this.provider,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, username: $username, provider: $provider)';
  }
}
