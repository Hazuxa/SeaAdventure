import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../services/hybrid_auth_service.dart';
import '../services/sqlite_database_service.dart';
import '../services/dialog_service.dart';
import 'settings_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final HybridAuthService _authService = HybridAuthService();
  final UserDatabaseService _dbService = UserDatabaseService();
  Map<String, dynamic>? _currentUser;
  bool _isLoading = false;

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
      developer.log('Error loading current user: $e', name: 'UserInfoScreen');
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
          phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
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
          message: 'For Google/Firebase accounts, profile changes are managed through your Google account settings.',
        );
      }
    } catch (e) {
      developer.log('Error updating profile: $e', name: 'UserInfoScreen');
      DialogService.showErrorDialog(
        context,
        title: 'Error',
        message: 'Failed to update profile. Please try again.',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
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
                                          errorBuilder: (context, error, stackTrace) {
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
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getAccountTypeColor().withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: _getAccountTypeColor(), width: 1),
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
                          _buildInfoRow('Username', _currentUser?['username'] ?? 'N/A'),
                          _buildInfoRow('Account ID', _currentUser?['uid']?.toString().substring(0, 8) ?? 'N/A'),
                          _buildInfoRow('Provider', _currentUser?['provider'] ?? 'N/A'),
                          _buildInfoRow('Source', _currentUser?['source'] ?? 'N/A'),
                          _buildInfoRow('Phone', _currentUser?['phoneNumber'] ?? 'Not set'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Edit Profile Section
                  const Text(
                    'Edit Profile',
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
                            controller: _displayNameController,
                            decoration: const InputDecoration(
                              labelText: 'Display Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              helperText: 'This name will be displayed in your profile',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number (Optional)',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                              helperText: 'Add your phone number for account recovery',
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
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.right,
            ),
          ),
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
    _displayNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
