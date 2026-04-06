import 'dart:developer' as developer;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabaseService {
  static final UserDatabaseService _instance = UserDatabaseService._internal();
  factory UserDatabaseService() => _instance;
  UserDatabaseService._internal();

  static const String _dbName = 'see_adventure.db';
  static const int _dbVersion = 2; // Incremented to trigger upgrade
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();

    // Ensure admin user exists after database initialization
    await _ensureAdminUserExists(_database!);

    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        username TEXT UNIQUE NOT NULL,
        password TEXT,
        display_name TEXT,
        photo_url TEXT,
        phone_number TEXT,
        provider TEXT DEFAULT 'local',
        is_active INTEGER DEFAULT 1,
        is_admin INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        last_login_at TEXT NOT NULL,
        email_verified INTEGER DEFAULT 0,
        phone_verified INTEGER DEFAULT 0
      )
    ''');

    // Create user_sessions table
    await db.execute('''
      CREATE TABLE user_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        session_token TEXT UNIQUE NOT NULL,
        created_at TEXT NOT NULL,
        expires_at TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create user_preferences table
    await db.execute('''
      CREATE TABLE user_preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        theme TEXT DEFAULT 'light',
        language TEXT DEFAULT 'en',
        notifications_enabled INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_users_email ON users(email)');
    await db.execute('CREATE INDEX idx_users_username ON users(username)');
    await db.execute('CREATE INDEX idx_users_uid ON users(uid)');
    await db.execute('CREATE INDEX idx_users_provider ON users(provider)');
    await db.execute(
      'CREATE INDEX idx_sessions_token ON user_sessions(session_token)',
    );
    await db.execute(
      'CREATE INDEX idx_sessions_user ON user_sessions(user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_preferences_user ON user_preferences(user_id)',
    );

    // Insert default admin user
    await db.execute('''
      INSERT INTO users (
        uid, email, username, password, display_name, provider, 
        is_active, is_admin, created_at, last_login_at
      ) VALUES (
        'admin-sea-uid-12345',
        'adminsea',
        'adminsea',
        'adminseaadventure',
        'System Administrator',
        'local',
        1, 1, datetime('now'), datetime('now')
      )
    ''');

    developer.log(
      'Database created with admin user',
      name: 'UserDatabaseService',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    developer.log(
      'Database upgraded from version $oldVersion to $newVersion',
      name: 'UserDatabaseService',
    );

    // Add is_admin column if it doesn't exist (for upgrading from version 1)
    if (oldVersion < 2) {
      try {
        await db.execute(
          'ALTER TABLE users ADD COLUMN is_admin INTEGER DEFAULT 0',
        );
        developer.log(
          'Added is_admin column to users table',
          name: 'UserDatabaseService',
        );
      } catch (e) {
        // Column might already exist, ignore error
        developer.log(
          'is_admin column already exists or error adding: $e',
          name: 'UserDatabaseService',
        );
      }
    }

    // Ensure admin user exists after upgrade
    await _ensureAdminUserExists(db);
  }

  // Helper method to ensure admin user exists
  Future<void> _ensureAdminUserExists(Database db) async {
    try {
      final existingAdmin = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: ['adminsea'],
        limit: 1,
      );

      if (existingAdmin.isEmpty) {
        // Insert admin user if it doesn't exist
        await db.execute('''
          INSERT INTO users (
            uid, email, username, password, display_name, provider, 
            is_active, is_admin, created_at, last_login_at
          ) VALUES (
            'admin-sea-uid-12345',
            'adminsea',
            'adminsea',
            'adminseaadventure',
            'System Administrator',
            'local',
            1, 1, datetime('now'), datetime('now')
          )
        ''');
        developer.log(
          'Admin user created during upgrade',
          name: 'UserDatabaseService',
        );
      }
    } catch (e) {
      developer.log(
        'Error ensuring admin user exists: $e',
        name: 'UserDatabaseService',
      );
    }
  }

  // User CRUD operations
  Future<int> insertUser({
    required String uid,
    required String email,
    required String username,
    required String password,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String provider = 'local',
    bool isAdmin = false,
  }) async {
    try {
      final db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;

      final data = {
        'uid': uid,
        'email': email.toLowerCase(),
        'username': username.toLowerCase(),
        'password': password, // In production, hash this password
        'display_name': displayName,
        'photo_url': photoUrl,
        'phone_number': phoneNumber,
        'provider': provider,
        'is_admin': isAdmin ? 1 : 0,
        'created_at': now,
        'last_login_at': now,
      };

      final id = await db.insert('users', data);
      developer.log(
        'User inserted: $email (ID: $id)',
        name: 'UserDatabaseService',
      );
      return id;
    } catch (e) {
      developer.log('Error inserting user: $e', name: 'UserDatabaseService');
      return -1;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final db = await database;
      final results = await db.query(
        'users',
        where: 'email = ? AND is_active = 1',
        whereArgs: [email.toLowerCase()],
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      developer.log(
        'Error getting user by email: $e',
        name: 'UserDatabaseService',
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    try {
      final db = await database;
      final results = await db.query(
        'users',
        where: 'username = ? AND is_active = 1',
        whereArgs: [username.toLowerCase()],
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      developer.log(
        'Error getting user by username: $e',
        name: 'UserDatabaseService',
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmailOrUsername(
    String identifier,
  ) async {
    // Try username first
    final userByUsername = await getUserByUsername(identifier);
    if (userByUsername != null) return userByUsername;

    // Then try email
    return await getUserByEmail(identifier);
  }

  Future<Map<String, dynamic>?> getUserByUid(String uid) async {
    try {
      final db = await database;
      final results = await db.query(
        'users',
        where: 'uid = ? AND is_active = 1',
        whereArgs: [uid],
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      developer.log(
        'Error getting user by UID: $e',
        name: 'UserDatabaseService',
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> authenticateUser(
    String identifier,
    String password,
  ) async {
    try {
      final db = await database;
      final results = await db.query(
        'users',
        where: '(email = ? OR username = ?) AND password = ? AND is_active = 1',
        whereArgs: [
          identifier.toLowerCase(),
          identifier.toLowerCase(),
          password,
        ],
      );

      if (results.isNotEmpty) {
        // Update last login
        await updateUserLastLogin(results.first['id'] as int);
        return results.first;
      }
      return null;
    } catch (e) {
      developer.log(
        'Error authenticating user: $e',
        name: 'UserDatabaseService',
      );
      return null;
    }
  }

  Future<bool> emailExists(String email) async {
    try {
      final user = await getUserByEmail(email);
      return user != null;
    } catch (e) {
      developer.log(
        'Error checking if email exists: $e',
        name: 'UserDatabaseService',
      );
      return false;
    }
  }

  Future<bool> usernameExists(String username) async {
    try {
      final user = await getUserByUsername(username);
      return user != null;
    } catch (e) {
      developer.log(
        'Error checking if username exists: $e',
        name: 'UserDatabaseService',
      );
      return false;
    }
  }

  Future<int> updateUser(
    int userId, {
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? password,
  }) async {
    try {
      final db = await database;
      final data = <String, dynamic>{};

      if (displayName != null) data['display_name'] = displayName;
      if (photoUrl != null) data['photo_url'] = photoUrl;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (password != null) data['password'] = password;

      data['updated_at'] = DateTime.now().millisecondsSinceEpoch;

      final result = await db.update(
        'users',
        data,
        where: 'id = ?',
        whereArgs: [userId],
      );

      developer.log(
        'User updated successfully: $userId',
        name: 'UserDatabaseService',
      );
      return result;
    } catch (e) {
      developer.log('Error updating user: $e', name: 'UserDatabaseService');
      rethrow;
    }
  }

  Future<int> updateUserLastLogin(int userId) async {
    try {
      final db = await database;
      final result = await db.update(
        'users',
        {'last_login_at': DateTime.now().millisecondsSinceEpoch},
        where: 'id = ?',
        whereArgs: [userId],
      );
      return result;
    } catch (e) {
      developer.log(
        'Error updating last login: $e',
        name: 'UserDatabaseService',
      );
      return 0;
    }
  }

  Future<int> deactivateUser(int userId) async {
    try {
      final db = await database;
      final result = await db.update(
        'users',
        {'is_active': 0},
        where: 'id = ?',
        whereArgs: [userId],
      );

      developer.log('User deactivated: $userId', name: 'UserDatabaseService');
      return result;
    } catch (e) {
      developer.log('Error deactivating user: $e', name: 'UserDatabaseService');
      rethrow;
    }
  }

  Future<int> deleteUser(int userId) async {
    try {
      final db = await database;
      final result = await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      developer.log('User deleted: $userId', name: 'UserDatabaseService');
      return result;
    } catch (e) {
      developer.log('Error deleting user: $e', name: 'UserDatabaseService');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers({
    bool activeOnly = true,
  }) async {
    try {
      final db = await database;
      final whereClause = activeOnly ? 'is_active = 1' : null;

      return await db.query(
        'users',
        where: whereClause,
        orderBy: 'created_at DESC',
      );
    } catch (e) {
      developer.log('Error getting all users: $e', name: 'UserDatabaseService');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getUserStats() async {
    try {
      final db = await database;

      final totalUsers =
          Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM users WHERE is_active = 1'),
          ) ??
          0;

      final localUsers =
          Sqflite.firstIntValue(
            await db.rawQuery(
              'SELECT COUNT(*) FROM users WHERE provider = "local" AND is_active = 1',
            ),
          ) ??
          0;

      final googleUsers =
          Sqflite.firstIntValue(
            await db.rawQuery(
              'SELECT COUNT(*) FROM users WHERE provider = "google" AND is_active = 1',
            ),
          ) ??
          0;

      return {'total': totalUsers, 'local': localUsers, 'google': googleUsers};
    } catch (e) {
      developer.log(
        'Error getting user stats: $e',
        name: 'UserDatabaseService',
      );
      return {'total': 0, 'local': 0, 'google': 0};
    }
  }

  // Session management
  Future<int> createSession(
    int userId,
    String sessionToken, {
    int durationHours = 24,
  }) async {
    try {
      final db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;
      final expiresAt = now + (Duration(hours: durationHours).inMilliseconds);

      final data = {
        'user_id': userId,
        'session_token': sessionToken,
        'created_at': now,
        'expires_at': expiresAt,
      };

      return await db.insert('user_sessions', data);
    } catch (e) {
      developer.log('Error creating session: $e', name: 'UserDatabaseService');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getSession(String sessionToken) async {
    try {
      final db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;

      final results = await db.query(
        'user_sessions',
        where: 'session_token = ? AND expires_at > ? AND is_active = 1',
        whereArgs: [sessionToken, now],
      );

      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      developer.log('Error getting session: $e', name: 'UserDatabaseService');
      return null;
    }
  }

  Future<int> invalidateSession(String sessionToken) async {
    try {
      final db = await database;
      return await db.update(
        'user_sessions',
        {'is_active': 0},
        where: 'session_token = ?',
        whereArgs: [sessionToken],
      );
    } catch (e) {
      developer.log(
        'Error invalidating session: $e',
        name: 'UserDatabaseService',
      );
      return 0;
    }
  }

  // Cleanup expired sessions
  Future<int> cleanupExpiredSessions() async {
    try {
      final db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;

      return await db.delete(
        'user_sessions',
        where: 'expires_at < ?',
        whereArgs: [now],
      );
    } catch (e) {
      developer.log(
        'Error cleaning up expired sessions: $e',
        name: 'UserDatabaseService',
      );
      return 0;
    }
  }

  // Admin-specific methods
  Future<bool> isAdmin(String email) async {
    try {
      final db = await database;
      final results = await db.query(
        'users',
        columns: ['is_admin'],
        where: 'email = ? AND is_active = 1',
        whereArgs: [email.toLowerCase()],
        limit: 1,
      );

      if (results.isNotEmpty) {
        return results.first['is_admin'] == 1;
      }
      return false;
    } catch (e) {
      developer.log(
        'Error checking admin status: $e',
        name: 'UserDatabaseService',
      );
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsersForAdmin() async {
    try {
      final db = await database;
      final results = await db.query(
        'users',
        where: 'is_active = 1',
        orderBy: 'created_at DESC',
      );
      return results;
    } catch (e) {
      developer.log('Error getting all users: $e', name: 'UserDatabaseService');
      return [];
    }
  }

  Future<int> updateUserAdmin(
    int userId, {
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    bool? isActive,
    bool? isAdmin,
  }) async {
    try {
      final db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;

      final data = <String, dynamic>{};
      if (displayName != null) data['display_name'] = displayName;
      if (photoUrl != null) data['photo_url'] = photoUrl;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (isActive != null) data['is_active'] = isActive ? 1 : 0;
      if (isAdmin != null) data['is_admin'] = isAdmin ? 1 : 0;

      data['last_login_at'] = now;

      final count = await db.update(
        'users',
        data,
        where: 'id = ?',
        whereArgs: [userId],
      );

      developer.log(
        'User updated by admin: ID $userId',
        name: 'UserDatabaseService',
      );
      return count;
    } catch (e) {
      developer.log(
        'Error updating user by admin: $e',
        name: 'UserDatabaseService',
      );
      return 0;
    }
  }

  Future<int> deleteUserByAdmin(int userId) async {
    try {
      final db = await database;

      // Soft delete by setting is_active to 0
      final count = await db.update(
        'users',
        {
          'is_active': 0,
          'last_login_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [userId],
      );

      developer.log(
        'User deleted by admin: ID $userId',
        name: 'UserDatabaseService',
      );
      return count;
    } catch (e) {
      developer.log(
        'Error deleting user by admin: $e',
        name: 'UserDatabaseService',
      );
      return 0;
    }
  }

  Future<Map<String, dynamic>?> getUserStatsForAdmin() async {
    try {
      final db = await database;

      final totalUsers =
          Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM users WHERE is_active = 1'),
          ) ??
          0;

      final adminUsers =
          Sqflite.firstIntValue(
            await db.rawQuery(
              'SELECT COUNT(*) FROM users WHERE is_admin = 1 AND is_active = 1',
            ),
          ) ??
          0;

      final regularUsers = totalUsers - adminUsers;
      final localUsers =
          Sqflite.firstIntValue(
            await db.rawQuery(
              'SELECT COUNT(*) FROM users WHERE provider = "local" AND is_active = 1',
            ),
          ) ??
          0;

      final googleUsers =
          Sqflite.firstIntValue(
            await db.rawQuery(
              'SELECT COUNT(*) FROM users WHERE provider = "google" AND is_active = 1',
            ),
          ) ??
          0;

      return {
        'total': totalUsers,
        'admin': adminUsers,
        'regular': regularUsers,
        'local': localUsers,
        'google': googleUsers,
      };
    } catch (e) {
      developer.log(
        'Error getting admin stats: $e',
        name: 'UserDatabaseService',
      );
      return {'total': 0, 'admin': 0, 'regular': 0, 'local': 0, 'google': 0};
    }
  }

  // Update user password
  Future<int> updateUserPassword(
    int userId,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final db = await database;

      // First verify current password
      final users = await db.query(
        'users',
        where: 'id = ? AND password = ? AND is_active = 1',
        whereArgs: [userId, currentPassword],
      );

      if (users.isEmpty) {
        developer.log(
          'Current password verification failed for user ID: $userId',
          name: 'UserDatabaseService',
        );
        return 0;
      }

      // Update password
      final count = await db.update(
        'users',
        {
          'password': newPassword,
          'last_login_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [userId],
      );

      developer.log(
        'Password updated successfully for user ID: $userId',
        name: 'UserDatabaseService',
      );
      return count;
    } catch (e) {
      developer.log(
        'Error updating user password: $e',
        name: 'UserDatabaseService',
      );
      return 0;
    }
  }

  // Database maintenance
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      developer.log('Database closed', name: 'UserDatabaseService');
    }
  }

  Future<void> clearAllData() async {
    try {
      final db = await database;
      await db.delete('users');
      await db.delete('user_sessions');
      await db.delete('user_preferences');
      developer.log(
        'All data cleared from database',
        name: 'UserDatabaseService',
      );
    } catch (e) {
      developer.log('Error clearing database: $e', name: 'UserDatabaseService');
      rethrow;
    }
  }
}
