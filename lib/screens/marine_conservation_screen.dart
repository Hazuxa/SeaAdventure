import 'package:flutter/material.dart';
import '../models/marine_conservation_model.dart';
import '../models/marine_creature.dart';

class MarineConservationScreen extends StatelessWidget {
  const MarineConservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Marine Conservation'),
          backgroundColor: Colors.deepPurple.shade700,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.warning_amber), text: 'Threats'),
              Tab(icon: Icon(Icons.pets), text: 'Endangered Species'),
              Tab(icon: Icon(Icons.eco), text: 'Take Action'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ThreatsTab(),
            EndangeredSpeciesTab(),
            TakeActionTab(),
          ],
        ),
      ),
    );
  }
}

class ThreatsTab extends StatelessWidget {
  const ThreatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade500, Colors.deepPurple.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.white, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Critical Ocean Threats',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Our oceans face unprecedented challenges. Understanding these threats is the first step toward protecting marine life for future generations.',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Threat cards
          Text(
            'Major Threats to Our Oceans',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade800,
            ),
          ),
          const SizedBox(height: 16),

          ...oceanThreats.map((threat) => _buildThreatCard(context, threat)),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildThreatCard(BuildContext context, OceanThreat threat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showThreatDetails(context, threat),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Color indicator
              Container(
                width: 8,
                height: 100,
                decoration: BoxDecoration(
                  color: threat.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),

              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: threat.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(threat.icon, color: threat.color, size: 28),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            threat.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: threat.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: threat.color.withOpacity(0.3)),
                          ),
                          child: Text(
                            threat.statistics,
                            style: TextStyle(
                              fontSize: 12,
                              color: threat.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      threat.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.arrow_forward, size: 16, color: Colors.deepPurple.shade600),
                        const SizedBox(width: 4),
                        Text(
                          'Learn more & take action',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.deepPurple.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThreatDetails(BuildContext context, OceanThreat threat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [threat.color.withOpacity(0.8), threat.color.withOpacity(0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(threat.icon, color: Colors.white, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        threat.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          threat.statistics,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Description
                _buildSectionTitle('About This Threat'),
                Text(threat.description, style: TextStyle(fontSize: 15, color: Colors.grey.shade800, height: 1.6)),
                const SizedBox(height: 24),

                // Impacts
                _buildSectionTitle('Environmental Impacts'),
                ...threat.impacts.map((impact) => _buildImpactItem(impact, threat.color)),
                const SizedBox(height: 24),

                // Solutions
                _buildSectionTitle('What You Can Do'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    children: threat.solutions.map((solution) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle, size: 18, color: Colors.green.shade600),
                          const SizedBox(width: 10),
                          Expanded(child: Text(solution, style: TextStyle(fontSize: 14, color: Colors.grey.shade800))),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImpactItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade700))),
        ],
      ),
    );
  }
}

class EndangeredSpeciesTab extends StatelessWidget {
  const EndangeredSpeciesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade500, Colors.red.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.pets, color: Colors.white, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Endangered Marine Species',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'These magnificent creatures are facing extinction. Learn about their struggles and how conservation efforts are working to save them.',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${endangeredSpecies.length} Species at Risk',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Species cards
          Text(
            'Species on the Brink',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade800,
            ),
          ),
          const SizedBox(height: 16),

          ...endangeredSpecies.map((species) => _buildSpeciesCard(context, species)),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSpeciesCard(BuildContext context, EndangeredOceanSpecies species) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showSpeciesDetails(context, species),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Urgency indicator
              Container(
                width: 8,
                height: 100,
                decoration: BoxDecoration(
                  color: species.urgencyColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),

              // Icon
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade100, Colors.cyan.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(species.icon, color: Colors.blue.shade700, size: 36),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      species.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      species.scientificName,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: species.urgencyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: species.urgencyColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        species.population,
                        style: TextStyle(
                          fontSize: 12,
                          color: species.urgencyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Threats: ${species.threats}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  void _showSpeciesDetails(BuildContext context, EndangeredOceanSpecies species) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [species.urgencyColor.withOpacity(0.8), species.urgencyColor.withOpacity(0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(species.icon, color: Colors.white, size: 56),
                      const SizedBox(height: 12),
                      Text(
                        species.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        species.scientificName,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          species.population,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Description
                _buildSectionTitle('About'),
                Text(species.description, style: TextStyle(fontSize: 15, color: Colors.grey.shade800, height: 1.6)),
                const SizedBox(height: 24),

                // Details
                _buildSectionTitle('Details'),
                _buildDetailRow('Habitat', species.habitat),
                _buildDetailRow('Primary Threats', species.threats),
                const SizedBox(height: 24),

                // Conservation Efforts
                _buildSectionTitle('Conservation Efforts'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.favorite, color: Colors.green.shade600, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          species.conservationEfforts,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
          ),
          Expanded(child: Text(value, style: TextStyle(color: Colors.grey.shade800))),
        ],
      ),
    );
  }
}

class TakeActionTab extends StatelessWidget {
  const TakeActionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade500, Colors.teal.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.eco, color: Colors.white, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Take Action Today',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Every action counts. Here are practical ways you can help protect our oceans and the incredible life they support.',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action cards
          Text(
            'What You Can Do',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 16),

          ...conservationActions.map((action) => _buildActionCard(action)),

          const SizedBox(height: 32),

          // Call to action
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade500, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.water, color: Colors.white, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'The Ocean Needs You',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Together, we can make a difference. Share this knowledge, take action, and inspire others to protect our marine ecosystems.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildActionCard(ConservationAction action) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: action.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(action.icon, color: action.color, size: 28),
        ),
        title: Text(
          action.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          action.description,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Steps to take:',
                  style: TextStyle(fontWeight: FontWeight.w600, color: action.color, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...action.steps.map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, size: 18, color: action.color),
                      const SizedBox(width: 10),
                      Expanded(child: Text(step, style: TextStyle(fontSize: 14, color: Colors.grey.shade700))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
