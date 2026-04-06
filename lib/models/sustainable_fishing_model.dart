import 'package:flutter/material.dart';

enum FishingStatus {
  safeToFish,
  regulated,
  protected,
  endangered,
  criticallyEndangered,
  banned,
}

enum EcosystemRole {
  apexPredator,
  keystone,
  filterFeeder,
  nutrientCycler,
  preyBase,
  habitatBuilder,
  scavenger,
  primaryConsumer,
}

class FishSpecies {
  final String id;
  final String name;
  final String scientificName;
  final String description;
  final FishingStatus fishingStatus;
  final String fishingGuidelines;
  final List<String> regulations;
  final EcosystemRole ecosystemRole;
  final String ecosystemImpact;
  final String populationTrend;
  final String habitat;
  final String size;
  final String imageUrl;
  final List<String> threats;
  final List<String> sustainableAlternatives;
  final String seasonality;
  final String catchLimit;
  final String minimumSize;
  final List<String> funFacts;

  FishSpecies({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.fishingStatus,
    required this.fishingGuidelines,
    required this.regulations,
    required this.ecosystemRole,
    required this.ecosystemImpact,
    required this.populationTrend,
    required this.habitat,
    required this.size,
    required this.imageUrl,
    required this.threats,
    required this.sustainableAlternatives,
    required this.seasonality,
    required this.catchLimit,
    required this.minimumSize,
    required this.funFacts,
  });

  String get fishingStatusText {
    switch (fishingStatus) {
      case FishingStatus.safeToFish:
        return 'Safe to Fish';
      case FishingStatus.regulated:
        return 'Regulated Fishing';
      case FishingStatus.protected:
        return 'Protected Species';
      case FishingStatus.endangered:
        return 'Endangered - No Fishing';
      case FishingStatus.criticallyEndangered:
        return 'Critically Endangered';
      case FishingStatus.banned:
        return 'Fishing Banned';
    }
  }

  Color get fishingStatusColor {
    switch (fishingStatus) {
      case FishingStatus.safeToFish:
        return Colors.green;
      case FishingStatus.regulated:
        return Colors.blue;
      case FishingStatus.protected:
        return Colors.orange;
      case FishingStatus.endangered:
        return Colors.red;
      case FishingStatus.criticallyEndangered:
        return Colors.red.shade900;
      case FishingStatus.banned:
        return Colors.purple;
    }
  }

  IconData get fishingStatusIcon {
    switch (fishingStatus) {
      case FishingStatus.safeToFish:
        return Icons.check_circle;
      case FishingStatus.regulated:
        return Icons.gavel;
      case FishingStatus.protected:
        return Icons.shield;
      case FishingStatus.endangered:
        return Icons.warning;
      case FishingStatus.criticallyEndangered:
        return Icons.error;
      case FishingStatus.banned:
        return Icons.block;
    }
  }

  String get ecosystemRoleText {
    switch (ecosystemRole) {
      case EcosystemRole.apexPredator:
        return 'Apex Predator';
      case EcosystemRole.keystone:
        return 'Keystone Species';
      case EcosystemRole.filterFeeder:
        return 'Filter Feeder';
      case EcosystemRole.nutrientCycler:
        return 'Nutrient Cycler';
      case EcosystemRole.preyBase:
        return 'Prey Base';
      case EcosystemRole.habitatBuilder:
        return 'Habitat Builder';
      case EcosystemRole.scavenger:
        return 'Scavenger';
      case EcosystemRole.primaryConsumer:
        return 'Primary Consumer';
    }
  }

  bool get canFish => fishingStatus == FishingStatus.safeToFish || fishingStatus == FishingStatus.regulated;
  bool get isProtected => fishingStatus == FishingStatus.protected || fishingStatus == FishingStatus.endangered || fishingStatus == FishingStatus.criticallyEndangered || fishingStatus == FishingStatus.banned;
}

class OverfishingImpact {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> consequences;

  OverfishingImpact({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.consequences,
  });
}

class SustainablePractice {
  final String title;
  final String description;
  final IconData icon;
  final List<String> tips;

