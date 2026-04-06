import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userUsernameKey = 'user_username';
  static const String _userDisplayNameKey = 'user_display_name';
  static const String _userPhotoUrlKey = 'user_photo_url';
  static const String _userProviderKey = 'user_provider';
  static const String _userSourceKey = 'user_source';
  static const String _loginTimeKey = 'login_time';

  Future<void> saveUserSession(Map<String, dynamic> user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_userIdKey, user['id']?.toString() ?? '');
      await prefs.setString(_userEmailKey, user['email']?.toString() ?? '');
      await prefs.setString(
        _userUsernameKey,
        user['username']?.toString() ?? '',
      );
      await prefs.setString(
        _userDisplayNameKey,
        user['displayName']?.toString() ?? '',
      );
      await prefs.setString(
        _userPhotoUrlKey,
        user['photoURL']?.toString() ?? '',
      );
      await prefs.setString(
        _userProviderKey,
        user['provider']?.toString() ?? '',
      );
      await prefs.setString(_userSourceKey, user['source']?.toString() ?? '');
      await prefs.setInt(_loginTimeKey, DateTime.now().millisecondsSinceEpoch);

      developer.log(
        'User session saved: ${user['email']}',
        name: 'SessionManager',
      );
    } catch (e) {
      developer.log('Error saving user session: $e', name: 'SessionManager');
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final userId = prefs.getString(_userIdKey);
      final email = prefs.getString(_userEmailKey);
      final username = prefs.getString(_userUsernameKey);
      final displayName = prefs.getString(_userDisplayNameKey);
      final photoUrl = prefs.getString(_userPhotoUrlKey);
      final provider = prefs.getString(_userProviderKey);
      final source = prefs.getString(_userSourceKey);
      final loginTime = prefs.getInt(_loginTimeKey);

      if (email != null && email.isNotEmpty) {
        return {
          'id': userId,
          'email': email,
          'username': username,
          'displayName': displayName,
          'photoURL': photoUrl,
          'provider': provider,
          'source': source,
          'loginTime': loginTime,
        };
      }

      return null;
    } catch (e) {
      developer.log('Error getting current user: $e', name: 'SessionManager');
      return null;
    }
  }

  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_userIdKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_userUsernameKey);
      await prefs.remove(_userDisplayNameKey);
      await prefs.remove(_userPhotoUrlKey);
      await prefs.remove(_userProviderKey);
      await prefs.remove(_userSourceKey);
      await prefs.remove(_loginTimeKey);

      developer.log('User session cleared', name: 'SessionManager');
    } catch (e) {
      developer.log('Error clearing session: $e', name: 'SessionManager');
    }
  }

  Future<bool> hasActiveSession() async {
    final user = await getCurrentUser();
    return user != null;
  }

  Future<int?> getSessionAge() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginTime = prefs.getInt(_loginTimeKey);

      if (loginTime != null && loginTime > 0) {
        final now = DateTime.now().millisecondsSinceEpoch;
        return (now - loginTime) as int;
      }

      return null;
    } catch (e) {
      developer.log('Error getting session age: $e', name: 'SessionManager');
      return null;
    }
  }

  Future<bool> isSessionExpired({int maxAgeHours = 24}) async {
    try {
      final sessionAge = await getSessionAge();
      if (sessionAge == null) return true;

      final maxAgeMs = Duration(hours: maxAgeHours).inMilliseconds;
      return sessionAge > maxAgeMs;
    } catch (e) {
      developer.log(
        'Error checking session expiration: $e',
        name: 'SessionManager',
      );
      // If we can't check, assume expired for safety
      return true;
    }
  }

  // Refresh session (update login time)
  Future<void> refreshSession() async {
    try {
      final user = await getCurrentUser();
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(
          _loginTimeKey,
          DateTime.now().millisecondsSinceEpoch,
        );
        developer.log(
          'Session refreshed for: ${user['email']}',
          name: 'SessionManager',
        );
      }
    } catch (e) {
      developer.log('Error refreshing session: $e', name: 'SessionManager');
    }
  }

  // Get session info for debugging
  Future<Map<String, dynamic>?> getSessionInfo() async {
    try {
      final user = await getCurrentUser();
      if (user == null) return null;

      final sessionAge = await getSessionAge();
      final isExpired = await isSessionExpired();

      return {
        'user': user,
        'sessionAge': sessionAge,
        'isExpired': isExpired,
        'loginTime': user['loginTime'],
      };
    } catch (e) {
      developer.log('Error getting session info: $e', name: 'SessionManager');
      return null;
    }
  }
}
