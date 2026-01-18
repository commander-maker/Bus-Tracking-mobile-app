import 'package:flutter/material.dart';
import 'package:bus_tracking_app/core/services/route_service.dart';
import 'package:bus_tracking_app/models/route.dart' as app_route;

class ManageBusesScreen extends StatefulWidget {
  const ManageBusesScreen({super.key});

  @override
  State<ManageBusesScreen> createState() => _ManageBusesScreenState();
}

class _ManageBusesScreenState extends State<ManageBusesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController();
  final _capacityController = TextEditingController(text: '54');
  final _gpsTrackerController = TextEditingController();
  final _routeService = RouteService();

  String? _selectedBusType = 'Government (SLTB)';
  app_route.Route? _selectedRoute;
  List<app_route.Route> _availableRoutes = [];
  bool _loadingRoutes = false;
  final List<String> _busTypes = [
    'Government (SLTB)',
    'Private',
    'Express',
    'School',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadAvailableRoutes();
  }

  Future<void> _loadAvailableRoutes() async {
    setState(() => _loadingRoutes = true);
    try {
      final routes = await _routeService.getAllRoutes();
      if (mounted) {
        setState(() {
          _availableRoutes = routes;
          _loadingRoutes = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingRoutes = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading routes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _capacityController.dispose();
    _gpsTrackerController.dispose();
    super.dispose();
  }

  Future<void> _registerBus() async {
    if (_formKey.currentState!.validate()) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Registering bus...'),
            ],
          ),
        ),
      );

      try {
        // TODO: Implement bus registration logic
        // await _busService.registerBus(
        //   vehicleNumber: _vehicleNumberController.text,
        //   busType: _selectedBusType,
        //   capacity: int.parse(_capacityController.text),
        //   gpsTrackerId: _gpsTrackerController.text,
        //   routeId: _selectedRoute?.id,
        // );

        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Bus ${_vehicleNumberController.text} registered successfully for route ${_selectedRoute?.routeNumber}',
              ),
              backgroundColor: Colors.green,
            ),
          );
          // Clear form after successful registration
          _vehicleNumberController.clear();
          _capacityController.text = '54';
          _gpsTrackerController.clear();
          setState(() => _selectedRoute = null);
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error registering bus: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Register New Bus',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bus Details Header
              const Text(
                'Bus Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Vehicle Number Field
              TextFormField(
                controller: _vehicleNumberController,
                decoration: InputDecoration(
                  labelText: 'Vehicle Number',
                  hintText: 'e.g. NA-1234',
                  labelStyle: const TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bus Type Dropdown
              Text(
                'Bus Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedBusType,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _busTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBusType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select bus type';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Route Selection Dropdown
              Text(
                'Assign Route',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              _loadingRoutes
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : _availableRoutes.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red.shade50,
                          ),
                          child: Text(
                            'No routes available',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<app_route.Route>(
                            value: _selectedRoute,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Select a route',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ),
                            items: _availableRoutes.map((route) {
                              return DropdownMenuItem(
                                value: route,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    route.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (route) {
                              setState(() {
                                _selectedRoute = route;
                              });
                            },
                          ),
                        ),
              if (_selectedRoute == null && !_loadingRoutes)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Please select a route',
                    style: TextStyle(
                      color: Colors.red.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Capacity Field
              Text(
                'Capacity',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter capacity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Capacity must be a number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // GPS Tracker ID Field
              TextFormField(
                controller: _gpsTrackerController,
                decoration: InputDecoration(
                  labelText: 'GPS Tracker ID',
                  hintText: 'e.g. T-001',
                  labelStyle: const TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter GPS Tracker ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Register Bus Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _registerBus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Register Bus',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
