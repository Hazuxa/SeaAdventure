import 'package:flutter/material.dart';

enum QuestionCategory {
  marineLife,
  oceanZones,
  conservation,
  deepSea,
  funFacts,
  seaLegends,
}

class TriviaQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final QuestionCategory category;
  final String explanation;
  final String funFact;
  final int points;
  final Difficulty difficulty;

  TriviaQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.category,
    required this.explanation,
    required this.funFact,
    this.points = 10,
    this.difficulty = Difficulty.medium,
  });
}

enum Difficulty { easy, medium, hard }

class QuizCategory {
  final QuestionCategory category;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<TriviaQuestion> questions;

  QuizCategory({
    required this.category,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.questions,
  });
}

// Trivia Questions Database
final List<TriviaQuestion> allTriviaQuestions = [
  // MARINE LIFE QUESTIONS
  TriviaQuestion(
    id: 'ml1',
    question: 'What is the largest animal ever known to have lived on Earth?',
    options: ['T-Rex', 'Blue Whale', 'Giant Squid', 'Elephant'],
    correctAnswerIndex: 1,
    category: QuestionCategory.marineLife,
    explanation: 'The blue whale can grow up to 30 meters long and weigh up to 200 tons!',
    funFact: 'A blue whale\'s tongue alone can weigh as much as an elephant!',
    points: 10,
    difficulty: Difficulty.easy,
  ),
  TriviaQuestion(
    id: 'ml2',
    question: 'How many hearts does an octopus have?',
    options: ['1', '2', '3', '4'],
    correctAnswerIndex: 2,
    category: QuestionCategory.marineLife,
    explanation: 'Octopuses have three hearts - two pump blood to the gills, one pumps to the rest of the body!',
    funFact: 'Their blood is blue because it uses copper instead of iron to transport oxygen!',
    points: 15,
    difficulty: Difficulty.medium,
  ),
  TriviaQuestion(
    id: 'ml3',
    question: 'What is a group of jellyfish called?',
    options: ['School', 'Swarm', 'Smack', 'Blob'],
    correctAnswerIndex: 2,
    category: QuestionCategory.marineLife,
    explanation: 'A group of jellyfish is called a "smack"! Other terms include bloom or swarm.',
    funFact: 'Jellyfish have no brain, heart, bones, or eyes, yet they\'ve existed for over 500 million years!',
    points: 20,
    difficulty: Difficulty.hard,
  ),
  TriviaQuestion(
    id: 'ml4',
    question: 'Which fish is known as the "clown of the sea"?',
    options: ['Pufferfish', 'Clownfish', 'Anglerfish', 'Parrotfish'],
    correctAnswerIndex: 1,
    category: QuestionCategory.marineLife,
    explanation: 'Clownfish are known for their bright orange and white stripes, like a clown\'s costume!',
    funFact: 'All clownfish are born male and can change to female if the dominant female dies!',
    points: 10,
    difficulty: Difficulty.easy,
  ),
  TriviaQuestion(
    id: 'ml5',
    question: 'What is the only fish that can blink both eyes?',
    options: ['Shark', 'Dolphin', 'Goldfish', 'No fish can blink'],
    correctAnswerIndex: 3,
    category: QuestionCategory.marineLife,
    explanation: 'Fish don\'t have eyelids, so they can\'t blink! Sharks have a protective membrane instead.',
    funFact: 'Some sharks can roll their eyes back into their heads for protection when attacking prey!',
    points: 15,
    difficulty: Difficulty.medium,
  ),
  TriviaQuestion(
    id: 'ml6',
    question: 'How long can a sea turtle hold its breath?',
    options: ['30 minutes', '1 hour', '5 hours', '10 hours'],
    correctAnswerIndex: 2,
    category: QuestionCategory.marineLife,
    explanation: 'Sea turtles can hold their breath for up to 5 hours when resting! Active swimming uses more oxygen.',
    funFact: 'Their heart rate slows to conserve oxygen, sometimes beating only once every 9 minutes!',
    points: 20,
    difficulty: Difficulty.hard,
  ),

  // OCEAN ZONES QUESTIONS
  TriviaQuestion(
    id: 'oz1',
    question: 'What is the deepest part of the ocean called?',
    options: ['Titanic Trench', 'Mariana Trench', 'Pacific Abyss', 'Deep Blue'],
    correctAnswerIndex: 1,
    category: QuestionCategory.oceanZones,
    explanation: 'The Mariana Trench in the Pacific Ocean reaches about 11,000 meters (36,000 feet) deep!',
    funFact: 'If Mount Everest were placed in the Mariana Trench, its peak would still be over a mile underwater!',
    points: 10,
    difficulty: Difficulty.easy,
  ),
  TriviaQuestion(
    id: 'oz2',
    question: 'At what depth does the "Twilight Zone" begin?',
    options: ['100 meters', '200 meters', '500 meters', '1000 meters'],
    correctAnswerIndex: 1,
    category: QuestionCategory.oceanZones,
    explanation: 'The Twilight Zone (Mesopelagic) begins at 200 meters where sunlight starts to fade!',
    funFact: 'This zone contains the largest animal migration on Earth - every night billions of creatures rise to feed!',
    points: 15,
    difficulty: Difficulty.medium,
  ),
  TriviaQuestion(
    id: 'oz3',
    question: 'What percentage of Earth\'s surface is covered by ocean?',
    options: ['50%', '61%', '71%', '85%'],
    correctAnswerIndex: 2,
    category: QuestionCategory.oceanZones,
    explanation: 'About 71% of Earth\'s surface is covered by oceans - that\'s why Earth is called the Blue Planet!',
    funFact: 'We\'ve explored less than 5% of the ocean floor - more people have been to the moon!',
    points: 10,
    difficulty: Difficulty.easy,
  ),
  TriviaQuestion(
    id: 'oz4',
    question: 'Which ocean zone is known as the "Midnight Zone"?',
    options: ['0-200m', '200-1000m', '1000-4000m', 'Below 4000m'],
    correctAnswerIndex: 2,
    category: QuestionCategory.oceanZones,
    explanation: 'The Bathypelagic zone (1000-4000m) is called the Midnight Zone - total darkness, near freezing!',
    funFact: '90% of creatures in the Midnight Zone produce their own light through bioluminescence!',
    points: 15,
    difficulty: Difficulty.medium,
  ),
  TriviaQuestion(
    id: 'oz5',
    question: 'What is the pressure at the bottom of the Mariana Trench?',
    options: ['100 atmospheres', '500 atmospheres', '1000 atmospheres', '2000 atmospheres'],
    correctAnswerIndex: 2,
    category: QuestionCategory.oceanZones,
    explanation: 'The pressure is about 1,000 atmospheres - equivalent to having 50 jumbo jets stacked on top of you!',
    funFact: 'Only 3 people have ever visited the bottom of the Mariana Trench - fewer than have walked on the moon!',
    points: 20,
    difficulty: Difficulty.hard,
  ),

  // CONSERVATION QUESTIONS
  TriviaQuestion(
    id: 'c1',
    question: 'How much plastic enters the ocean every year?',
    options: ['1 million tons', '4 million tons', '8 million tons', '20 million tons'],
    correctAnswerIndex: 2,
    category: QuestionCategory.conservation,
    explanation: 'About 8 million metric tons of plastic enter our oceans every year - that\'s a garbage truck every minute!',
    funFact: 'If current trends continue, there will be more plastic than fish in the ocean by 2050!',
    points: 15,
    difficulty: Difficulty.medium,
  ),
  TriviaQuestion(
    id: 'c2',
    question: 'What percentage of the world\'s oxygen is produced by the ocean?',
    options: ['20%', '50%', '70%', '90%'],
    correctAnswerIndex: 1,
    category: QuestionCategory.conservation,
    explanation: 'About 50-80% of the world\'s oxygen comes from ocean phytoplankton - microscopic ocean plants!',
    funFact: 'One type of phytoplankton, Prochlorococcus, produces 20% of the oxygen we breathe!',
    points: 15,
    difficulty: Difficulty.medium,
  ),
  TriviaQuestion(
    id: 'c3',
    question: 'Which of these is NOT a threat to coral reefs?',
    options: ['Ocean warming', 'Ocean acidification', 'Shark populations', 'Pollution'],
    correctAnswerIndex: 2,
    category: QuestionCategory.conservation,
    explanation: 'Sharks actually help reef health by controlling fish populations! The other three are major threats.',
    funFact: 'Coral reefs support 25% of all marine species despite covering less than 1% of the ocean floor!',
    points: 20,
    difficulty: Difficulty.hard,
  ),
  TriviaQuestion(
    id: 'c4',
    question: 'How many species of sea turtles are endangered?',
    options: ['2', '4', '6', '7'],
    correctAnswerIndex: 3,
    category: QuestionCategory.conservation,
    explanation: 'All 7 species of sea turtles are either endangered or threatened with extinction!',
    funFact: 'Sea turtles have existed for over 100 million years - they survived the dinosaurs!',
    points: 15,
    difficulty: Difficulty.medium,
  ),

  // DEEP SEA QUESTIONS
  TriviaQuestion(
    id: 'ds1',
    question: 'What do anglerfish use to attract prey?',
    options: ['Sound', 'Light', 'Smell', 'Movement'],
    correctAnswerIndex: 1,
    category: QuestionCategory.deepSea,
    explanation: 'Anglerfish have a bioluminescent lure that dangles from their head to attract prey in the dark!',
    funFact: 'Male anglerfish are tiny parasites that permanently fuse to females, sharing blood for life!',
    points: 15,
    difficulty: Difficulty.medium,
  ),
  TriviaQuestion(
    id: 'ds2',
    question: 'What is the largest eye in the animal kingdom?',
    options: ['Elephant eye', 'Giant squid eye', 'Whale eye', 'Blue whale eye'],
    correctAnswerIndex: 1,
    category: QuestionCategory.deepSea,
    explanation: 'Giant squid eyes can be up to 27 cm (11 inches) in diameter - as big as a dinner plate!',
    funFact: 'Their huge eyes help them detect the faint silhouettes of prey against the faint light from above!',
    points: 20,
    difficulty: Difficulty.hard,
  ),
  TriviaQuestion(
    id: 'ds3',
    question: 'What percentage of deep-sea creatures can produce light?',
    options: ['25%', '50%', '75%', '90%'],
    correctAnswerIndex: 3,
    category: QuestionCategory.deepSea,
    explanation: 'About 90% of deep-sea creatures are bioluminescent - they produce their own light!',
    funFact: 'They use light for camouflage, hunting, mating, and even defense - some squirt glowing ink!',
    points: 15,
    difficulty: Difficulty.medium,
  ),
  TriviaQuestion(
    id: 'ds4',
    question: 'What does the "Dumbo Octopus" use to swim?',
    options: ['Tentacles', 'Fins like ears', 'Jet propulsion', 'Undulating body'],
    correctAnswerIndex: 1,
    category: QuestionCategory.deepSea,
    explanation: 'Dumbo octopuses have ear-like fins on their heads that they flap to swim - just like Disney\'s Dumbo!',
    funFact: 'They are the deepest-living octopuses, found at depths up to 7,000 meters!',
    points: 15,
    difficulty: Difficulty.medium,
  ),

  // FUN FACTS
  TriviaQuestion(
    id: 'ff1',
    question: 'What color is lobster blood?',
    options: ['Red', 'Blue', 'Clear', 'Yellow'],
    correctAnswerIndex: 2,
    category: QuestionCategory.funFacts,
    explanation: 'Lobster blood is clear! It turns pink when cooked, just like their shells turn red.',
    funFact: 'Lobsters were once considered the "poor man\'s chicken" and were fed to prisoners!',
    points: 15,
    difficulty: Difficulty.medium,
  ),
  TriviaQuestion(
    id: 'ff2',
    question: 'How long can a shark go without eating?',
    options: ['1 day', '1 week', '1 month', '3 months'],
    correctAnswerIndex: 3,
    category: QuestionCategory.funFacts,
    explanation: 'Great white sharks can go up to 3 months without eating after a large meal!',
    funFact: 'Sharks can grow over 30,000 teeth in their lifetime - they lose and replace teeth constantly!',
    points: 15,
    difficulty: Difficulty.medium,
  ),
  TriviaQuestion(
    id: 'ff3',
    question: 'What is the loudest animal in the ocean?',
    options: ['Blue whale', 'Sperm whale', 'Dolphin', 'Pistol shrimp'],
    correctAnswerIndex: 0,
    category: QuestionCategory.funFacts,
    explanation: 'Blue whales can produce sounds up to 188 decibels - louder than a jet engine!',
    funFact: 'Their calls can travel underwater for hundreds of miles to communicate with other whales!',
    points: 20,
    difficulty: Difficulty.hard,
  ),
  TriviaQuestion(
    id: 'ff4',
    question: 'Which marine animal has the longest migration?',
    options: ['Sea turtle', 'Humpback whale', 'Arctic tern (bird)', 'Gray whale'],
    correctAnswerIndex: 2,
    category: QuestionCategory.funFacts,
    explanation: 'While not a marine animal, Arctic terns travel 44,000 miles yearly. Among marine animals, gray whales travel 10,000-12,000 miles!',
    funFact: 'Humpback whales\' songs can last for hours and change slightly each year like hit songs!',
    points: 20,
    difficulty: Difficulty.hard,
  ),
  TriviaQuestion(
    id: 'ff5',
    question: 'What is the fastest fish in the ocean?',
    options: ['Sailfish', 'Marlin', 'Shark', 'Tuna'],
    correctAnswerIndex: 0,
    category: QuestionCategory.funFacts,
    explanation: 'The sailfish can swim up to 68 mph (110 km/h) - faster than a cheetah runs on land!',
    funFact: 'Their long bills can slash through schools of fish to stun prey before eating them!',
    points: 15,
    difficulty: Difficulty.medium,
  ),

  // SEA LEGENDS
  TriviaQuestion(
    id: 'sl1',
    question: 'What mythical creature was likely inspired by the giant squid?',
    options: ['Mermaid', 'Kraken', 'Sea serpent', 'Leviathan'],
    correctAnswerIndex: 1,
    category: QuestionCategory.seaLegends,
    explanation: 'The Kraken from Norse mythology was likely inspired by giant squid sightings!',
    funFact: 'Giant squid can grow up to 43 feet long - long enough to span a school bus!',
    points: 15,
    difficulty: Difficulty.medium,
  ),
  TriviaQuestion(
    id: 'sl2',
    question: 'What famous shipwreck was discovered in 1985?',
    options: ['USS Arizona', 'Titanic', 'HMS Bounty', 'Spanish Armada'],
    correctAnswerIndex: 1,
    category: QuestionCategory.seaLegends,
    explanation: 'The Titanic was discovered on September 1, 1985, at a depth of about 12,500 feet!',
    funFact: 'The wreck was found 73 years after it sank, and it continues to slowly deteriorate!',
    points: 10,
    difficulty: Difficulty.easy,
  ),
  TriviaQuestion(
    id: 'sl3',
    question: 'What did ancient sailors think manatees were?',
    options: ['Dolphins', 'Mermaids', 'Whales', 'Monsters'],
    correctAnswerIndex: 1,
    category: QuestionCategory.seaLegends,
    explanation: 'Manatees and dugongs were mistaken for mermaids! Christopher Columbus reported seeing "mermaids" in 1493.',
    funFact: 'He wrote that they were "not half as beautiful as they are painted" - quite an understatement!',
    points: 20,
    difficulty: Difficulty.hard,
  ),
];

