import 'package:flutter/material.dart';
import 'package:bus_tracking_app/features/admin/admin_route_selection_screen.dart';
import 'package:bus_tracking_app/core/services/firestore_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirestoreService _firestoreService = FirestoreService();
  
  int totalBuses = 0;
  int activeBuses = 0;
  int totalRoutes = 0;
  int estimatedPassengers = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      // Fetch all buses
      final allBuses = await _firestoreService.getBusesByCompany('');
      
      // Since getBusesByCompany requires a company name, let's fetch all buses directly
      // We need to get all buses, so we'll count from routes
      final buses = await _firestoreService.getBusesByCompany('');
      
      // Fetch all routes
      final routes = await _firestoreService.getAllRoutes();
      
      setState(() {
        // Count total buses - try to get all buses by fetching routes first
        totalBuses = buses.isEmpty ? 0 : buses.length;
        
        // Count active buses (assume buses with status 'active')
        activeBuses = buses.where((bus) => bus.isActive).length;
        
        // Total routes
        totalRoutes = routes.length;
        
        // Estimated passengers (can be enhanced based on your data model)
        estimatedPassengers = totalRoutes * 30; // Example: 30 passengers per route
        
        isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'Dashboard Overview',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/admin-route-selection');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.blue.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.dashboard, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Dashboard Overview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Dashboard Stats Cards
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildStatCard(
                        icon: Icons.directions_bus,
                        iconColor: Colors.blue,
                        title: 'Total Fleet',
                        value: totalBuses.toString(),
                        context: context,
                      ),
                      _buildStatCard(
                        icon: Icons.directions_run,
                        iconColor: Colors.green,
                        title: 'Active Buses',
                        value: activeBuses.toString(),
                        context: context,
                      ),
                      _buildStatCard(
                        icon: Icons.route,
                        iconColor: Colors.purple,
                        title: 'Total Routes',
                        value: totalRoutes.toString(),
                        context: context,
                      ),
                      _buildStatCard(
                        icon: Icons.people,
                        iconColor: Colors.orange,
                        title: 'Passengers (Est)',
                        value: estimatedPassengers > 999
                            ? '${(estimatedPassengers / 1000).toStringAsFixed(1)}k'
                            : estimatedPassengers.toString(),
                        context: context,
                      ),
                    ],
                  ),
            const SizedBox(height: 24),
            // Register Bus Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Register Bus',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add new buses to the fleet and configure GPS trackers.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/manage-buses');
                    },
                    child: const Text(
                      'Go to Registration →',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
