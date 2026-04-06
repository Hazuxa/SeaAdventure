import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../services/hybrid_auth_service.dart';
import '../services/sqlite_database_service.dart';
import '../services/dialog_service.dart';
import 'login_screen.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final HybridAuthService _authService = HybridAuthService();
  final UserDatabaseService _dbService = UserDatabaseService();
  Map<String, dynamic>? _currentUser;
  bool _isLoading = false;

  // Controllers for password change
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
        });
      }
    } catch (e) {
      developer.log('Error loading current user: $e', name: 'PasswordChangeScreen');
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
          message: 'For Google/Firebase accounts, please use the "Forgot Password" option on the login screen.',
        );
      }
    } catch (e) {
      developer.log('Error changing password: $e', name: 'PasswordChangeScreen');
      DialogService.showErrorDialog(
        context,
        title: 'Error',
        message: 'Failed to change password. Please try again.',
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
        title: const Text('Change Password'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Security Info Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.security, color: Colors.orange.shade700, size: 32),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Security Settings',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currentUser?['source'] == 'sqlite' 
                                          ? 'Change your local account password'
                                          : 'Google account authentication',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _currentUser?['source'] == 'sqlite'
                                        ? 'For security, you must enter your current password to set a new one.'
                                        : 'Password changes for Google accounts must be done through Google settings.',
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Password Change Form (only for SQLite users)
                  if (_currentUser?['source'] == 'sqlite') ...[
                    const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextField(
                              controller: _currentPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Current Password',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                                helperText: 'Enter your current password',
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
                                suffixIcon: Icon(Icons.visibility_off),
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
                                suffixIcon: Icon(Icons.visibility_off),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 24),
                            
                            // Password Requirements
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Password Requirements:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  ...[
                                    'At least 6 characters long',
                                    'Contains letters and numbers',
                                    'Not easily guessable',
                                  ].map((requirement) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle_outline, size: 16, color: Colors.grey[600]),
                                        const SizedBox(width: 8),
                                        Text(requirement, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _changePassword,
                                icon: const Icon(Icons.lock_reset),
                                label: const Text('Change Password'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Google Account Info
                    const Text(
                      'Google Account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.account_circle, size: 64, color: Colors.red.shade400),
                            const SizedBox(height: 16),
                            const Text(
                              'Google Authentication',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your account is secured with Google authentication. To change your password, please use Google\'s account settings.',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ListTile(
                              leading: const Icon(Icons.link, color: Colors.blue),
                              title: const Text('Google Account Settings'),
                              subtitle: const Text('Manage your Google account password'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Opening Google account settings...')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
