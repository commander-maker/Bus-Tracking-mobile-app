import 'package:flutter/material.dart';
import 'package:bus_tracking_app/features/auth/auth_controller.dart';
import 'package:bus_tracking_app/models/route.dart' as app_route;

class AdminRouteSelectionScreen extends StatefulWidget {
  const AdminRouteSelectionScreen({super.key});

  @override
  State<AdminRouteSelectionScreen> createState() =>
      _AdminRouteSelectionScreenState();
}

class _AdminRouteSelectionScreenState extends State<AdminRouteSelectionScreen> {
  final _authController = AuthController();
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data - will be replaced with Firebase data
  final List<app_route.Route> _routes = [
    app_route.Route(
      id: '1',
      routeNumber: '138',
      name: 'Colombo - Malabe Express',
      startLocation: 'Colombo Fort',
      endLocation: 'Malabe',
      distance: 15.5,
      estimatedDuration: 45,
      stopIds: [],
    ),
    app_route.Route(
      id: '2',
      routeNumber: '177',
      name: 'Pettah - Kaduwela',
      startLocation: 'Pettah',
      endLocation: 'Kaduwela',
      distance: 12.3,
      estimatedDuration: 35,
      stopIds: [],
    ),
    app_route.Route(
      id: '3',
      routeNumber: '155',
      name: 'Colombo - Nugegoda',
      startLocation: 'Colombo',
      endLocation: 'Nugegoda',
      distance: 8.2,
      estimatedDuration: 25,
      stopIds: [],
    ),
  ];

  List<app_route.Route> get _filteredRoutes {
    if (_searchQuery.isEmpty) {
      return _routes;
    }
    return _routes.where((route) {
      return route.routeNumber.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          route.startLocation.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          route.endLocation.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleLogout() async {
    try {
      await _authController.logout();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
      }
    }
  }

  void _editRoute(app_route.Route route) {
    // TODO: Navigate to edit route screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit Route: ${route.routeNumber}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addNewRoute() {
    // TODO: Navigate to add route screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add new route functionality coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _manageRoute(app_route.Route route) {
    // TODO: Navigate to admin dashboard for this route
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Manage Route: ${route.routeNumber}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authController.currentUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange.shade700,
        title: const Text(
          'Manage Routes',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Admin Info Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.orange.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: 35,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Admin',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            user?.busCompanyName ?? 'Bus Company',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search routes...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Routes List
          Expanded(
            child: _filteredRoutes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.route_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No routes found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a new route to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredRoutes.length,
                    itemBuilder: (context, index) {
                      final route = _filteredRoutes[index];
                      return _buildAdminRouteCard(route);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewRoute,
        backgroundColor: Colors.orange.shade700,
        icon: const Icon(Icons.add),
        label: const Text('Add Route'),
      ),
    );
  }

  Widget _buildAdminRouteCard(app_route.Route route) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _manageRoute(route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Route Number Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      route.routeNumber,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Edit Button
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange.shade700),
                    onPressed: () => _editRoute(route),
                    tooltip: 'Edit Route',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Route Info
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                route.startLocation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Container(
                            width: 2,
                            height: 20,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                route.endLocation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Route Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    Icons.route,
                    '${route.distance} km',
                    'Distance',
                  ),
                  _buildStatItem(
                    Icons.access_time,
                    '${route.estimatedDuration} min',
                    'Duration',
                  ),
                  _buildStatItem(
                    Icons.location_on,
                    '${route.stopIds.length}',
                    'Stops',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
