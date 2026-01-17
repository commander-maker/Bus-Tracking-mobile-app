import 'package:google_maps_flutter/google_maps_flutter.dart';

class Bus {
  final String id;
  final String registrationNumber;
  final String companyName;
  final String? currentRouteId;
  final LatLng? currentLocation;
  final double? speed; // km/h
  final bool isActive;
  final DateTime? lastUpdated;

  Bus({
    required this.id,
    required this.registrationNumber,
    required this.companyName,
    this.currentRouteId,
    this.currentLocation,
    this.speed,
    this.isActive = true,
    this.lastUpdated,
  });

  factory Bus.fromMap(Map<String, dynamic> map, String documentId) {
    return Bus(
      id: documentId,
      registrationNumber: map['registrationNumber'] ?? '',
      companyName: map['companyName'] ?? '',
      currentRouteId: map['currentRouteId'],
      currentLocation: map['latitude'] != null && map['longitude'] != null
          ? LatLng(map['latitude'], map['longitude'])
          : null,
      speed: map['speed']?.toDouble(),
      isActive: map['isActive'] ?? true,
      lastUpdated: map['lastUpdated'] != null
          ? (map['lastUpdated'] as dynamic).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'registrationNumber': registrationNumber,
      'companyName': companyName,
      'currentRouteId': currentRouteId,
      'latitude': currentLocation?.latitude,
      'longitude': currentLocation?.longitude,
      'speed': speed,
      'isActive': isActive,
      'lastUpdated': lastUpdated ?? DateTime.now(),
    };
  }

  Bus copyWith({
    String? id,
    String? registrationNumber,
    String? companyName,
    String? currentRouteId,
    LatLng? currentLocation,
    double? speed,
    bool? isActive,
    DateTime? lastUpdated,
  }) {
    return Bus(
      id: id ?? this.id,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      companyName: companyName ?? this.companyName,
      currentRouteId: currentRouteId ?? this.currentRouteId,
      currentLocation: currentLocation ?? this.currentLocation,
      speed: speed ?? this.speed,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
