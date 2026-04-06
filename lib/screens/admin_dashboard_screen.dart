import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../services/hybrid_auth_service.dart';
import '../services/sqlite_database_service.dart';
import '../services/dialog_service.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final HybridAuthService _authService = HybridAuthService();
  final UserDatabaseService _dbService = UserDatabaseService();
  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final users = await _dbService.getAllUsersForAdmin();
      final stats = await _dbService.getUserStatsForAdmin();

      setState(() {
        _users = users;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      developer.log('Error loading admin data: $e', name: 'AdminDashboard');
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredUsers {
    if (_searchQuery.isEmpty) return _users;

    return _users.where((user) {
      final email = user['email']?.toString().toLowerCase() ?? '';
      final username = user['username']?.toString().toLowerCase() ?? '';
      final displayName = user['display_name']?.toString().toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();

      return email.contains(query) ||
          username.contains(query) ||
          displayName.contains(query);
    }).toList();
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _authService.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user['display_name'] ?? user['username'] ?? 'User Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('ID', user['id']?.toString()),
              _buildDetailRow('UID', user['uid']?.toString()),
              _buildDetailRow('Email', user['email']?.toString()),
              _buildDetailRow('Username', user['username']?.toString()),
              _buildDetailRow('Display Name', user['display_name']?.toString()),
              _buildDetailRow('Phone', user['phone_number']?.toString()),
              _buildDetailRow('Provider', user['provider']?.toString()),
              _buildDetailRow('Admin', user['is_admin'] == 1 ? 'Yes' : 'No'),
              _buildDetailRow('Active', user['is_active'] == 1 ? 'Yes' : 'No'),
              _buildDetailRow('Created', _formatDate(user['created_at'])),
              _buildDetailRow('Last Login', _formatDate(user['last_login_at'])),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _editUser(user);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(
        timestamp is int ? timestamp : int.parse(timestamp.toString()),
      );
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  void _editUser(Map<String, dynamic> user) {
    final displayNameController = TextEditingController(
      text: user['display_name'] ?? '',
    );
    final phoneNumberController = TextEditingController(
      text: user['phone_number'] ?? '',
    );
    bool isActive = user['is_active'] == 1;
    bool isAdmin = user['is_admin'] == 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Edit ${user['username'] ?? 'User'}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: displayNameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Active'),
                  value: isActive,
                  onChanged: (value) => setState(() => isActive = value),
                ),
                SwitchListTile(
                  title: const Text('Admin'),
                  value: isAdmin,
                  onChanged: (value) => setState(() => isAdmin = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await _dbService.updateUserAdmin(
                  user['id'],
                  displayName: displayNameController.text.isEmpty
                      ? null
                      : displayNameController.text,
                  phoneNumber: phoneNumberController.text.isEmpty
                      ? null
                      : phoneNumberController.text,
                  isActive: isActive,
                  isAdmin: isAdmin,
                );

                if (success > 0) {
                  Navigator.of(context).pop();
                  _loadData(); // Refresh data
                  DialogService.showSuccessDialog(
                    context,
                    title: 'Success',
                    message: 'User updated successfully!',
                    buttonText: 'OK',
                  );
                } else {
                  DialogService.showErrorDialog(
                    context,
                    title: 'Error',
                    message: 'Failed to update user. Please try again.',
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete ${user['username'] ?? 'this user'}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await _dbService.deleteUserByAdmin(user['id']);

              if (success > 0) {
                Navigator.of(context).pop();
                _loadData(); // Refresh data
                DialogService.showSuccessDialog(
                  context,
                  title: 'Success',
                  message: 'User deleted successfully!',
                  buttonText: 'OK',
                );
              } else {
                DialogService.showErrorDialog(
                  context,
                  title: 'Error',
                  message: 'Failed to delete user. Please try again.',
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Cards
                    if (_stats != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Users',
                              _stats!['total'].toString(),
                              Icons.people,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              'Admins',
                              _stats!['admin'].toString(),
                              Icons.admin_panel_settings,
                              Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Local',
                              _stats!['local'].toString(),
                              Icons.email,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              'Google',
                              _stats!['google'].toString(),
                              Icons.search,
                              Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Search Bar
                    TextField(
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search users...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Users List
                    Text(
                      'Users (${_filteredUsers.length})',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: user['is_admin'] == 1
                                  ? Colors.purple
                                  : Colors.blue,
                              child: Icon(
                                user['is_admin'] == 1
                                    ? Icons.admin_panel_settings
                                    : Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              user['display_name'] ??
                                  user['username'] ??
                                  'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user['email'] ?? ''),
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(
                                        user['provider'] ?? 'Unknown',
                                      ),
                                      backgroundColor: _getProviderColor(
                                        user['provider'],
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    if (user['is_admin'] == 1)
                                      const Chip(
                                        label: Text('ADMIN'),
                                        backgroundColor: Colors.purple,
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                switch (value) {
                                  case 'view':
                                    _showUserDetails(user);
                                    break;
                                  case 'edit':
                                    _editUser(user);
                                    break;
                                  case 'delete':
                                    _deleteUser(user);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Row(
                                    children: [
                                      Icon(Icons.visibility),
                                      SizedBox(width: 8),
                                      Text('View Details'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => _showUserDetails(user),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProviderColor(String? provider) {
    switch (provider) {
      case 'google':
        return Colors.red;
      case 'local':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
