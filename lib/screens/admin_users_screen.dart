import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../services/hybrid_auth_service.dart';
import '../services/sqlite_database_service.dart';
import '../services/dialog_service.dart';
import 'login_screen.dart';
import 'admin_home_screen.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final HybridAuthService _authService = HybridAuthService();
  final UserDatabaseService _dbService = UserDatabaseService();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    
    try {
      final users = await _dbService.getAllUsersForAdmin();
      
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      developer.log('Error loading admin users: $e', name: 'AdminUsersScreen');
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
          Expanded(
            child: Text(value ?? 'N/A'),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(
        timestamp is int ? timestamp : int.parse(timestamp.toString())
      );
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  void _editUser(Map<String, dynamic> user) {
    final displayNameController = TextEditingController(text: user['display_name'] ?? '');
    final phoneNumberController = TextEditingController(text: user['phone_number'] ?? '');
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
                  displayName: displayNameController.text.isEmpty ? null : displayNameController.text,
                  phoneNumber: phoneNumberController.text.isEmpty ? null : phoneNumberController.text,
                  isActive: isActive,
                  isAdmin: isAdmin,
                );

                if (success > 0) {
                  Navigator.of(context).pop();
                  _loadUsers(); // Refresh data
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
        content: Text('Are you sure you want to delete ${user['username'] ?? 'this user'}? This action cannot be undone.'),
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
                _loadUsers(); // Refresh data
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
        title: const Text('Manage Users'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadUsers,
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
      drawer: AdminDrawer(
        onMenuSelected: (item) {
          Navigator.pop(context);
          switch (item) {
            case 'dashboard':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
              );
              break;
            case 'users':
              // Already on users screen
              break;
            case 'settings':
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon!')),
              );
              break;
          }
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUsers,
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search users...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  
                  // Users List
                  Expanded(
                    child: _filteredUsers.isEmpty
                        ? const Center(
                            child: Text(
                              'No users found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: user['is_admin'] == 1 ? Colors.purple : Colors.blue,
                                    child: Icon(
                                      user['is_admin'] == 1 ? Icons.admin_panel_settings : Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    user['display_name'] ?? user['username'] ?? 'Unknown',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(user['email'] ?? ''),
                                      Row(
                                        children: [
                                          Chip(
                                            label: Text(user['provider'] ?? 'Unknown'),
                                            backgroundColor: _getProviderColor(user['provider']),
                                            labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                          const SizedBox(width: 4),
                                          if (user['is_admin'] == 1)
                                            const Chip(
                                              label: Text('ADMIN'),
                                              backgroundColor: Colors.purple,
                                              labelStyle: TextStyle(color: Colors.white, fontSize: 12),
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
                                            Text('Delete', style: TextStyle(color: Colors.red)),
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

// Reuse the AdminDrawer from admin_home_screen.dart
class AdminDrawer extends StatelessWidget {
  final Function(String) onMenuSelected;

  const AdminDrawer({super.key, required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Admin Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: 40,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin Panel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'System Administrator',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Menu Items
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.deepPurple),
            title: const Text('Dashboard'),
            subtitle: const Text('Overview and statistics'),
            onTap: () => onMenuSelected('dashboard'),
          ),
          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.people, color: Colors.blue),
            title: const Text('Manage Users'),
            subtitle: const Text('View and manage all users'),
            onTap: () => onMenuSelected('users'),
          ),
          
          ListTile(
            leading: const Icon(Icons.analytics, color: Colors.green),
            title: const Text('Analytics'),
            subtitle: const Text('Detailed statistics'),
            onTap: () => onMenuSelected('analytics'),
          ),
          
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.orange),
            title: const Text('Settings'),
            subtitle: const Text('System configuration'),
            onTap: () => onMenuSelected('settings'),
          ),
          
          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            subtitle: const Text('Sign out of admin panel'),
            onTap: () {
              Navigator.pop(context);
              // The logout will be handled by the AppBar action
            },
          ),
        ],
      ),
    );
  }
}