// Categories for the quiz
final List<QuizCategory> quizCategories = [
  QuizCategory(
    category: QuestionCategory.marineLife,
    name: 'Marine Life',
    description: 'Test your knowledge of ocean creatures!',
    icon: Icons.pets,
    color: Colors.teal,
    questions: allTriviaQuestions.where((q) => q.category == QuestionCategory.marineLife).toList(),
  ),
  QuizCategory(
    category: QuestionCategory.oceanZones,
    name: 'Ocean Zones',
    description: 'How deep is your ocean knowledge?',
    icon: Icons.arrow_downward,
    color: Colors.blue,
    questions: allTriviaQuestions.where((q) => q.category == QuestionCategory.oceanZones).toList(),
  ),
  QuizCategory(
    category: QuestionCategory.conservation,
    name: 'Conservation',
    description: 'Learn how to protect our oceans!',
    icon: Icons.favorite,
    color: Colors.green,
    questions: allTriviaQuestions.where((q) => q.category == QuestionCategory.conservation).toList(),
  ),
  QuizCategory(
    category: QuestionCategory.deepSea,
    name: 'Deep Sea',
    description: 'Journey into the abyss!',
    icon: Icons.nights_stay,
    color: Colors.deepPurple,
    questions: allTriviaQuestions.where((q) => q.category == QuestionCategory.deepSea).toList(),
  ),
  QuizCategory(
    category: QuestionCategory.funFacts,
    name: 'Fun Facts',
    description: 'Amazing ocean trivia!',
    icon: Icons.lightbulb,
    color: Colors.orange,
    questions: allTriviaQuestions.where((q) => q.category == QuestionCategory.funFacts).toList(),
  ),
  QuizCategory(
    category: QuestionCategory.seaLegends,
    name: 'Sea Legends',
    description: 'Myths, mysteries, and shipwrecks!',
    icon: Icons.auto_stories,
    color: Colors.red,
    questions: allTriviaQuestions.where((q) => q.category == QuestionCategory.seaLegends).toList(),
  ),
];

class QuizResult {
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final List<TriviaQuestion> questions;
  final List<int> userAnswers;
  final Duration timeTaken;

  QuizResult({
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.questions,
    required this.userAnswers,
    required this.timeTaken,
  });

  double get percentage => (correctAnswers / totalQuestions) * 100;
  
  String getRank() {
    if (percentage >= 90) return '🏆 Ocean Expert';
    if (percentage >= 70) return '🥈 Sea Scholar';
    if (percentage >= 50) return '🥉 Beach Beginner';
    return '🦐 Tide Pool Explorer';
  }
  
  String getMessage() {
    if (percentage >= 90) return 'Amazing! You\'re a true ocean expert!';
    if (percentage >= 70) return 'Great job! You know your sea stuff!';
    if (percentage >= 50) return 'Good effort! Keep exploring the ocean!';
    return 'Keep learning! The ocean has so much to teach!';
  }
}
