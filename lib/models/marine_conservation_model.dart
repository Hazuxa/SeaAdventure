import 'package:flutter/material.dart';

class OceanThreat {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> impacts;
  final List<String> solutions;
  final String statistics;

  OceanThreat({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.impacts,
    required this.solutions,
    required this.statistics,
  });
}

class EndangeredOceanSpecies {
  final String id;
  final String name;
  final String scientificName;
  final String description;
  final String population;
  final String threats;
  final String habitat;
  final String conservationEfforts;
  final String imageUrl;
  final Color urgencyColor;
  final IconData icon;

  EndangeredOceanSpecies({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.population,
    required this.threats,
    required this.habitat,
    required this.conservationEfforts,
    required this.imageUrl,
    required this.urgencyColor,
    required this.icon,
  });
}

class ConservationAction {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> steps;

  ConservationAction({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.steps,
  });
}

// Ocean Threats Data
final List<OceanThreat> oceanThreats = [
  OceanThreat(
    id: '1',
    title: 'Plastic Pollution',
    description: 'Every year, millions of tons of plastic waste enter our oceans, harming marine life and ecosystems. From microplastics to large debris, this pollution affects every level of the food chain.',
    icon: Icons.delete_outline,
    color: Colors.red,
    impacts: [
      'Over 8 million metric tons of plastic enter oceans annually',
      '100,000 marine mammals die from plastic each year',
      '700+ species impacted by ocean plastic',
      'Microplastics found in 90% of seabirds',
      'Great Pacific Garbage Patch is 3x the size of France',
    ],
    solutions: [
      'Reduce single-use plastic consumption',
      'Support plastic bag bans and regulations',
      'Participate in beach cleanup events',
      'Choose products with minimal packaging',
      'Properly recycle and dispose of waste',
    ],
    statistics: '8M tons/year',
  ),
  OceanThreat(
    id: '2',
    title: 'Climate Change',
    description: 'Rising temperatures and ocean acidification are fundamentally altering marine ecosystems. The ocean absorbs 90% of excess heat and 30% of CO2 emissions, causing devastating effects.',
    icon: Icons.thermostat,
    color: Colors.orange,
    impacts: [
      'Ocean temperatures risen 1°C since 1900',
      '30% increase in ocean acidity since Industrial Revolution',
      'Coral bleaching affecting 75% of reefs worldwide',
      'Sea levels rising 3.4mm per year',
      'Marine species migrating toward poles',
    ],
    solutions: [
      'Reduce carbon footprint',
      'Support renewable energy initiatives',
      'Advocate for climate policy',
      'Choose sustainable transportation',
      'Plant trees and support reforestation',
    ],
    statistics: '+1°C warming',
  ),
  OceanThreat(
    id: '3',
    title: 'Habitat Destruction',
    description: 'Coastal development, bottom trawling, and destructive fishing practices are destroying critical marine habitats. Coral reefs, mangroves, and seagrass beds are disappearing at alarming rates.',
    icon: Icons.landscape,
    color: Colors.brown,
    impacts: [
      '50% of coral reefs lost since 1950',
      '35% of mangroves destroyed globally',
      'Seagrass meadows declining 7% annually',
      'Deep-sea habitats damaged by trawling',
      'Coastal wetlands lost to development',
    ],
    solutions: [
      'Support marine protected areas',
      'Avoid bottom-trawled seafood',
      'Protect coastal wetlands',
      'Restore degraded habitats',
      'Practice responsible boating',
    ],
    statistics: '50% reefs lost',
  ),
  OceanThreat(
    id: '4',
    title: 'Overfishing',
    description: 'Unsustainable fishing practices are depleting fish populations faster than they can reproduce. 34% of global fish stocks are overfished, threatening food security and ecosystem balance.',
    icon: Icons.phishing,
    color: Colors.purple,
    impacts: [
      '90% of large predatory fish populations depleted',
      '34% of fish stocks overfished globally',
      'Bycatch kills millions of non-target species',
      'Bottom trawling destroys seabed habitats',
      'Illegal fishing undermines conservation',
    ],
    solutions: [
      'Choose sustainably sourced seafood',
      'Support fishing quotas and regulations',
      'Avoid endangered species',
      'Practice catch and release',
      'Report illegal fishing activities',
    ],
    statistics: '34% overfished',
  ),
  OceanThreat(
    id: '5',
    title: 'Oil & Chemical Pollution',
    description: 'Oil spills, agricultural runoff, and industrial chemicals contaminate marine waters. These pollutants accumulate in the food chain and cause long-term ecosystem damage.',
    icon: Icons.oil_barrel,
    color: Colors.black,
    impacts: [
      '1,000+ oil spills annually worldwide',
      'Dead zones expanding in coastal areas',
      'Toxic chemicals in 80% of marine life',
      'Agricultural runoff causes algal blooms',
      'Oil spills affect wildlife for decades',
    ],
    solutions: [
      'Support stricter environmental regulations',
      'Reduce use of harmful chemicals',
      'Properly dispose of motor oil and chemicals',
      'Choose eco-friendly cleaning products',
      'Support oil spill response organizations',
    ],
    statistics: '1,000+ spills/year',
  ),
  OceanThreat(
    id: '6',
    title: 'Noise Pollution',
    description: 'Underwater noise from shipping, sonar, and construction disrupts marine life communication, navigation, and feeding patterns. Whales and dolphins are especially vulnerable.',
    icon: Icons.volume_up,
    color: Colors.blue,
    impacts: [
      'Shipping noise doubled every decade',
      'Whales stranding due to sonar disruption',
      'Fish behavior altered by noise',
      'Marine mammals losing communication range',
      'Construction noise harms coastal species',
    ],
    solutions: [
      'Support quieter shipping technologies',
      'Establish marine noise sanctuaries',
      'Regulate underwater construction',
      'Reduce recreational boating noise',
      'Support marine mammal protection',
    ],
    statistics: '10x increase',
  ),
];

