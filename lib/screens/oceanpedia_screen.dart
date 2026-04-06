import 'package:flutter/material.dart';
import '../models/marine_creature.dart';
import 'creature_detail_screen.dart';

class OceanpediaScreen extends StatefulWidget {
  const OceanpediaScreen({super.key});

  @override
  State<OceanpediaScreen> createState() => _OceanpediaScreenState();
}

class _OceanpediaScreenState extends State<OceanpediaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<MarineCreature> _allCreatures = [];
  List<MarineCreature> _filteredCreatures = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadCreatures();
    _searchController.addListener(_filterCreatures);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadCreatures() {
    _allCreatures = _getSampleCreatures();
    _filteredCreatures = List.from(_allCreatures);
  }

  void _filterCreatures() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCreatures = List.from(_allCreatures);
      } else {
        _filteredCreatures = _allCreatures.where((creature) {
          return creature.name.toLowerCase().contains(query) ||
              creature.scientificName.toLowerCase().contains(query) ||
              creature.description.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  List<MarineCreature> _getCreaturesByType(CreatureType type) {
    return _filteredCreatures.where((c) => c.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.cyan.shade300,
                Colors.blue.shade500,
                Colors.blue.shade800,
                Colors.indigo.shade900,
                Colors.deepPurple.shade900,
              ],
              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header with depth indicator
                _buildHeader(),
                
                // Search Bar
                _buildSearchBar(),
                
                // Depth Zone Tabs
                _buildDepthTabs(),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCreatureList(_filteredCreatures, 'surface'),
                      _buildCreatureList(_getCreaturesByType(CreatureType.fish), 'shallow'),
                      _buildCreatureList(_getCreaturesByType(CreatureType.coral), 'reef'),
                      _buildCreatureList(_getCreaturesByType(CreatureType.deepSea), 'abyss'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Water icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.water,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Oceanpedia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Depth Explorer • ${_allCreatures.length} Species',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.thermostat, color: Colors.white.withOpacity(0.9), size: 16),
                const SizedBox(width: 4),
                Text(
                  '4°C',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search marine life...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.8)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.7), size: 20),
                  onPressed: () => _searchController.clear(),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildDepthTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan.shade400, Colors.blue.shade400],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.6),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        tabs: [
          _buildDepthTab('All', Icons.waves),
          _buildDepthTab('Fish', Icons.water),
          _buildDepthTab('Coral', Icons.grain),
          _buildDepthTab('Deep', Icons.nights_stay),
        ],
      ),
    );
  }

  Widget _buildDepthTab(String label, IconData icon) {
    return Tab(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildCreatureList(List<MarineCreature> creatures, String depthZone) {
    if (creatures.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'No creatures found',
              style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.6)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: creatures.length,
      itemBuilder: (context, index) {
        return _buildCreatureCard(creatures[index], depthZone, index);
      },
    );
  }

  Widget _buildCreatureCard(MarineCreature creature, String depthZone, int index) {
    // Different styling based on depth zone
    final zoneColors = {
      'surface': [Colors.cyan.shade100, Colors.blue.shade200],
      'shallow': [Colors.blue.shade100, Colors.teal.shade200],
      'reef': [Colors.teal.shade100, Colors.green.shade200],
      'abyss': [Colors.indigo.shade200, Colors.purple.shade300],
    };
    
    final zoneGlowColors = {
      'surface': Colors.cyan.shade300,
      'shallow': Colors.blue.shade300,
      'reef': Colors.teal.shade300,
      'abyss': Colors.purple.shade400,
    };

    final colors = zoneColors[depthZone] ?? zoneColors['surface']!;
    final glowColor = zoneGlowColors[depthZone] ?? Colors.blue.shade300;
    
    // Bioluminescent effect for deep sea
    final isDeepSea = creature.type == CreatureType.deepSea;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDeepSea 
                ? Colors.cyan.shade400.withOpacity(0.3)
                : glowColor.withOpacity(0.2),
            blurRadius: isDeepSea ? 15 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.95),
                Colors.white.withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: isDeepSea 
                  ? Colors.cyan.shade300.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5),
              width: isDeepSea ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatureDetailScreen(creature: creature),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Creature icon with depth-themed background
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: colors[1].withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      creature.typeIcon,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                creature.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isDeepSea)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade400.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.cyan.shade400.withOpacity(0.4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.bolt, color: Colors.cyan.shade600, size: 12),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Bio',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.cyan.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          creature.scientificName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildStatusBadge(creature.conservationStatusText, creature.conservationStatusColor),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 10,
                                    color: Colors.blue.shade600,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    _getDepthForCreature(creature.type),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.w500,
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

                  // Arrow with glow effect
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue.shade600,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getDepthForCreature(CreatureType type) {
    switch (type) {
      case CreatureType.fish:
        return '0-200m';
      case CreatureType.coral:
        return '0-50m';
      case CreatureType.deepSea:
        return '1000m+';
      default:
        return 'Varies';
    }
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<MarineCreature> _getSampleCreatures() {
    return [
      MarineCreature(
        id: '1',
        name: 'Clownfish',
        scientificName: 'Amphiprioninae',
        type: CreatureType.fish,
        description: 'Clownfish are colorful marine fish that form symbiotic relationships with sea anemones. They are native to warmer waters of the Indian and Pacific oceans.',
        uniqueTraits: [
          'Forms symbiotic relationship with sea anemones',
          'Can change sex during their lifetime',
          'Has a protective mucus layer that prevents stings',
          'Lives in a strict social hierarchy'
        ],
        trivia: [
          'Clownfish are all born male, with the dominant fish changing to female when needed.',
          'They can live up to 10 years in the wild.',
          'The movie "Finding Nemo" greatly increased their popularity.',
          'They communicate through popping and clicking sounds.'
        ],
        habitat: 'Coral reefs and lagoons',
        diet: 'Omnivore - algae, zooplankton, and anemone parasites',
        size: '3-4 inches (8-10 cm)',
        lifespan: '6-10 years',
        conservationStatus: ConservationStatus.leastConcern,
        imageUrl: '',
        funFacts: [
          'Clownfish are terrible swimmers and tend to stay close to their anemone home.',
          'They lay up to 1,000 eggs at a time.',
          'The male clownfish is the primary caregiver for the eggs.'
        ],
        location: 'Indo-Pacific Ocean, Red Sea, Great Barrier Reef',
        behavior: 'Territorial and social, living in small groups with a dominant breeding pair'
      ),
      MarineCreature(
        id: '2',
        name: 'Great White Shark',
        scientificName: 'Carcharodon carcharias',
        type: CreatureType.fish,
        description: 'The great white shark is a large predatory fish found in coastal waters around the world. It is known for its size and powerful predatory behavior.',
        uniqueTraits: [
          'Largest predatory fish in the ocean',
          'Can detect blood from miles away',
          'Has multiple rows of replaceable teeth',
          'Can breach completely out of the water'
        ],
        trivia: [
          'Great whites can go up to three months without eating.',
          'They have been around for over 400 million years.',
          'Their liver can make up 24% of their body weight.',
          'They can swim at speeds up to 35 mph (56 km/h).'
        ],
        habitat: 'Coastal and offshore waters',
        diet: 'Carnivore - fish, seals, sea lions, and dolphins',
        size: '15-20 feet (4.6-6.1 m)',
        lifespan: '70+ years',
        conservationStatus: ConservationStatus.vulnerable,
        imageUrl: '',
        funFacts: [
          'Great whites have about 300 teeth arranged in up to 7 rows.',
          'They can detect one drop of blood in 25 gallons of water.',
          'They are responsible for most unprovoked shark attacks on humans.'
        ],
        location: 'Coastal waters of all major oceans',
        behavior: 'Solitary hunter, migratory patterns following food sources'
      ),
      MarineCreature(
        id: '3',
        name: 'Brain Coral',
        scientificName: 'Faviidae family',
        type: CreatureType.coral,
        description: 'Brain coral is a type of stony coral named for its resemblance to a human brain. These corals are essential reef builders and provide habitat for many marine species.',
        uniqueTraits: [
          'Grows in a brain-like pattern',
          'Can live for hundreds of years',
          'Forms massive colonies',
          'Provides shelter for many fish species'
        ],
        trivia: [
          'Some brain corals can live over 900 years.',
          'They are nocturnal, extending tentacles at night to feed.',
          'Brain corals can grow up to 6 feet tall.',
          'They get their color from algae living in their tissues.'
        ],
        habitat: 'Shallow tropical and subtropical waters',
        diet: 'Carnivore - zooplankton, small fish',
        size: 'Up to 6 feet (1.8 m) in diameter',
        lifespan: '200-900 years',
        conservationStatus: ConservationStatus.vulnerable,
        imageUrl: '',
        funFacts: [
          'Brain corals have a symbiotic relationship with zooxanthellae algae.',
          'They can reproduce both sexually and asexually.',
          'Their growth rate is only about 0.3-2 cm per year.'
        ],
        location: 'Caribbean Sea, Atlantic Ocean, Indo-Pacific',
        behavior: 'Sessile (stationary), extends feeding tentacles at night'
      ),
      MarineCreature(
        id: '4',
        name: 'Anglerfish',
        scientificName: 'Lophiiformes',
        type: CreatureType.deepSea,
        description: 'Anglerfish are deep-sea predators known for their distinctive method of predation using a bioluminescent lure to attract prey in the dark depths.',
        uniqueTraits: [
          'Bioluminescent lure on head',
          'Enormous mouth with hinged jaws',
          'Can swallow prey larger than itself',
          'Extreme sexual dimorphism'
        ],
        trivia: [
          'Male anglerfish are tiny and fuse with females to reproduce.',
          'Their lure can glow in the complete darkness of the deep sea.',
          'Some species can live at depths of 3,000 feet (900 m).',
          'They have been around for over 100 million years.'
        ],
        habitat: 'Deep ocean waters, below 1,000 feet',
        diet: 'Carnivore - fish, crustaceans, anything they can swallow',
        size: '8 inches to 3 feet (20 cm to 1 m) depending on species',
        lifespan: '20-30 years',
        conservationStatus: ConservationStatus.dataDeficient,
        imageUrl: '',
        funFacts: [
          'The male anglerfish is called a "sexual parasite" when fused to female.',
          'Their stomachs can expand to accommodate prey twice their size.',
          'They have no swim bladder, allowing them to maintain depth.'
        ],
        location: 'Worldwide in deep ocean waters',
        behavior: 'Ambush predator, uses bioluminescent lure to attract prey'
      ),
      MarineCreature(
        id: '5',
        name: 'Sea Turtle',
        scientificName: 'Cheloniidae',
        type: CreatureType.fish,
        description: 'Sea turtles are ancient marine reptiles that have existed for over 100 million years. They are known for their long-distance migrations and nesting behavior.',
        uniqueTraits: [
          'Can hold breath for hours',
          'Migrate thousands of miles',
          'Return to birth beach to nest',
          'Live in all oceans except the Arctic'
        ],
        trivia: [
          'Sea turtles can live over 80 years.',
          'Temperature determines the sex of hatchlings.',
          'They can navigate using Earth\'s magnetic field.',
          'Some species can travel 10,000 miles annually.'
        ],
        habitat: 'Tropical and subtropical marine waters',
        diet: 'Varies by species - jellyfish, seaweed, crabs',
        size: '2-6 feet (60-180 cm)',
        lifespan: '50-80 years',
        conservationStatus: ConservationStatus.endangered,
        imageUrl: '',
        funFacts: [
          'Sea turtles cry salty tears to remove excess salt.',
          'They cannot retract their heads into their shells.',
          'Baby turtles are called "hatchlings".'
        ],
        location: 'All tropical and subtropical oceans',
        behavior: 'Solitary except during migration and nesting'
      ),
      MarineCreature(
        id: '6',
        name: 'Vampire Squid',
        scientificName: 'Vampyroteuthis infernalis',
        type: CreatureType.deepSea,
        description: 'Despite its name, the vampire squid is not a true squid and feeds on marine snow rather than blood. It lives in the deep ocean where little to no light penetrates.',
        uniqueTraits: [
          'Bioluminescent photophores',
          'Can invert its mantle over body like a cloak',
          'Filament-like arms instead of tentacles',
          'Produces bioluminescent mucus'
        ],
        trivia: [
          'Its scientific name means "vampire squid from hell".',
          'It\'s the only living member of its order.',
          'Can survive in oxygen minimum zones.',
          'Lives at depths where oxygen levels are too low for most animals.'
        ],
        habitat: 'Deep ocean, 2,000-3,000 feet depth',
        diet: 'Detritivore - marine snow, dead organisms',
        size: '6 inches (15 cm)',
        lifespan: 'Unknown, estimated 8-10 years',
        conservationStatus: ConservationStatus.leastConcern,
        imageUrl: '',
        funFacts: [
          'When threatened, it displays a "fireworks" display of bioluminescence.',
          'It has the largest eyes relative to body size of any animal.',
          'Instead of ink, it ejects bioluminescent mucus.'
        ],
        location: 'Tropical and subtropical deep waters worldwide',
        behavior: 'Slow-moving, uses bioluminescence for camouflage and communication'
      ),
      MarineCreature(
        id: '7',
        name: 'Staghorn Coral',
        scientificName: 'Acropora cervicornis',
        type: CreatureType.coral,
        description: 'Staghorn coral is a fast-growing branching coral that resembles antlers. It is one of the most important reef-building corals in the Caribbean.',
        uniqueTraits: [
          'Fastest growing coral species',
          'Branching structure provides habitat',
          'Fragments easily and reattaches',
          'Sensitive to water temperature changes'
        ],
        trivia: [
          'Can grow up to 8 inches (20 cm) per year.',
          'Has been declining by 95% since 1980.',
          'Reproduces through both spawning and fragmentation.',
          'Provides critical habitat for over 25% of marine species.'
        ],
        habitat: 'Shallow reef environments, 15-60 feet deep',
        diet: 'Photosynthesis from zooxanthellae algae',
        size: 'Up to 6 feet (1.8 m) tall',
        lifespan: 'Hundreds of years (colonial)',
        conservationStatus: ConservationStatus.criticallyEndangered,
        imageUrl: '',
        funFacts: [
          'Staghorn coral was one of the first species listed under the Endangered Species Act.',
          'It can reproduce asexually through fragmentation.',
          'Its branches are fragile and easily broken by storms.'
        ],
        location: 'Caribbean Sea, Florida Keys, Bahamas',
        behavior: 'Sessile, extends polyps to feed at night'
      ),
      MarineCreature(
        id: '8',
        name: 'Giant Squid',
        scientificName: 'Architeuthis dux',
        type: CreatureType.deepSea,
        description: 'The giant squid is one of the largest living organisms and the largest mollusk. These mysterious creatures live in the deep ocean and are rarely seen by humans.',
        uniqueTraits: [
          'Largest invertebrate on Earth',
          'Largest eyes in the animal kingdom',
          'Arms lined with suckers and hooks',
          'Can change color rapidly'
        ],
        trivia: [
          'Eyes can be up to 11 inches (27 cm) in diameter.',
          'Can grow up to 43 feet (13 m) long.',
          'Have been found in all world oceans.',
          'First live footage was captured in 2004.'
        ],
        habitat: 'Deep ocean waters, 1,000-3,000 feet deep',
        diet: 'Carnivore - deep-sea fish, other squid',
        size: 'Up to 43 feet (13 m)',
        lifespan: 'Unknown, estimated 5 years',
        conservationStatus: ConservationStatus.leastConcern,
        imageUrl: '',
        funFacts: [
          'Giant squid have three hearts and blue blood.',
          'Their tentacles can regenerate if lost.',
          'They squirt ink to escape predators.'
        ],
        location: 'All major oceans, most common in North Atlantic',
        behavior: 'Solitary predator, rises to surface at night to feed'
      ),
      MarineCreature(
        id: '9',
        name: 'Manta Ray',
        scientificName: 'Manta birostris',
        type: CreatureType.fish,
        description: 'Manta rays are the largest rays in the world, known for their graceful swimming and intelligence. They filter-feed on plankton and are harmless to humans.',
        uniqueTraits: [
          'Wingspan up to 29 feet across',
          'Brain-to-body ratio similar to dolphins',
          'Can leap completely out of water',
          'Remoras often attach to them'
        ],
        trivia: [
          'Manta rays have the largest brain of any fish.',
          'They can live up to 50 years.',
          'They visit cleaning stations to have parasites removed.',
          'Each manta ray has unique belly spot patterns.'
        ],
        habitat: 'Tropical and subtropical waters near coasts',
        diet: 'Filter-feeder - plankton, fish larvae',
        size: 'Wingspan up to 29 feet (8.8 m)',
        lifespan: '40-50 years',
        conservationStatus: ConservationStatus.vulnerable,
        imageUrl: '',
        funFacts: [
          'Manta rays are highly intelligent and can recognize themselves in mirrors.',
          'They can somersault backward when feeding.',
          'They give birth to live pups, usually one at a time.'
        ],
        location: 'Tropical waters worldwide, often near coral reefs',
        behavior: 'Social, often seen in groups, curious about divers'
      ),
      MarineCreature(
        id: '10',
        name: 'Blue Whale',
        scientificName: 'Balaenoptera musculus',
        type: CreatureType.fish,
        description: 'The blue whale is the largest animal ever known to have lived on Earth. These magnificent marine mammals are gentle giants that feed on tiny krill.',
        uniqueTraits: [
          'Largest animal ever to exist',
          'Heart size of a small car',
          'Loudest animal on Earth',
          'Tongue weighs as much as an elephant'
        ],
        trivia: [
          'A blue whale can eat 4 tons of krill per day.',
          'Their calls can travel underwater for hundreds of miles.',
          'They can live up to 90 years.',
          'Newborn calves gain 200 pounds per day.'
        ],
        habitat: 'Open ocean, migrates between feeding and breeding grounds',
        diet: 'Carnivore - primarily krill, sometimes small fish',
        size: 'Up to 100 feet (30 m) long',
        lifespan: '80-90 years',
        conservationStatus: ConservationStatus.endangered,
        imageUrl: '',
        funFacts: [
          'Blue whale arteries are large enough for a baby to crawl through.',
          'Their spouts can reach 30 feet high.',
          'They were hunted nearly to extinction in the 1900s.'
        ],
        location: 'All major oceans, summers in polar regions',
        behavior: 'Solitary or in pairs, migrates thousands of miles annually'
      ),
      MarineCreature(
        id: '11',
        name: 'Hammerhead Shark',
        scientificName: 'Sphyrnidae family',
        type: CreatureType.fish,
        description: 'Hammerhead sharks are easily recognized by their distinctive hammer-shaped heads. This unique structure gives them enhanced hunting abilities.',
        uniqueTraits: [
          'Hammer-shaped cephalofoil head',
          '360-degree vision',
          'Enhanced electroreception sensors',
          'Often swim in large schools during day'
        ],
        trivia: [
          'There are 9 species of hammerhead sharks.',
          'Their wide-set eyes give them better binocular vision.',
          'They can detect prey buried under sand.',
          'Some species can grow up to 20 feet long.'
        ],
        habitat: 'Warm coastal waters and continental shelves',
        diet: 'Carnivore - stingrays, squid, fish, crustaceans',
        size: '13-20 feet (4-6 m) depending on species',
        lifespan: '20-30 years',
        conservationStatus: ConservationStatus.endangered,
        imageUrl: '',
        funFacts: [
          'Hammerheads often swim sideways to reduce drag.',
          'They are one of the few shark species to swim in schools.',
          'Their oddly shaped head may help with maneuverability.'
        ],
        location: 'Warm waters worldwide, especially around islands',
        behavior: 'Swims in schools during day, hunts alone at night'
      ),
      MarineCreature(
        id: '12',
        name: 'Pacific Octopus',
        scientificName: 'Enteroctopus dofleini',
        type: CreatureType.deepSea,
        description: 'The giant Pacific octopus is the largest octopus species. These intelligent cephalopods are masters of camouflage and problem-solving.',
        uniqueTraits: [
          'Three hearts and blue blood',
          'Can change color and texture instantly',
          'Highly intelligent, solves puzzles',
          'Ink defense mechanism'
        ],
        trivia: [
          'They have about 2,000 suckers with chemoreceptors.',
          'Can regenerate lost arms.',
          'They are cannibals and solitary hunters.',
          'Their bite contains venom to subdue prey.'
        ],
        habitat: 'Coastal marine waters, rocky reefs, kelp forests',
        diet: 'Carnivore - crabs, shrimp, fish, other octopuses',
        size: 'Arm span up to 20 feet (6 m)',
        lifespan: '3-5 years',
        conservationStatus: ConservationStatus.leastConcern,
        imageUrl: '',
        funFacts: [
          'Octopuses have excellent memories and can navigate mazes.',
          'They are masters of disguise, mimicking other animals.',
          'Females die after caring for their eggs.'
        ],
        location: 'North Pacific Ocean, from California to Alaska',
        behavior: 'Solitary, nocturnal hunter, excellent problem solver'
      ),
      MarineCreature(
        id: '13',
        name: 'Jellyfish',
        scientificName: 'Scyphozoa class',
        type: CreatureType.fish,
        description: 'Jellyfish are ancient gelatinous creatures that have drifted through oceans for over 500 million years. They have no brain, heart, or bones.',
        uniqueTraits: [
          '95% water composition',
          'No brain, heart, or bones',
          'Stinging cells called nematocysts',
          'Can regenerate when injured'
        ],
        trivia: [
          'Some jellyfish are immortal and can reverse aging.',
          'They have existed for over 500 million years.',
          'A group of jellyfish is called a bloom or smack.',
          'They have been to space on shuttle missions.'
        ],
        habitat: 'All ocean waters from surface to deep sea',
        diet: 'Carnivore - small fish, plankton, fish eggs',
        size: '0.5 inches to 6 feet (1.3 cm to 1.8 m) bell diameter',
        lifespan: 'Few months to several years',
        conservationStatus: ConservationStatus.leastConcern,
        imageUrl: '',
        funFacts: [
          'The lion\'s mane jellyfish has tentacles up to 120 feet long.',
          'Jellyfish blooms can contain millions of individuals.',
          'They are a delicacy in some Asian cuisines.'
        ],
        location: 'All oceans worldwide, freshwater lakes too',
        behavior: 'Drifts with currents, pulsates to move vertically'
      ),
      MarineCreature(
        id: '14',
        name: 'Starfish',
        scientificName: 'Asteroidea class',
        type: CreatureType.coral,
        description: 'Starfish, or sea stars, are fascinating echinoderms with regenerative abilities. Despite their name, they are not fish and can regenerate lost arms.',
        uniqueTraits: [
          'Five arms (usually) with tube feet',
          'Can regenerate lost arms',
          'External digestion of prey',
          'Water vascular system for movement'
        ],
        trivia: [
          'Starfish have no brain or blood.',
          'There are over 2,000 species of starfish.',
          'They can push their stomachs outside their body.',
          'Some species have up to 40 arms.'
        ],
        habitat: 'Rocky shores, coral reefs, sandy bottoms, kelp forests',
        diet: 'Carnivore - mussels, oysters, clams, snails',
        size: '0.4 inches to 3 feet (1 cm to 1 m) across',
        lifespan: '5-35 years depending on species',
        conservationStatus: ConservationStatus.leastConcern,
        imageUrl: '',
        funFacts: [
          'Starfish can change gender from male to female.',
          'They have eyes at the end of each arm.',
          'They play a crucial role in controlling mussel populations.'
        ],
        location: 'All oceans worldwide, from tropics to polar regions',
        behavior: 'Slow-moving predator, uses tube feet to pry open shells'
      ),
      MarineCreature(
        id: '15',
        name: 'Seahorse',
        scientificName: 'Hippocampus genus',
        type: CreatureType.fish,
        description: 'Seahorses are unique fish with horse-like heads and prehensile tails. They are the only species where males carry and give birth to young.',
        uniqueTraits: [
          'Males carry and birth babies',
          'Swims upright using dorsal fin',
          'Prehensile tail for anchoring',
          'Monogamous mating pairs'
        ],
        trivia: [
          'Seahorses can change color to blend in.',
          'They have no stomach and must eat constantly.',
          'They can eat 3,000 brine shrimp per day.',
          'They mate for life in many species.'
        ],
        habitat: 'Shallow coastal waters, seagrass beds, coral reefs',
        diet: 'Carnivore - small crustaceans, plankton, shrimp larvae',
        size: '0.6 to 14 inches (1.5 to 35 cm)',
        lifespan: '1-5 years',
        conservationStatus: ConservationStatus.vulnerable,
        imageUrl: '',
        funFacts: [
          'Male seahorses can give birth to up to 2,000 babies at once.',
          'They are terrible swimmers and can die of exhaustion.',
          'They make clicking sounds during courtship.'
        ],
        location: 'Shallow tropical and temperate waters worldwide',
        behavior: 'Solitary or in pairs, anchors to coral with tail'
      ),
    ];
  }
}
