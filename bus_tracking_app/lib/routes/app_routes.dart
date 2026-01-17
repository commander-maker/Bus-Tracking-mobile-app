import 'package:flutter/material.dart';
import 'package:bus_tracking_app/features/auth/login_screen.dart';
import 'package:bus_tracking_app/features/auth/register_screen.dart';
import 'package:bus_tracking_app/features/passenger\'/route_selection_screen.dart';
import 'package:bus_tracking_app/features/admin/admin_route_selection_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String adminDashboard = '/admin-dashboard';
  static const String routeSelection = '/route-selection';
  static const String adminRouteSelection = '/admin-route-selection';
  static const String busTracking = '/bus-tracking';
  static const String routeDetails = '/route-details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case routeSelection:
        return MaterialPageRoute(builder: (_) => const RouteSelectionScreen());
      case adminRouteSelection:
        return MaterialPageRoute(
          builder: (_) => const AdminRouteSelectionScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