  SustainablePractice({
    required this.title,
    required this.description,
    required this.icon,
    required this.tips,
  });
}

// Sample data for fish species
final List<FishSpecies> sampleFishSpecies = [
  FishSpecies(
    id: '1',
    name: 'Yellowfin Tuna',
    scientificName: 'Thunnus albacares',
    description: 'A large, fast-swimming tuna prized for its meat. Found in tropical and subtropical waters worldwide.',
    fishingStatus: FishingStatus.regulated,
    fishingGuidelines: 'Subject to strict quotas and size limits. Use pole-and-line or troll fishing methods.',
    regulations: ['Minimum size: 27 inches (69 cm)', 'Daily bag limits apply', 'Seasonal closures in breeding areas', 'ICCAT quota regulations'],
    ecosystemRole: EcosystemRole.apexPredator,
    ecosystemImpact: 'As apex predators, yellowfin tuna regulate populations of smaller fish and squid, maintaining balance in the open ocean food web.',
    populationTrend: 'Declining due to overfishing',
    habitat: 'Open ocean, epipelagic and mesopelagic zones',
    size: 'Up to 2 meters, 200 kg',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Yellowfin_tuna_nurp.jpg/640px-Yellowfin_tuna_nurp.jpg',
    threats: ['Overfishing', 'Bycatch in longlines', 'Illegal fishing', 'Climate change affecting prey distribution'],
    sustainableAlternatives: ['Pole-caught skipjack tuna', 'Albacore tuna from sustainable fisheries', 'Mackerel species'],
    seasonality: 'Year-round, but peak in warmer months',
    catchLimit: 'Varies by region, typically 3-10 per day',
    minimumSize: '27 inches (69 cm)',
    funFacts: ['Can swim up to 50 mph', 'Warm-blooded fish', 'Can dive to 1,000 meters'],
  ),
  FishSpecies(
    id: '2',
    name: 'Bluefin Tuna',
    scientificName: 'Thunnus thynnus',
    description: 'The largest and most valuable tuna species. Highly prized in sushi markets.',
    fishingStatus: FishingStatus.endangered,
    fishingGuidelines: 'NO FISHING ALLOWED. This species is critically overfished. Report any sightings to marine authorities.',
    regulations: ['Fishing banned in most regions', 'International trade restrictions (CITES)', 'Zero catch limits in many areas', 'Heavy penalties for illegal fishing'],
    ecosystemRole: EcosystemRole.apexPredator,
    ecosystemImpact: 'Bluefin tuna are ocean wanderers that connect marine ecosystems across vast distances. Their decline has disrupted entire food webs.',
    populationTrend: 'Critically low, recovering slowly',
    habitat: 'Atlantic Ocean and Mediterranean Sea',
    size: 'Up to 3 meters, 680 kg',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Bluefin_Big.jpg/640px-Bluefin_Big.jpg',
    threats: ['Severe overfishing', 'High market demand', 'Slow reproduction rate', 'Climate change'],
    sustainableAlternatives: ['Yellowfin tuna (pole-caught)', 'Skipjack tuna', 'Albacore tuna'],
    seasonality: 'N/A - Protected',
    catchLimit: 'Zero',
    minimumSize: 'N/A',
    funFacts: ['Can live up to 50 years', 'Endothermic (warm-blooded)', 'Crosses entire Atlantic Ocean'],
  ),
  FishSpecies(
    id: '3',
    name: 'Atlantic Cod',
    scientificName: 'Gadus morhua',
    description: 'A bottom-dwelling fish that was once abundant in the North Atlantic. Famous for cod liver oil and white meat.',
    fishingStatus: FishingStatus.regulated,
    fishingGuidelines: 'Fishing is allowed but strictly regulated. Check local quotas and use sustainable fishing gear.',
    regulations: ['Minimum size: 35 cm', 'Strict quotas in place', 'Seasonal spawning closures', 'Gear restrictions apply'],
    ecosystemRole: EcosystemRole.keystone,
    ecosystemImpact: 'Cod are keystone species that control populations of crustaceans and smaller fish. Their decline has caused ecosystem shifts.',
    populationTrend: 'Recovering slowly from collapse',
    habitat: 'Continental shelves, cold waters',
    size: 'Up to 2 meters, 96 kg',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Atlantic_cod.jpg/640px-Atlantic_cod.jpg',
    threats: ['Overfishing (historic)', 'Climate change', 'Bycatch', 'Habitat degradation'],
    sustainableAlternatives: ['Pacific cod (sustainable stocks)', 'Haddock', 'Pollock'],
    seasonality: 'Best fishing outside spawning season (Dec-Mar)',
    catchLimit: 'Varies by region, typically 5-10 per day',
    minimumSize: '35 cm',
    funFacts: ['Can live up to 25 years', 'Changes color with depth', 'Historic foundation of Atlantic fishing economy'],
  ),
  FishSpecies(
    id: '4',
    name: 'Whale Shark',
    scientificName: 'Rhincodon typus',
    description: 'The largest fish in the sea, a gentle filter-feeder that poses no threat to humans.',
    fishingStatus: FishingStatus.protected,
    fishingGuidelines: 'ABSOLUTELY NO FISHING. Protected worldwide. Swimming with them is regulated and requires permits.',
    regulations: ['Protected under CITES Appendix II', 'Protected in most countries', 'Ecotourism only with permits', 'No trade allowed'],
    ecosystemRole: EcosystemRole.filterFeeder,
    ecosystemImpact: 'Whale sharks are ocean nomads that transport nutrients across vast distances. Their presence indicates healthy plankton populations.',
    populationTrend: 'Declining',
    habitat: 'Tropical and warm-temperate seas',
    size: 'Up to 18 meters, 34 tons',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Whale_shark_Georgia_aquarium.jpg/640px-Whale_shark_Georgia_aquarium.jpg',
    threats: ['Bycatch', 'Boat strikes', 'Marine plastic pollution', 'Climate change affecting food sources'],
    sustainableAlternatives: ['Whale shark watching (ecotourism)', 'Sustainable swimming tours'],
    seasonality: 'N/A - Protected',
    catchLimit: 'Zero',
    minimumSize: 'N/A',
    funFacts: ['Largest fish in the world', 'Filter feeds on plankton', 'Each has unique spot pattern'],
  ),
  FishSpecies(
    id: '5',
    name: 'Mahi-Mahi',
    scientificName: 'Coryphaena hippurus',
    description: 'A colorful, fast-growing sport fish known for its brilliant colors and delicious meat.',
    fishingStatus: FishingStatus.safeToFish,
    fishingGuidelines: 'Generally safe to fish with minimal restrictions. Fast-growing population makes it highly sustainable.',
    regulations: ['Minimal restrictions', 'No size limits in most areas', 'Use circle hooks to reduce bycatch', 'Respect bag limits where applied'],
    ecosystemRole: EcosystemRole.preyBase,
    ecosystemImpact: 'Mahi-mahi support the food web as both predator and prey, feeding larger fish and marine mammals.',
    populationTrend: 'Stable',
    habitat: 'Open ocean, surface waters',
    size: 'Up to 2 meters, 40 kg',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Coryphaena_hippurus.png/640px-Coryphaena_hippurus.png',
    threats: ['Bycatch in longlines', 'FAD (Fish Aggregating Device) impacts', 'Marine debris'],
    sustainableAlternatives: ['Already a sustainable choice', 'Wahoo', 'King mackerel'],
    seasonality: 'Year-round in tropical waters',
    catchLimit: 'Typically 10 per person per day',
    minimumSize: 'None in most regions',
    funFacts: ['Can grow 1 inch per week', 'Known as dolphin fish', 'Brilliant colors fade after death'],
  ),
  FishSpecies(
    id: '6',
    name: 'Red Snapper',
    scientificName: 'Lutjanus campechanus',
    description: 'A popular food fish found in the Gulf of Mexico and Atlantic waters. Highly prized for its white meat.',
    fishingStatus: FishingStatus.regulated,
    fishingGuidelines: 'Strictly regulated with short seasons. Check federal and state regulations before fishing.',
    regulations: ['Strictly limited season (June-Aug)', 'Size limits: 16 inches minimum', 'Bag limits: 2 per person', 'Federal permits required'],
    ecosystemRole: EcosystemRole.keystone,
    ecosystemImpact: 'Red snapper are important predators that maintain reef fish populations and ecosystem balance.',
    populationTrend: 'Recovering from overfishing',
    habitat: 'Reefs, rocky bottoms, Gulf of Mexico',
    size: 'Up to 1 meter, 20 kg',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Lutjanus_campechanus.jpg/640px-Lutjanus_campechanus.jpg',
    threats: ['Historic overfishing', 'Bycatch', 'Habitat loss', 'Climate change'],
    sustainableAlternatives: ['Mangrove snapper', 'Vermilion snapper', 'Lane snapper'],
    seasonality: 'June-August (strict season)',
    catchLimit: '2 per person per day',
    minimumSize: '16 inches (41 cm)',
    funFacts: ['Can live over 50 years', 'Form large spawning aggregations', 'Distinctive red color intensifies with depth'],
  ),
  FishSpecies(
    id: '7',
    name: 'Great White Shark',
    scientificName: 'Carcharodon carcharias',
    description: 'The iconic apex predator of the ocean, essential for marine ecosystem balance.',
    fishingStatus: FishingStatus.protected,
    fishingGuidelines: 'PROTECTED WORLDWIDE. Any interaction must be non-lethal. Report sightings to shark research organizations.',
    regulations: ['Protected under CITES', 'Protected in most jurisdictions', 'No killing or capture', 'Research permits only'],
    ecosystemRole: EcosystemRole.apexPredator,
    ecosystemImpact: 'As the ultimate apex predator, great whites regulate seal and sea lion populations, preventing overgrazing of kelp forests.',
    populationTrend: 'Vulnerable, slowly recovering',
    habitat: 'Coastal and offshore waters, all oceans',
    size: 'Up to 6 meters, 2,268 kg',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Great_white_shark_south_africa.jpg/640px-Great_white_shark_south_africa.jpg',
    threats: ['Bycatch', 'Shark fin trade', 'Marine pollution', 'Prey depletion'],
    sustainableAlternatives: ['Shark diving tourism', 'Research participation'],
    seasonality: 'N/A - Protected',
    catchLimit: 'Zero',
    minimumSize: 'N/A',
    funFacts: ['Can detect one drop of blood from miles away', 'Can live 70+ years', 'Warm-blooded shark'],
  ),
  FishSpecies(
    id: '8',
    name: 'Sardine',
    scientificName: 'Sardina pilchardus',
    description: 'Small, oily fish that form massive schools. Foundation of many marine food webs.',
    fishingStatus: FishingStatus.regulated,
    fishingGuidelines: 'Fishing is regulated to maintain population levels for ecosystem health.',
    regulations: ['Quotas based on biomass assessments', 'Seasonal closures during spawning', 'Gear type restrictions', 'No fishing in nursery areas'],
    ecosystemRole: EcosystemRole.preyBase,
    ecosystemImpact: 'Sardines are the foundation of coastal food webs. Their decline affects seabirds, marine mammals, and larger fish populations.',
    populationTrend: 'Fluctuates naturally but declining in some regions',
    habitat: 'Coastal upwelling zones',
    size: 'Up to 27 cm',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Sardina_pilchardus_GCII.jpg/640px-Sardina_pilchardus_GCII.jpg',
    threats: ['Overfishing', 'Climate change affecting upwelling', 'Ocean acidification', 'Competition with aquaculture'],
    sustainableAlternatives: ['Anchovies (sustainable stocks)', 'Herring', 'Mackerel'],
    seasonality: 'Year-round, avoid spawning season',
    catchLimit: 'Commercial quotas only',
    minimumSize: 'Varies by region',
    funFacts: ['Form schools of millions', 'Filter feeders', 'Critical food source for seabirds'],
  ),
];

