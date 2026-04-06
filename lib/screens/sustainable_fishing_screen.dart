import 'package:flutter/material.dart';
import '../models/sustainable_fishing_model.dart';
import 'dart:developer' as developer;

class SustainableFishingScreen extends StatelessWidget {
  const SustainableFishingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sustainable Fishing'),
          backgroundColor: Colors.teal.shade700,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.phishing), text: 'Species Guide'),
              Tab(icon: Icon(Icons.warning), text: 'Overfishing'),
              Tab(icon: Icon(Icons.eco), text: 'Best Practices'),
              Tab(icon: Icon(Icons.info), text: 'About'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SpeciesGuideTab(),
            OverfishingImpactTab(),
            BestPracticesTab(),
            AboutSustainabilityTab(),
          ],
        ),
      ),
    );
  }
}

class SpeciesGuideTab extends StatelessWidget {
  const SpeciesGuideTab({super.key});

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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade400, Colors.teal.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.phishing, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Fish Species Guide',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Learn which species are safe to fish, which are protected, and how to fish responsibly.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Legend
          _buildLegend(),
          const SizedBox(height: 20),

          // Species List
          Text(
            'Fish Species',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade800,
            ),
          ),
          const SizedBox(height: 12),

          // Species cards
          ...sampleFishSpecies.map((species) => _buildSpeciesCard(context, species)),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Legend',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildLegendItem(Colors.green, 'Safe to Fish', Icons.check_circle),
              _buildLegendItem(Colors.blue, 'Regulated', Icons.gavel),
              _buildLegendItem(Colors.orange, 'Protected', Icons.shield),
              _buildLegendItem(Colors.red, 'Endangered', Icons.warning),
              _buildLegendItem(Colors.red.shade900, 'Critically Endangered', Icons.error),
              _buildLegendItem(Colors.purple, 'Banned', Icons.block),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSpeciesCard(BuildContext context, FishSpecies species) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showSpeciesDetails(context, species),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Status indicator
              Container(
                width: 8,
                height: 80,
                decoration: BoxDecoration(
                  color: species.fishingStatusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),

              // Image placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.water, color: Colors.teal.shade300, size: 30),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      species.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      species.scientificName,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: species.fishingStatusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: species.fishingStatusColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(species.fishingStatusIcon, color: species.fishingStatusColor, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            species.fishingStatusText,
                            style: TextStyle(fontSize: 10, color: species.fishingStatusColor, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
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

  void _showSpeciesDetails(BuildContext context, FishSpecies species) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: species.fishingStatusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(species.fishingStatusIcon, color: species.fishingStatusColor, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(species.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          Text(species.scientificName, style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Status badge
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: species.fishingStatusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: species.fishingStatusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(species.fishingStatusIcon, color: species.fishingStatusColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              species.fishingStatusText,
                              style: TextStyle(fontWeight: FontWeight.bold, color: species.fishingStatusColor),
                            ),
                            Text(
                              species.fishingGuidelines,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                _buildSectionTitle('About'),
                Text(species.description, style: TextStyle(color: Colors.grey.shade800, height: 1.5)),
                const SizedBox(height: 20),

                // Ecosystem Role
                _buildSectionTitle('Ecosystem Role'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        species.ecosystemRoleText,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal.shade700),
                      ),
                      const SizedBox(height: 4),
                      Text(species.ecosystemImpact, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Details
                _buildSectionTitle('Details'),
                _buildDetailRow('Habitat', species.habitat),
                _buildDetailRow('Size', species.size),
                _buildDetailRow('Population Trend', species.populationTrend),
                const SizedBox(height: 20),

                // Fishing Info (if applicable)
                if (species.canFish) ...[
                  _buildSectionTitle('Fishing Information'),
                  _buildDetailRow('Seasonality', species.seasonality),
                  _buildDetailRow('Catch Limit', species.catchLimit),
                  _buildDetailRow('Minimum Size', species.minimumSize),
                  const SizedBox(height: 12),
                ],

                // Regulations
                if (species.regulations.isNotEmpty) ...[
                  _buildSectionTitle('Regulations'),
                  ...species.regulations.map((reg) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, size: 14, color: Colors.teal.shade600),
                        const SizedBox(width: 8),
                        Expanded(child: Text(reg, style: TextStyle(fontSize: 13, color: Colors.grey.shade700))),
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),
                ],

                // Threats
                if (species.threats.isNotEmpty) ...[
                  _buildSectionTitle('Threats'),
                  ...species.threats.map((threat) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning_amber, size: 14, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(child: Text(threat, style: TextStyle(fontSize: 13, color: Colors.grey.shade700))),
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),
                ],

                // Alternatives
                if (species.sustainableAlternatives.isNotEmpty) ...[
                  _buildSectionTitle('Sustainable Alternatives'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: species.sustainableAlternatives.map((alt) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(alt, style: TextStyle(fontSize: 12, color: Colors.green.shade800, fontWeight: FontWeight.w500)),
                    )).toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                // Fun Facts
                if (species.funFacts.isNotEmpty) ...[
                  _buildSectionTitle('Did You Know?'),
                  ...species.funFacts.map((fact) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb, size: 16, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(child: Text(fact, style: TextStyle(fontSize: 13, color: Colors.grey.shade700))),
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),
                ],

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
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade600, fontSize: 13)),
          ),
          Expanded(child: Text(value, style: TextStyle(color: Colors.grey.shade800, fontSize: 13))),
        ],
      ),
    );
  }
}

