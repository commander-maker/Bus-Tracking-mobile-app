class Route {
  final String id;
  final String routeNumber;
  final String name;
  final String startLocation;
  final String endLocation;
  final List<String> stopIds; // References to Stop documents
  final double distance; // in kilometers
  final int estimatedDuration; // in minutes
  final bool isActive;

  Route({
    required this.id,
    required this.routeNumber,
    required this.name,
    required this.startLocation,
    required this.endLocation,
    this.stopIds = const [],
    required this.distance,
    required this.estimatedDuration,
    this.isActive = true,
  });

  factory Route.fromMap(Map<String, dynamic> map, String documentId) {
    return Route(
      id: documentId,
      routeNumber: map['routeNumber'] ?? '',
      name: map['name'] ?? '',
      startLocation: map['startLocation'] ?? '',
      endLocation: map['endLocation'] ?? '',
      stopIds: List<String>.from(map['stopIds'] ?? []),
      distance: (map['distance'] ?? 0).toDouble(),
      estimatedDuration: map['estimatedDuration'] ?? 0,
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routeNumber': routeNumber,
      'name': name,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'stopIds': stopIds,
      'distance': distance,
      'estimatedDuration': estimatedDuration,
      'isActive': isActive,
    };
  }

  Route copyWith({
    String? id,
    String? routeNumber,
    String? name,
    String? startLocation,
    String? endLocation,
    List<String>? stopIds,
    double? distance,
    int? estimatedDuration,
    bool? isActive,
  }) {
    return Route(
      id: id ?? this.id,
      routeNumber: routeNumber ?? this.routeNumber,
      name: name ?? this.name,
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
      stopIds: stopIds ?? this.stopIds,
      distance: distance ?? this.distance,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      isActive: isActive ?? this.isActive,
    );
  }
}
