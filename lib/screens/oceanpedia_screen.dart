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
        appBar: AppBar(
          title: const Text('Oceanpedia'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.list), text: 'All'),
              Tab(icon: Icon(Icons.pets), text: 'Fish'),
              Tab(icon: Icon(Icons.grain), text: 'Corals'),
              Tab(icon: Icon(Icons.nights_stay), text: 'Deep Sea'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade500, Colors.blue.shade700, Colors.blue.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Stats Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStatChip(
                          Icons.pets,
                          '${_allCreatures.length}',
                          'Creatures',
                          Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        _buildStatChip(
                          Icons.warning,
                          '${_allCreatures.where((c) => c.conservationStatus == ConservationStatus.endangered || c.conservationStatus == ConservationStatus.criticallyEndangered).length}',
                          'Endangered',
                          Colors.red,
                        ),
                        const SizedBox(width: 8),
                        _buildStatChip(
                          Icons.category,
                          '3',
                          'Categories',
                          Colors.green,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search marine creatures...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon: Icon(Icons.search, color: Colors.blue.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey.shade400),
                                onPressed: () => _searchController.clear(),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCreatureList(_filteredCreatures),
                  _buildCreatureList(_getCreaturesByType(CreatureType.fish)),
                  _buildCreatureList(_getCreaturesByType(CreatureType.coral)),
                  _buildCreatureList(_getCreaturesByType(CreatureType.deepSea)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCreatureList(List<MarineCreature> creatures) {
    if (creatures.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No creatures found',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: creatures.length,
      itemBuilder: (context, index) {
        return _buildCreatureCard(creatures[index]);
      },
    );
  }

  Widget _buildCreatureCard(MarineCreature creature) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatureDetailScreen(creature: creature),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Conservation status indicator
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: creature.conservationStatusColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 12),

                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade100, Colors.cyan.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    creature.typeIcon,
                    size: 32,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        creature.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        creature.scientificName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: creature.conservationStatusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: creature.conservationStatusColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              creature.conservationStatusText,
                              style: TextStyle(
                                fontSize: 10,
                                color: creature.conservationStatusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Text(
                              creature.typeText,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
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
      MarineCreature(
        id: '16',
        name: 'Dolphin',
        scientificName: 'Delphinidae family',
        type: CreatureType.fish,
        description: 'Dolphins are highly intelligent marine mammals known for their playful behavior, communication skills, and echolocation abilities.',
        uniqueTraits: [
          'Advanced echolocation system',
          'Highly social and playful',
          'Can recognize themselves in mirrors',
          'Breathe voluntarily through blowhole'
        ],
        trivia: [
          'Dolphins sleep with half their brain awake.',
          'They have signature whistles like names.',
          'They can swim at speeds up to 20 mph.',
          'Some species can dive to 1,000 feet.'
        ],
        habitat: 'Coastal and offshore waters, some rivers',
        diet: 'Carnivore - fish, squid, crustaceans',
        size: '6-12 feet (1.8-3.6 m) depending on species',
        lifespan: '40-60 years',
        conservationStatus: ConservationStatus.leastConcern,
        imageUrl: '',
        funFacts: [
          'Dolphins have been observed using tools.',
          'They help injured or sick pod members.',
          'They can leap up to 20 feet out of water.'
        ],
        location: 'All major oceans and some large rivers',
        behavior: 'Highly social, lives in pods, cooperative hunters'
      ),
      MarineCreature(
        id: '17',
        name: 'Lionfish',
        scientificName: 'Pterois volitans',
        type: CreatureType.fish,
        description: 'Lionfish are striking venomous fish with elaborate fins. Native to the Indo-Pacific, they are invasive in the Atlantic and Caribbean.',
        uniqueTraits: [
          'Venomous spines on dorsal fins',
          'Elaborate venomous pectoral fins',
          'Invasive species in Atlantic waters',
          'Striped warning coloration'
        ],
        trivia: [
          'Lionfish venom is painful but rarely fatal to humans.',
          'They can reproduce year-round.',
          'One female can release 2 million eggs per year.',
          'They have no natural predators in invaded waters.'
        ],
        habitat: 'Coral reefs, rocky crevices, shipwrecks',
        diet: 'Carnivore - small fish, invertebrates, shrimp',
        size: 'Up to 18 inches (45 cm)',
        lifespan: '5-15 years',
        conservationStatus: ConservationStatus.leastConcern,
        imageUrl: '',
        funFacts: [
          'Lionfish are popular in aquariums but challenging to keep.',
          'They can eat prey half their body size.',
          'Their venom is defensive, not used for hunting.'
        ],
        location: 'Indo-Pacific native, invasive in Atlantic/Caribbean',
        behavior: 'Slow-moving ambush predator, solitary or small groups'
      ),
      MarineCreature(
        id: '18',
        name: 'Giant Tube Worm',
        scientificName: 'Riftia pachyptila',
        type: CreatureType.deepSea,
        description: 'Giant tube worms live near hydrothermal vents in the deep ocean. They have no mouth or digestive system and rely entirely on symbiotic bacteria.',
        uniqueTraits: [
          'No mouth or digestive system',
          'Lives near hydrothermal vents',
          'Bright red plume for gas exchange',
          'Symbiotic relationship with bacteria'
        ],
        trivia: [
          'Can grow up to 8 feet long.',
          'They were discovered in 1977.',
          'Their red color comes from hemoglobin-like proteins.',
          'They can tolerate extreme temperatures and pressure.'
        ],
        habitat: 'Hydrothermal vents, 5,000-8,000 feet deep',
        diet: 'Chemosynthesis via symbiotic bacteria',
        size: 'Up to 8 feet (2.4 m) long',
        lifespan: 'Over 250 years',
        conservationStatus: ConservationStatus.dataDeficient,
        imageUrl: '',
        funFacts: [
          'They grow faster than almost any other marine invertebrate.',
          'Their symbiotic bacteria convert chemicals to energy.',
          'They are one of the fastest-growing marine animals.'
        ],
        location: 'Pacific Ocean hydrothermal vents',
        behavior: 'Sessile, extends plume to capture chemicals from vents'
      ),
      MarineCreature(
        id: '19',
        name: 'Moray Eel',
        scientificName: 'Muraenidae family',
        type: CreatureType.fish,
        description: 'Moray eels are secretive predators that hide in rocky crevices and coral reefs. They have a second set of jaws in their throat.',
        uniqueTraits: [
          'Second set of pharyngeal jaws',
          'No pectoral or pelvic fins',
          'Continuous dorsal fin',
          'Poor eyesight, relies on smell'
        ],
        trivia: [
          'Moray eels can tie themselves in knots for leverage.',
          'There are over 200 species of moray eels.',
          'They open and close their mouths to breathe.',
          'Some species can grow to 13 feet long.'
        ],
        habitat: 'Coral reefs, rocky crevices, shipwrecks',
        diet: 'Carnivore - fish, squid, octopus, crustaceans',
        size: '5 inches to 13 feet (12 cm to 4 m)',
        lifespan: '10-30 years',
        conservationStatus: ConservationStatus.leastConcern,
        imageUrl: '',
        funFacts: [
          'Their pharyngeal jaws launch forward to grab prey.',
          'They have a symbiotic relationship with cleaner shrimp.',
          'Some species are venomous, but most are not.'
        ],
        location: 'Tropical and subtropical waters worldwide',
        behavior: 'Nocturnal hunter, hides in crevices during day'
      ),
      MarineCreature(
        id: '20',
        name: 'Manatee',
        scientificName: 'Trichechus genus',
        type: CreatureType.fish,
        description: 'Manatees are gentle, slow-moving herbivores often called sea cows. They are distant relatives of elephants and face threats from boat strikes.',
        uniqueTraits: [
          'Herbivorous marine mammal',
          'Related to elephants',
          'Must surface to breathe every 3-5 minutes',
          'Propelled by paddle-like tail'
        ],
        trivia: [
          'Manatees can eat 10-15% of their body weight daily.',
          'They have no natural predators.',
          'They are the state marine mammal of Florida.',
          'Christopher Columbus mistook them for mermaids.'
        ],
        habitat: 'Shallow coastal waters, rivers, estuaries',
        diet: 'Herbivore - seagrass, water hyacinth, water lettuce',
        size: '8-13 feet (2.4-4 m) long',
        lifespan: '60-70 years',
        conservationStatus: ConservationStatus.vulnerable,
        imageUrl: '',
        funFacts: [
          'Manatees are known as "sea cows" but are more related to elephants.',
          'They can hold their breath for up to 20 minutes.',
          'They must migrate to warmer waters in winter.'
        ],
        location: 'Southeast US, Caribbean, West Africa, Amazon',
        behavior: 'Solitary or small groups, slow-moving grazer'
      ),
    ];
  }
}