class OverfishingImpactTab extends StatelessWidget {
  const OverfishingImpactTab({super.key});

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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.red.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The Impact of Overfishing',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Understanding how overfishing threatens our oceans and what we can do about it.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Statistics
          _buildStatisticsCard(),
          const SizedBox(height: 20),

          // Impact cards
          Text(
            'Major Impacts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red.shade800),
          ),
          const SizedBox(height: 12),

          ...overfishingImpacts.map((impact) => _buildImpactCard(impact)),

          const SizedBox(height: 20),

          // Call to action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.eco, color: Colors.blue.shade700, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Every Action Counts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                ),
                const SizedBox(height: 4),
                Text(
                  'By making sustainable choices, you help protect our oceans for future generations.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Text('By the Numbers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange.shade800)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatItem('90%', 'Large fish gone', Colors.orange),
              _buildStatItem('34%', 'Fish stocks overfished', Colors.red),
              _buildStatItem('60%', 'Sustainably fished', Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Source: FAO State of World Fisheries 2024',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildImpactCard(OverfishingImpact impact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: impact.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(impact.icon, color: impact.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    impact.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(impact.description, style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5)),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            ...impact.consequences.map((consequence) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_right, size: 16, color: impact.color),
                  const SizedBox(width: 8),
                  Expanded(child: Text(consequence, style: TextStyle(fontSize: 13, color: Colors.grey.shade700))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class BestPracticesTab extends StatelessWidget {
  const BestPracticesTab({super.key});

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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.eco, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Sustainable Fishing Practices',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Simple steps you can take to fish responsibly and protect our oceans.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quick checklist
          _buildQuickChecklist(),
          const SizedBox(height: 20),

          // Practice cards
          Text(
            'Best Practices',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade800),
          ),
          const SizedBox(height: 12),

          ...sustainablePractices.map((practice) => _buildPracticeCard(practice)),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildQuickChecklist() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Checklist Before Fishing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal.shade800)),
          const SizedBox(height: 12),
          _buildChecklistItem('Check local regulations and seasons'),
          _buildChecklistItem('Know your target species and limits'),
          _buildChecklistItem('Identify protected species'),
          _buildChecklistItem('Bring proper gear for catch and release'),
          _buildChecklistItem('Have measuring tools ready'),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_box_outline_blank, size: 18, color: Colors.teal.shade600),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade700))),
        ],
      ),
    );
  }

  Widget _buildPracticeCard(SustainablePractice practice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(practice.icon, color: Colors.green.shade700),
        ),
        title: Text(practice.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(practice.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Text('Tips:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green.shade800, fontSize: 14)),
                const SizedBox(height: 8),
                ...practice.tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, size: 14, color: Colors.green.shade600),
                      const SizedBox(width: 8),
                      Expanded(child: Text(tip, style: TextStyle(fontSize: 13, color: Colors.grey.shade700))),
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

class AboutSustainabilityTab extends StatelessWidget {
  const AboutSustainabilityTab({super.key});

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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'About Sustainable Fishing',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Learn what sustainable fishing means and why it matters.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // What is sustainable fishing
          _buildInfoCard(
            'What is Sustainable Fishing?',
            Icons.help,
            Colors.blue,
            'Sustainable fishing means catching fish in a way that maintains healthy fish populations, protects ecosystems, and ensures fishing can continue for future generations. It involves respecting catch limits, avoiding endangered species, and using fishing methods that minimize environmental damage.',
          ),

          // Why it matters
          _buildInfoCard(
            'Why Does It Matter?',
            Icons.favorite,
            Colors.red,
            'Our oceans provide food for billions of people and support countless livelihoods. Overfishing threatens this vital resource, leading to ecosystem collapse, economic hardship for fishing communities, and loss of marine biodiversity. Sustainable fishing ensures healthy oceans for generations to come.',
          ),

          // How to identify sustainable seafood
          _buildInfoCard(
            'How to Identify Sustainable Seafood',
            Icons.verified,
            Colors.green,
            'Look for certifications like MSC (Marine Stewardship Council) or ASC (Aquaculture Stewardship Council). Use seafood watch apps and guides. Ask your fishmonger or restaurant about the source of their seafood. Choose local, seasonal options when possible.',
          ),

          // Conservation organizations
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.groups, color: Colors.purple.shade700),
                    const SizedBox(width: 12),
                    Text(
                      'Organizations Making a Difference',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple.shade800),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildOrgItem('Marine Stewardship Council (MSC)', 'Certifies sustainable fisheries'),
                _buildOrgItem('Monterey Bay Aquarium', 'Seafood Watch program and education'),
                _buildOrgItem('Ocean Conservancy', 'Policy and conservation programs'),
                _buildOrgItem('WWF', 'Marine conservation initiatives'),
                _buildOrgItem('Oceana', 'Advocacy for ocean protection'),
              ],
            ),
          ),

          // Additional resources
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.book, color: Colors.amber.shade700),
                    const SizedBox(width: 12),
                    Text(
                      'Additional Resources',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber.shade800),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildResourceItem('Download Seafood Watch App', 'For real-time recommendations'),
                _buildResourceItem('Check Local Fishing Regulations', 'Before every trip'),
                _buildResourceItem('Join Local Conservation Groups', 'Get involved in your community'),
                _buildResourceItem('Report Illegal Fishing', 'Help protect our waters'),
              ],
            ),
          ),

          // Philippines Resources
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.flag, color: Colors.teal.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Philippines: Help Protect Our Seas',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Contact these Philippine government agencies to report illegal fishing, participate in conservation programs, or seek assistance with sustainable fishing practices.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),
                ),
                const SizedBox(height: 12),
                _buildPhilippinesAgencyItem(
                  'BFAR - Bureau of Fisheries and Aquatic Resources',
                  'Report illegal fishing, get fishing permits, sustainable aquaculture support',
                  '(02) 8920-1738',
                  'bfar.gov.ph',
                ),
                _buildPhilippinesAgencyItem(
                  'DENR - Department of Environment and Natural Resources',
                  'Marine protected areas, coastal management, environmental violations',
                  '(02) 8924-6031',
                  'denr.gov.ph',
                ),
                _buildPhilippinesAgencyItem(
                  'Philippine Coast Guard',
                  'Hotline for maritime crimes including illegal fishing at sea',
                  '143 or (02) 8527-8481',
                  'coastguard.gov.ph',
                ),
                _buildPhilippinesAgencyItem(
                  'PCSD - Palawan Council for Sustainable Development',
                  'For Palawan residents: marine conservation and sustainable development',
                  '(048) 434-5756',
                  'pcsd.gov.ph',
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.report, color: Colors.red.shade700, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Report Illegal Fishing',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade800, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Call BFAR hotline (02) 8920-1738 or dial 911 for immediate response. Provide location, date/time, and description of activity. Photos and GPS coordinates help investigations.',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, IconData icon, Color color, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color.withOpacity(0.8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildOrgItem(String name, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_right, size: 16, color: Colors.purple.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.purple.shade800, fontSize: 13)),
                Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.link, size: 16, color: Colors.amber.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.amber.shade800, fontSize: 13)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhilippinesAgencyItem(String name, String description, String contact, String website) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.teal.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance, size: 16, color: Colors.teal.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal.shade800, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone, size: 12, color: Colors.teal.shade600),
                      const SizedBox(width: 4),
                      Text(
                        contact,
                        style: TextStyle(fontSize: 12, color: Colors.teal.shade700, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.language, size: 12, color: Colors.teal.shade600),
                      const SizedBox(width: 4),
                      Text(
                        website,
                        style: TextStyle(fontSize: 12, color: Colors.blue.shade600, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