// Endangered Species Data
final List<EndangeredOceanSpecies> endangeredSpecies = [
  EndangeredOceanSpecies(
    id: '1',
    name: 'Vaquita Porpoise',
    scientificName: 'Phocoena sinus',
    description: 'The world\'s rarest marine mammal, found only in Mexico\'s Gulf of California. With only about 10 individuals remaining, this species is on the brink of extinction.',
    population: 'Critically Low (10-13 individuals)',
    threats: 'Gillnet fishing, illegal totoaba trade',
    habitat: 'Northern Gulf of California, Mexico',
    conservationEfforts: 'Gillnet bans, international cooperation, captive breeding attempts',
    imageUrl: '',
    urgencyColor: Colors.red.shade900,
    icon: Icons.water,
  ),
  EndangeredOceanSpecies(
    id: '2',
    name: 'Hawksbill Sea Turtle',
    scientificName: 'Eretmochelys imbricata',
    description: 'A critically endangered sea turtle prized for its beautiful shell. Despite international protection, illegal trade continues to threaten this species.',
    population: 'Declining (20,000-23,000 nesting females)',
    threats: 'Illegal shell trade, habitat loss, bycatch',
    habitat: 'Tropical coral reefs worldwide',
    conservationEfforts: 'Shell trade bans, nest protection, marine protected areas',
    imageUrl: '',
    urgencyColor: Colors.red,
    icon: Icons.water,
  ),
  EndangeredOceanSpecies(
    id: '3',
    name: 'Blue Whale',
    scientificName: 'Balaenoptera musculus',
    description: 'The largest animal ever known to exist on Earth. Despite being protected since 1966, blue whale populations remain critically low due to historic whaling.',
    population: 'Critically Low (10,000-25,000)',
    threats: 'Ship strikes, climate change, noise pollution',
    habitat: 'All major oceans',
    conservationEfforts: 'Shipping lane modifications, marine protected areas, climate action',
    imageUrl: '',
    urgencyColor: Colors.red,
    icon: Icons.water,
  ),
  EndangeredOceanSpecies(
    id: '4',
    name: 'Hammerhead Sharks',
    scientificName: 'Sphyrnidae family',
    description: 'These distinctive sharks are rapidly disappearing due to overfishing for their fins. Their slow reproduction makes recovery difficult.',
    population: 'Rapidly Declining',
    threats: 'Shark fin trade, overfishing, bycatch',
    habitat: 'Warm coastal waters worldwide',
    conservationEfforts: 'CITES protection, shark fin bans, marine reserves',
    imageUrl: '',
    urgencyColor: Colors.orange,
    icon: Icons.water,
  ),
  EndangeredOceanSpecies(
    id: '5',
    name: 'Monk Seal',
    scientificName: 'Monachus monachus / Neomonachus',
    description: 'Two of the three monk seal species are critically endangered. Human disturbance and fishing have pushed them to the edge.',
    population: 'Critically Endangered (600-700 Mediterranean, 1,100 Hawaiian)',
    threats: 'Fishing gear entanglement, habitat loss, human disturbance',
    habitat: 'Mediterranean Sea and Hawaiian Islands',
    conservationEfforts: 'Marine protected areas, fishing gear modifications, captive rehabilitation',
    imageUrl: '',
    urgencyColor: Colors.red,
    icon: Icons.water,
  ),
  EndangeredOceanSpecies(
    id: '6',
    name: 'Staghorn Coral',
    scientificName: 'Acropora cervicornis',
    description: 'Once dominant in Caribbean reefs, this fast-growing coral has declined 95% since 1980 due to disease, bleaching, and climate change.',
    population: '95% Decline Since 1980',
    threats: 'Climate change, disease, ocean acidification',
    habitat: 'Caribbean Sea, Florida Keys',
    conservationEfforts: 'Coral nurseries, restoration projects, assisted evolution',
    imageUrl: '',
    urgencyColor: Colors.red,
    icon: Icons.grain,
  ),
  EndangeredOceanSpecies(
    id: '7',
    name: 'Ganges River Dolphin',
    scientificName: 'Platanista gangetica',
    description: 'One of the few remaining freshwater dolphins, this species is blind and navigates using echolocation. Pollution and dams threaten its survival.',
    population: 'Endangered (1,200-1,800)',
    threats: 'Dam construction, pollution, fishing',
    habitat: 'Ganges-Brahmaputra-Meghna river systems',
    conservationEfforts: 'Fishing restrictions, pollution control, dam management',
    imageUrl: '',
    urgencyColor: Colors.orange,
    icon: Icons.water,
  ),
  EndangeredOceanSpecies(
    id: '8',
    name: 'Narwhal',
    scientificName: 'Monodon monoceros',
    description: 'Known as the "unicorn of the sea" for its distinctive tusk, the narwhal faces threats from climate change affecting Arctic ice.',
    population: 'Vulnerable (80,000)',
    threats: 'Climate change, ice loss, hunting',
    habitat: 'Arctic waters around Greenland and Canada',
    conservationEfforts: 'Hunting quotas, climate action, protected areas',
    imageUrl: '',
    urgencyColor: Colors.orange,
    icon: Icons.water,
  ),
];