// Overfishing impacts data
final List<OverfishingImpact> overfishingImpacts = [
  OverfishingImpact(
    title: 'Ecosystem Collapse',
    description: 'Removing too many fish disrupts the entire food web, causing cascading effects throughout the ecosystem.',
    icon: Icons.water_damage,
    color: Colors.red,
    consequences: [
      'Prey populations explode without predators',
      'Algae overgrowth kills coral reefs',
      'Smaller fish species dominate',
      'Biodiversity loss accelerates',
    ],
  ),
  OverfishingImpact(
    title: 'Bycatch Crisis',
    description: 'Millions of non-target animals die in fishing gear every year, including endangered species.',
    icon: Icons.pets,
    color: Colors.orange,
    consequences: [
      'Sea turtles drown in nets',
      'Dolphins caught in tuna purse seines',
      'Seabirds hooked on longlines',
      'Juvenile fish never reach breeding age',
    ],
  ),
  OverfishingImpact(
    title: 'Habitat Destruction',
    description: 'Certain fishing methods destroy critical marine habitats that fish need to survive.',
    icon: Icons.landscape,
    color: Colors.brown,
    consequences: [
      'Bottom trawling destroys coral reefs',
      'Seagrass beds ripped up',
      'Spawning grounds eliminated',
      'Centuries-old habitats gone in minutes',
    ],
  ),
  OverfishingImpact(
    title: 'Economic Impact',
    description: 'Overfishing threatens the livelihoods of millions who depend on healthy fish stocks.',
    icon: Icons.attach_money,
    color: Colors.green,
    consequences: [
      'Fishing communities lose income',
      'Food security threatened',
      'Tourism revenues decline',
      'Subsidies prop up unsustainable fishing',
    ],
  ),
];

