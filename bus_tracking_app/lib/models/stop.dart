import 'package:google_maps_flutter/google_maps_flutter.dart';

class Stop {
  final String id;
  final String routeId;
  final String name;
  final LatLng location;
  final int order; // Order in the route sequence
  final String? description;

  Stop({
    required this.id,
    required this.routeId,
    required this.name,
    required this.location,
    required this.order,
    this.description,
  });

  factory Stop.fromMap(Map<String, dynamic> map, String documentId) {
    return Stop(
      id: documentId,
      routeId: map['routeId'] ?? '',
      name: map['name'] ?? '',
      location: LatLng(map['latitude'] ?? 0.0, map['longitude'] ?? 0.0),
      order: map['order'] ?? 0,
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routeId': routeId,
      'name': name,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'order': order,
      'description': description,
    };
  }

  Stop copyWith({
    String? id,
    String? routeId,
    String? name,
    LatLng? location,
    int? order,
    String? description,
  }) {
    return Stop(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      name: name ?? this.name,
      location: location ?? this.location,
      order: order ?? this.order,
      description: description ?? this.description,
    );
  }
}
