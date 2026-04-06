import 'package:flutter/material.dart';

enum CreatureType {
  fish,
  coral,
  deepSea,
}

enum ConservationStatus {
  leastConcern,
  nearThreatened,
  vulnerable,
  endangered,
  criticallyEndangered,
  extinct,
  dataDeficient,
}

class MarineCreature {
  final String id;
  final String name;
  final String scientificName;
  final CreatureType type;
  final String description;
  final List<String> uniqueTraits;
  final List<String> trivia;
  final String habitat;
  final String diet;
  final String size;
  final String lifespan;
  final ConservationStatus conservationStatus;
  final String imageUrl;
  final List<String> funFacts;
  final String location;
  final String behavior;

  MarineCreature({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.type,
    required this.description,
    required this.uniqueTraits,
    required this.trivia,
    required this.habitat,
    required this.diet,
    required this.size,
    required this.lifespan,
    required this.conservationStatus,
    required this.imageUrl,
    required this.funFacts,
    required this.location,
    required this.behavior,
  });

  factory MarineCreature.fromJson(Map<String, dynamic> json) {
    return MarineCreature(
      id: json['id'] as String,
      name: json['name'] as String,
      scientificName: json['scientificName'] as String,
      type: CreatureType.values.firstWhere(
        (e) => e.toString() == 'CreatureType.${json['type']}',
        orElse: () => CreatureType.fish,
      ),
      description: json['description'] as String,
      uniqueTraits: List<String>.from(json['uniqueTraits'] as List),
      trivia: List<String>.from(json['trivia'] as List),
      habitat: json['habitat'] as String,
      diet: json['diet'] as String,
      size: json['size'] as String,
      lifespan: json['lifespan'] as String,
      conservationStatus: ConservationStatus.values.firstWhere(
        (e) => e.toString() == 'ConservationStatus.${json['conservationStatus']}',
        orElse: () => ConservationStatus.leastConcern,
      ),
      imageUrl: json['imageUrl'] as String,
      funFacts: List<String>.from(json['funFacts'] as List),
      location: json['location'] as String,
      behavior: json['behavior'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'type': type.toString().split('.').last,
      'description': description,
      'uniqueTraits': uniqueTraits,
      'trivia': trivia,
      'habitat': habitat,
      'diet': diet,
      'size': size,
      'lifespan': lifespan,
      'conservationStatus': conservationStatus.toString().split('.').last,
      'imageUrl': imageUrl,
      'funFacts': funFacts,
      'location': location,
      'behavior': behavior,
    };
  }

  String get conservationStatusText {
    switch (conservationStatus) {
      case ConservationStatus.leastConcern:
        return 'Least Concern';
      case ConservationStatus.nearThreatened:
        return 'Near Threatened';
      case ConservationStatus.vulnerable:
        return 'Vulnerable';
      case ConservationStatus.endangered:
        return 'Endangered';
      case ConservationStatus.criticallyEndangered:
        return 'Critically Endangered';
      case ConservationStatus.extinct:
        return 'Extinct';
      case ConservationStatus.dataDeficient:
        return 'Data Deficient';
    }
  }

  Color get conservationStatusColor {
    switch (conservationStatus) {
      case ConservationStatus.leastConcern:
        return Colors.green;
      case ConservationStatus.nearThreatened:
        return Colors.yellow.shade700;
      case ConservationStatus.vulnerable:
        return Colors.orange;
      case ConservationStatus.endangered:
        return Colors.red;
      case ConservationStatus.criticallyEndangered:
        return Colors.red.shade900;
      case ConservationStatus.extinct:
        return Colors.grey;
      case ConservationStatus.dataDeficient:
        return Colors.grey.shade600;
    }
  }

  String get typeText {
    switch (type) {
      case CreatureType.fish:
        return 'Fish';
      case CreatureType.coral:
        return 'Coral';
      case CreatureType.deepSea:
        return 'Deep Sea Creature';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case CreatureType.fish:
        return Icons.pets;
      case CreatureType.coral:
        return Icons.grain;
      case CreatureType.deepSea:
        return Icons.nights_stay;
    }
  }
}
