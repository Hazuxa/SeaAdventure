import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  final List<Map<String, dynamic>> emergencyContacts = const [
    {
      'name': 'Philippine Coast Guard (PCG)',
      'description': 'Search and rescue, maritime law enforcement, marine environmental protection',
      'hotline': '143',
      'phone': '(02) 8527-3880',
      'color': Colors.orange,
      'icon': Icons.local_police,
    },
    {
      'name': 'Coast Guard Action Center',
      'description': '24/7 Emergency hotline for maritime incidents',
      'hotline': '143',
      'phone': '(02) 8527-3877',
      'color': Colors.deepOrange,
      'icon': Icons.emergency,
    },
    {
      'name': 'Bureau of Fisheries and Aquatic Resources (BFAR)',
      'description': 'Illegal fishing reports, marine resources protection, fishery concerns',
      'hotline': null,
      'phone': '(02) 8927-5003',
      'color': Colors.blue,
      'icon': Icons.water,
    },
    {
      'name': 'BFAR Hotline',
      'description': 'Direct hotline for fishery violations and emergencies',
      'hotline': null,
      'phone': '0929-294-2782',
      'color': Colors.lightBlue,
      'icon': Icons.phone_in_talk,
    },
    {
      'name': 'Department of Environment and Natural Resources (DENR)',
      'description': 'Marine environmental protection, pollution reports, coastal management',
      'hotline': null,
      'phone': '(02) 8920-7680',
      'color': Colors.green,
      'icon': Icons.nature,
    },
    {
      'name': 'DENR Hotline',
      'description': 'Environmental complaints and emergency reports',
      'hotline': null,
      'phone': '(02) 8927-4789',
      'color': Colors.lightGreen,
      'icon': Icons.report_problem,
    },
    {
      'name': 'Philippine National Police Maritime Group',
      'description': 'Maritime crime, piracy, security at sea',
      'hotline': '911',
      'phone': '(02) 8723-0401',
      'color': Colors.red,
      'icon': Icons.security,
    },
    {
      'name': 'National Disaster Risk Reduction and Management Council (NDRRMC)',
      'description': 'Tsunami alerts, storm surges, maritime disasters',
      'hotline': '143',
      'phone': '(02) 8911-1406',
      'color': Colors.purple,
      'icon': Icons.warning,
    },
    {
      'name': 'PCG K9K Hotline',
      'description': 'Text hotline for maritime emergencies',
      'hotline': null,
      'phone': '0917-724-5192',
      'color': Colors.amber,
      'icon': Icons.message,
    },
    {
      'name': 'Marine Industry Authority (MARINA)',
      'description': 'Shipping accidents, maritime safety, vessel incidents',
      'hotline': null,
      'phone': '(02) 8526-4534',
      'color': Colors.teal,
      'icon': Icons.directions_boat,
    },
    {
      'name': 'Philippine Ports Authority (PPA)',
      'description': 'Port emergencies, harbor incidents',
      'hotline': null,
      'phone': '(02) 8527-4305',
      'color': Colors.indigo,
      'icon': Icons.anchor,
    },
    {
      'name': 'Local Government Unit (LGU) Hotline',
      'description': 'Coastal barangay emergencies, local rescue',
      'hotline': '911',
      'phone': 'Contact your local barangay',
      'color': Colors.brown,
      'icon': Icons.location_city,
    },
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber.replaceAll(RegExp(r'[()\s-]'), ''));
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Sea Contacts'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emergency Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade600, Colors.red.shade800],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.emergency,
                      size: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'For Peaceful Seas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Report maritime emergencies, illegal fishing, marine pollution, and sea-related incidents to Philippine government agencies.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.phone, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Dial 911 for Emergencies',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              const Text(
                'Quick Emergency Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      'Call 911',
                      Icons.emergency,
                      Colors.red,
                      () => _makePhoneCall('911'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      'Call 143',
                      Icons.local_police,
                      Colors.orange,
                      () => _makePhoneCall('143'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Contact List
              const Text(
                'Government Agencies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: emergencyContacts.length,
                itemBuilder: (context, index) {
                  final contact = emergencyContacts[index];
                  return _buildContactCard(context, contact);
                },
              ),
              const SizedBox(height: 24),

              // Important Notes
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.amber.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Important Reminders',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildReminderItem('Stay calm and provide clear information when calling'),
                    _buildReminderItem('Have your exact location ready (GPS coordinates if possible)'),
                    _buildReminderItem('Describe the emergency situation briefly and accurately'),
                    _buildReminderItem('Follow instructions from emergency responders'),
                    _buildReminderItem('For life-threatening emergencies, call 911 immediately'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, Map<String, dynamic> contact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (contact['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    contact['icon'] as IconData,
                    color: contact['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        contact['description'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                if (contact['hotline'] != null) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _makePhoneCall(contact['hotline'] as String),
                      icon: const Icon(Icons.emergency, size: 18),
                      label: Text('Hotline ${contact['hotline']}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _makePhoneCall(contact['phone'] as String),
                    icon: const Icon(Icons.phone, size: 18),
                    label: Text(contact['phone'] as String),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: contact['color'] as Color,
                      side: BorderSide(color: contact['color'] as Color),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.amber.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.amber.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