// Sustainable practices data
final List<SustainablePractice> sustainablePractices = [
  SustainablePractice(
    title: 'Know Before You Go',
    description: 'Research fishing regulations, seasons, and species before heading out.',
    icon: Icons.menu_book,
    tips: [
      'Check local fishing regulations',
      'Know size and bag limits',
      'Understand seasonal closures',
      'Identify protected species',
      'Download fishing regulation apps',
    ],
  ),
  SustainablePractice(
    title: 'Practice Catch and Release',
    description: 'Return fish to the water properly to ensure their survival.',
    icon: Icons.replay,
    tips: [
      'Use barbless hooks',
      'Minimize handling time',
      'Keep fish in water when possible',
      'Use wet hands or gloves',
      'Revive fish before releasing',
    ],
  ),
  SustainablePractice(
    title: 'Choose Sustainable Gear',
    description: 'Select fishing methods that minimize environmental impact.',
    icon: Icons.phishing,
    tips: [
      'Use circle hooks to reduce bycatch',
      'Avoid destructive bottom trawls',
      'Choose selective fishing gear',
      'Use turtle excluder devices',
      'Properly dispose of fishing line',
    ],
  ),
  SustainablePractice(
    title: 'Eat Sustainable Seafood',
    description: 'Make informed choices about the seafood you consume.',
    icon: Icons.restaurant,
    tips: [
      'Check seafood guides and apps',
      'Ask restaurants about sourcing',
      'Choose local and seasonal options',
      'Avoid endangered species',
      'Support sustainable fisheries',
    ],
  ),
  SustainablePractice(
    title: 'Protect Marine Habitats',
    description: 'Respect and preserve the environments fish depend on.',
    icon: Icons.eco,
    tips: [
      'Avoid fishing in protected areas',
      'Don\'t anchor on coral reefs',
      'Respect seagrass beds',
      'Report habitat damage',
      'Support marine protected areas',
    ],
  ),
  SustainablePractice(
    title: 'Spread Awareness',
    description: 'Educate others about sustainable fishing practices.',
    icon: Icons.campaign,
    tips: [
      'Share knowledge with fellow anglers',
      'Support conservation organizations',
      'Report illegal fishing',
      'Participate in citizen science',
      'Teach children about ocean conservation',
    ],
  ),
];