// Conservation Actions Data
final List<ConservationAction> conservationActions = [
  ConservationAction(
    title: 'Reduce Plastic Use',
    description: 'Minimize single-use plastics that end up in our oceans',
    icon: Icons.recycling,
    color: Colors.green,
    steps: [
      'Bring reusable bags, bottles, and containers',
      'Avoid products with excessive packaging',
      'Say no to plastic straws and utensils',
      'Choose products made from recycled materials',
      'Properly dispose of all waste',
    ],
  ),
  ConservationAction(
    title: 'Support Sustainable Seafood',
    description: 'Choose seafood that is caught or farmed responsibly',
    icon: Icons.restaurant,
    color: Colors.blue,
    steps: [
      'Use seafood watch guides and apps',
      'Ask restaurants about sourcing',
      'Avoid endangered species',
      'Choose local and seasonal options',
      'Support certified sustainable fisheries',
    ],
  ),
  ConservationAction(
    title: 'Reduce Carbon Footprint',
    description: 'Help combat ocean acidification and warming',
    icon: Icons.eco,
    color: Colors.teal,
    steps: [
      'Use energy-efficient appliances',
      'Choose renewable energy when possible',
      'Reduce car use and use public transport',
      'Support clean energy policies',
      'Plant trees and protect forests',
    ],
  ),
  ConservationAction(
    title: 'Participate in Cleanups',
    description: 'Join efforts to remove trash from beaches and waterways',
    icon: Icons.cleaning_services,
    color: Colors.orange,
    steps: [
      'Join organized beach cleanups',
      'Clean up litter when you see it',
      'Organize community cleanup events',
      'Report illegal dumping',
      'Never litter - always pack out what you pack in',
    ],
  ),
  ConservationAction(
    title: 'Support Conservation Groups',
    description: 'Donate to or volunteer with organizations protecting oceans',
    icon: Icons.favorite,
    color: Colors.red,
    steps: [
      'Donate to marine conservation organizations',
      'Volunteer for local conservation projects',
      'Spread awareness on social media',
      'Participate in citizen science',
      'Advocate for ocean protection policies',
    ],
  ),
  ConservationAction(
    title: 'Responsible Tourism',
    description: 'Enjoy the ocean without harming marine ecosystems',
    icon: Icons.beach_access,
    color: Colors.cyan,
    steps: [
      'Use reef-safe sunscreen',
      'Never touch or stand on coral',
      'Keep distance from marine wildlife',
      'Choose eco-certified tour operators',
      'Avoid buying marine wildlife products',
    ],
  ),
];
