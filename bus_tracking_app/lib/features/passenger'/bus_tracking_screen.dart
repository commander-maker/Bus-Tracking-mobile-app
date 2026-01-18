import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bus_tracking_app/models/bus.dart';
import 'package:bus_tracking_app/models/route.dart' as app_route;
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:ui' as ui;

class BusTrackingScreen extends StatefulWidget {
  final app_route.Route route;

  const BusTrackingScreen({super.key, required this.route});

  @override
  State<BusTrackingScreen> createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends State<BusTrackingScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Bus? _selectedBus;
  Timer? _updateTimer;
  Position? _currentPosition;
  BitmapDescriptor? _busIcon;
  BitmapDescriptor? _selectedBusIcon;

  // Mock data for buses on this route
  late List<Bus> _buses;

  @override
  void initState() {
    super.initState();
    _initializeMockBuses();
    _loadCustomMarkers();
    _getCurrentLocation();
    _updateMarkers();
    // Simulate real-time updates every 5 seconds
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _simulateBusMovement();
    });
  }

  Future<void> _loadCustomMarkers() async {
    _busIcon = await _createBusIcon(Colors.red);
    _selectedBusIcon = await _createBusIcon(Colors.green);
    setState(() {
      _updateMarkers();
    });
  }

  Future<BitmapDescriptor> _createBusIcon(Color color) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = color;

    // Draw bus shape
    const size = 100.0;

    // Bus body
    final rect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(10, 30, 80, 50),
      const Radius.circular(8),
    );
    canvas.drawRRect(rect, paint);

    // Bus windows
    final windowPaint = Paint()..color = Colors.white.withOpacity(0.9);
    canvas.drawRect(const Rect.fromLTWH(15, 35, 30, 15), windowPaint);
    canvas.drawRect(const Rect.fromLTWH(55, 35, 30, 15), windowPaint);

    // Bus wheels
    final wheelPaint = Paint()..color = Colors.black;
    canvas.drawCircle(const Offset(25, 80), 8, wheelPaint);
    canvas.drawCircle(const Offset(75, 80), 8, wheelPaint);

    // Direction indicator (front)
    final frontPaint = Paint()..color = Colors.yellow;
    canvas.drawRect(const Rect.fromLTWH(85, 45, 5, 20), frontPaint);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are permanently denied'),
            ),
          );
        }
        return;
      }

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      // Center map on user location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            14,
          ),
        );
      }

      // Listen to location updates
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        setState(() {
          _currentPosition = position;
        });
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }
    }
  }

  void _initializeMockBuses() {
    // Create mock buses for the selected route
    // Coordinates are based on Colombo, Sri Lanka area
    final baseLatitude = 6.9271; // Colombo
    final baseLongitude = 79.8612;

    _buses = [
      Bus(
        id: 'bus1',
        registrationNumber: 'WP CAB-1234',
        companyName: 'Sri Lanka Transport Board',
        currentRouteId: widget.route.id,
        currentLocation: LatLng(baseLatitude + 0.01, baseLongitude + 0.01),
        speed: 35.5,
        isActive: true,
        lastUpdated: DateTime.now(),
      ),
      Bus(
        id: 'bus2',
        registrationNumber: 'WP CAE-5678',
        companyName: 'Private Bus Service',
        currentRouteId: widget.route.id,
        currentLocation: LatLng(baseLatitude + 0.03, baseLongitude + 0.02),
        speed: 42.0,
        isActive: true,
        lastUpdated: DateTime.now(),
      ),
      Bus(
        id: 'bus3',
        registrationNumber: 'WP CAF-9012',
        companyName: 'Express Transport',
        currentRouteId: widget.route.id,
        currentLocation: LatLng(baseLatitude + 0.05, baseLongitude + 0.015),
        speed: 28.3,
        isActive: true,
        lastUpdated: DateTime.now(),
      ),
    ];
  }

  void _simulateBusMovement() {
    // Simulate bus movement for demo purposes
    setState(() {
      _buses = _buses.map((bus) {
        if (bus.currentLocation != null) {
          // Move bus slightly (simulate GPS updates)
          final newLat =
              bus.currentLocation!.latitude +
              (0.0001 * (1 - 2 * (bus.hashCode % 2)));
          final newLng =
              bus.currentLocation!.longitude +
              (0.0001 * (1 - 2 * ((bus.hashCode ~/ 2) % 2)));

          return Bus(
            id: bus.id,
            registrationNumber: bus.registrationNumber,
            companyName: bus.companyName,
            currentRouteId: bus.currentRouteId,
            currentLocation: LatLng(newLat, newLng),
            speed: bus.speed! + (5 - (bus.hashCode % 10)), // Vary speed
            isActive: bus.isActive,
            lastUpdated: DateTime.now(),
          );
        }
        return bus;
      }).toList();
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    _markers = _buses.map((bus) {
      return Marker(
        markerId: MarkerId(bus.id),
        position: bus.currentLocation ?? const LatLng(0, 0),
        icon:
            (_selectedBus?.id == bus.id ? _selectedBusIcon : _busIcon) ??
            BitmapDescriptor.defaultMarkerWithHue(
              _selectedBus?.id == bus.id
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueRed,
            ),
        infoWindow: InfoWindow(
          title: bus.registrationNumber,
          snippet: '${bus.speed?.toStringAsFixed(1)} km/h',
        ),
        rotation: _calculateBusRotation(bus),
        anchor: const Offset(0.5, 0.5),
        onTap: () {
          setState(() {
            _selectedBus = bus;
          });
        },
      );
    }).toSet();
  }

  double _calculateBusRotation(Bus bus) {
    // Calculate rotation based on movement direction
    // For now, return a simple rotation based on bus ID
    return (bus.hashCode % 4) * 90.0;
  }

  void _centerOnBus(Bus bus) {
    if (bus.currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(bus.currentLocation!, 15),
      );
      setState(() {
        _selectedBus = bus;
      });
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFD32F2F), // SLTB red
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route ${widget.route.routeNumber}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              widget.route.name,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _simulateBusMovement();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bus locations updated'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Route Info Card
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFD32F2F), // SLTB red
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildRouteInfoItem(
                    Icons.location_on,
                    'Start',
                    widget.route.startLocation,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white30,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: _buildRouteInfoItem(
                    Icons.flag,
                    'End',
                    widget.route.endLocation,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white30,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: _buildRouteInfoItem(
                    Icons.directions_bus,
                    'Buses',
                    '${_buses.length}',
                  ),
                ),
              ],
            ),
          ),
          // Google Map
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition != null
                        ? LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          )
                        : (_buses.isNotEmpty &&
                                  _buses.first.currentLocation != null
                              ? _buses.first.currentLocation!
                              : const LatLng(6.9271, 79.8612)),
                    zoom: 14,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  compassEnabled: true,
                  trafficEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
                // Active Buses Count Badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.directions_bus,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_buses.where((b) => b.isActive).length} Active',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bus List
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text(
                        'Available Buses',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD), // Light blue
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Live',
                          style: TextStyle(
                            color: Color(0xFF1565C0), // Blue accent
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _buses.length,
                    itemBuilder: (context, index) {
                      final bus = _buses[index];
                      final isSelected = _selectedBus?.id == bus.id;
                      return _buildBusCard(bus, isSelected);
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfoItem(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBusCard(Bus bus, bool isSelected) {
    final timeSinceUpdate = DateTime.now().difference(
      bus.lastUpdated ?? DateTime.now(),
    );
    final isRecent = timeSinceUpdate.inMinutes < 2;

    return GestureDetector(
      onTap: () => _centerOnBus(bus),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFEBEE) : Colors.grey.shade50, // Light red when selected
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1565C0) : Colors.grey.shade200, // Blue accent border
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1565C0) // Blue accent
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.directions_bus,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bus.registrationNumber,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? const Color(0xFF1565C0) // Blue accent
                              : Colors.black,
                        ),
                      ),
                      Text(
                        bus.companyName,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isRecent ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isRecent ? 'Live' : 'Delayed',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildBusDetail(
                  Icons.speed,
                  '${bus.speed?.toStringAsFixed(1) ?? '0'} km/h',
                ),
                const SizedBox(width: 16),
                _buildBusDetail(
                  Icons.access_time,
                  timeSinceUpdate.inSeconds < 60
                      ? 'Just now'
                      : '${timeSinceUpdate.inMinutes}m ago',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
      ],
    );
  }
}
