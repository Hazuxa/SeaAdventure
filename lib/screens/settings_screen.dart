import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../services/hybrid_auth_service.dart';
import '../services/sqlite_database_service.dart';
import '../services/dialog_service.dart';
import 'login_screen.dart';
import 'user_info_screen.dart';
import 'password_change_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final HybridAuthService _authService = HybridAuthService();
  final UserDatabaseService _dbService = UserDatabaseService();
  Map<String, dynamic>? _currentUser;
  bool _isLoading = false;

  // Controllers for password change
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Controllers for profile edit
  final _displayNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
          _displayNameController.text = user?['displayName'] ?? '';
          _phoneController.text = user?['phoneNumber'] ?? '';
        });
      }
    } catch (e) {
      developer.log('Error loading current user: $e', name: 'SettingsScreen');
    }
  }

  Future<void> _changePassword() async {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      DialogService.showErrorDialog(
        context,
        title: 'Error',
        message: 'Please fill in all password fields',
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      DialogService.showErrorDialog(
        context,
        title: 'Error',
        message: 'New passwords do not match',
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      DialogService.showErrorDialog(
        context,
        title: 'Error',
        message: 'Password must be at least 6 characters long',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // For SQLite users, update password
      if (_currentUser?['source'] == 'sqlite') {
        final success = await _dbService.updateUserPassword(
          _currentUser!['id'],
          _currentPasswordController.text,
          _newPasswordController.text,
        );

        if (success > 0) {
          // Clear controllers
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();

          DialogService.showSuccessDialog(
            context,
            title: 'Success',
            message: 'Password changed successfully! Please login again.',
            buttonText: 'OK',
            onButtonPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
          );
        } else {
          DialogService.showErrorDialog(
            context,
            title: 'Error',
            message: 'Current password is incorrect or update failed',
          );
        }
      } else {
        // For Firebase users, show message that they need to use Firebase password reset
        DialogService.showErrorDialog(
          context,
          title: 'Firebase Account',
          message:
              'For Google/Firebase accounts, please use the "Forgot Password" option on the login screen.',
        );
      }
    } catch (e) {
      developer.log('Error changing password: $e', name: 'SettingsScreen');
      DialogService.showErrorDialog(
        context,
        title: 'Error',
        message: 'Failed to change password. Please try again.',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    if (_displayNameController.text.trim().isEmpty) {
      DialogService.showErrorDialog(
        context,
        title: 'Error',
        message: 'Display name cannot be empty',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_currentUser?['source'] == 'sqlite') {
        final success = await _dbService.updateUserAdmin(
          _currentUser!['id'],
          displayName: _displayNameController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        );

        if (success > 0) {
          // Update local user data
          await _loadCurrentUser();

          DialogService.showSuccessDialog(
            context,
            title: 'Success',
            message: 'Profile updated successfully!',
            buttonText: 'OK',
          );
        } else {
          DialogService.showErrorDialog(
            context,
            title: 'Error',
            message: 'Failed to update profile',
          );
        }
      } else {
        // For Firebase users, show message about profile editing limitations
        DialogService.showErrorDialog(
          context,
          title: 'Firebase Account',
          message:
              'For Google/Firebase accounts, profile changes are managed through your Google account settings.',
        );
      }
    } catch (e) {
      developer.log('Error updating profile: $e', name: 'SettingsScreen');
      DialogService.showErrorDialog(
        context,
        title: 'Error',
        message: 'Failed to update profile. Please try again.',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Section
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserInfoScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: _buildSectionHeader(
                      'User Profile',
                      Icons.person,
                      isClickable: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.blue.shade100,
                                child: _currentUser?['photoURL'] != null
                                    ? ClipOval(
                                        child: Image.network(
                                          _currentUser!['photoURL'] as String,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color: Colors.blue.shade800,
                                                );
                                              },
                                        ),
                                      )
                                    : Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.blue.shade800,
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _currentUser?['displayName'] ?? 'User',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currentUser?['email'] ?? '',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getAccountTypeColor()
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _getAccountTypeColor(),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        _getAccountTypeText(),
                                        style: TextStyle(
                                          color: _getAccountTypeColor(),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Username',
                            _currentUser?['username'] ?? 'N/A',
                          ),
                          _buildInfoRow(
                            'Account ID',
                            _currentUser?['uid']?.toString().substring(0, 8) ??
                                'N/A',
                          ),
                          _buildInfoRow(
                            'Provider',
                            _currentUser?['provider'] ?? 'N/A',
                          ),
                          _buildInfoRow(
                            'Source',
                            _currentUser?['source'] ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Profile Information Section
                  _buildSectionHeader('Profile Information', Icons.edit),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _displayNameController,
                            decoration: const InputDecoration(
                              labelText: 'Display Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              helperText:
                                  'This name will be displayed in your profile',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number (Optional)',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                              helperText:
                                  'Add your phone number for account recovery',
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _updateProfile,
                              icon: const Icon(Icons.save),
                              label: const Text('Update Profile'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade800,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Password Change Section (only for SQLite users)
                  if (_currentUser?['source'] == 'sqlite') ...[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PasswordChangeScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: _buildSectionHeader(
                        'Security',
                        Icons.lock,
                        isClickable: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change Password',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'For security reasons, you\'ll need to enter your current password to set a new one.',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _currentPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Current Password',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _newPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'New Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(),
                                helperText: 'Minimum 6 characters',
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _confirmPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Confirm New Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(),
                                helperText: 'Re-enter your new password',
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _changePassword,
                                icon: const Icon(Icons.lock_reset),
                                label: const Text('Change Password'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Account Actions Section
                  _buildSectionHeader('Account Actions', Icons.settings),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.info, color: Colors.blue),
                          title: const Text('About'),
                          subtitle: const Text('App version and information'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('About'),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('See Adventure App'),
                                    SizedBox(height: 8),
                                    Text('Version: 1.0.0'),
                                    SizedBox(height: 8),
                                    Text(
                                      'A modern Flutter application with user authentication and admin management features.',
                                    ),
                                    SizedBox(height: 16),
                                    Text('Features:'),
                                    Text('• User registration and login'),
                                    Text('• Google Sign-In support'),
                                    Text('• Admin dashboard'),
                                    Text('• User management'),
                                    Text('• Settings and profile management'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.privacy_tip,
                            color: Colors.green,
                          ),
                          title: const Text('Privacy Policy'),
                          subtitle: const Text('View our privacy policy'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Privacy policy coming soon!'),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.help, color: Colors.purple),
                          title: const Text('Help & Support'),
                          subtitle: const Text('Get help and contact support'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Help center coming soon!'),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Logout'),
                          subtitle: const Text('Sign out of your account'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                  'Are you sure you want to logout?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _logout();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon, {
    bool isClickable = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade800, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        if (isClickable) ...[
          const Spacer(),
          Icon(Icons.arrow_forward_ios, color: Colors.blue.shade800, size: 16),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Color _getAccountTypeColor() {
    final provider = _currentUser?['provider']?.toString().toLowerCase();
    switch (provider) {
      case 'google':
        return Colors.red;
      case 'local':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _getAccountTypeText() {
    final provider = _currentUser?['provider']?.toString().toUpperCase();
    return provider ?? 'UNKNOWN';
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
