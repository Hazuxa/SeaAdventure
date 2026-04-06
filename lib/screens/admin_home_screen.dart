import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../services/hybrid_auth_service.dart';
import '../services/sqlite_database_service.dart';
import '../services/dialog_service.dart';
import 'login_screen.dart';
import 'admin_users_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final HybridAuthService _authService = HybridAuthService();
  final UserDatabaseService _dbService = UserDatabaseService();
  Map<String, dynamic>? _stats;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    
    try {
      final stats = await _dbService.getUserStatsForAdmin();
      
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      developer.log('Error loading admin stats: $e', name: 'AdminHomeScreen');
      setState(() => _isLoading = false);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadStats,
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
              // Already on dashboard
              break;
            case 'users':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminUsersScreen()),
              );
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
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome, Administrator!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Manage your application from here',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            'Manage Users',
                            Icons.people,
                            Colors.blue,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AdminUsersScreen()),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildQuickActionCard(
                            'View Statistics',
                            Icons.analytics,
                            Colors.green,
                            () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Detailed statistics coming soon!')),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Statistics Cards
                    if (_stats != null) ...[
                      const Text(
                        'System Statistics',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard('Total Users', _stats!['total'].toString(), Icons.people, Colors.blue),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard('Admin Users', _stats!['admin'].toString(), Icons.admin_panel_settings, Colors.purple),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard('Local Users', _stats!['local'].toString(), Icons.email, Colors.green),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard('Google Users', _stats!['google'].toString(), Icons.search, Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Additional Info
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'System Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow('Regular Users', (_stats!['regular'] ?? 0).toString()),
                              _buildInfoRow('Database Version', '2.0'),
                              _buildInfoRow('Last Updated', DateTime.now().toString().substring(0, 19)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
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
          Text(
            value,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

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
