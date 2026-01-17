import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_tracking_app/models/user.dart';
import 'package:bus_tracking_app/models/bus.dart';
import 'package:bus_tracking_app/models/route.dart' as app_route;
import 'package:bus_tracking_app/models/stop.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _busesCollection => _firestore.collection('buses');
  CollectionReference get _routesCollection => _firestore.collection('routes');
  CollectionReference get _stopsCollection => _firestore.collection('stops');

  // ========== USER OPERATIONS ==========

  /// Create a new user document
  Future<void> createUser(User user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Get user by ID
  Future<User?> getUser(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) return null;
      return User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Update user data
  Future<void> updateUser(
    String userId, {
    String? name,
    String? phoneNumber,
    String? busCompanyName,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (busCompanyName != null) updates['busCompanyName'] = busCompanyName;

      if (updates.isNotEmpty) {
        await _usersCollection.doc(userId).update(updates);
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // ========== BUS OPERATIONS ==========

  /// Create a new bus
  Future<String> createBus(Bus bus) async {
    try {
      final docRef = await _busesCollection.add(bus.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create bus: $e');
    }
  }

  /// Get bus by ID
  Future<Bus?> getBus(String busId) async {
    try {
      final doc = await _busesCollection.doc(busId).get();
      if (!doc.exists) return null;
      return Bus.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Failed to get bus: $e');
    }
  }

  /// Get all buses for a company
  Future<List<Bus>> getBusesByCompany(String companyName) async {
    try {
      final querySnapshot = await _busesCollection
          .where('companyName', isEqualTo: companyName)
          .get();

      return querySnapshot.docs
          .map((doc) => Bus.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get buses: $e');
    }
  }

  /// Update bus
  Future<void> updateBus(String busId, Map<String, dynamic> updates) async {
    try {
      await _busesCollection.doc(busId).update(updates);
    } catch (e) {
      throw Exception('Failed to update bus: $e');
    }
  }

  /// Delete bus
  Future<void> deleteBus(String busId) async {
    try {
      await _busesCollection.doc(busId).delete();
    } catch (e) {
      throw Exception('Failed to delete bus: $e');
    }
  }

  // ========== ROUTE OPERATIONS ==========

  /// Create a new route
  Future<String> createRoute(app_route.Route route) async {
    try {
      final docRef = await _routesCollection.add(route.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create route: $e');
    }
  }

  /// Get route by ID
  Future<app_route.Route?> getRoute(String routeId) async {
    try {
      final doc = await _routesCollection.doc(routeId).get();
      if (!doc.exists) return null;
      return app_route.Route.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    } catch (e) {
      throw Exception('Failed to get route: $e');
    }
  }

  /// Get all routes
  Future<List<app_route.Route>> getAllRoutes() async {
    try {
      final querySnapshot = await _routesCollection.get();
      return querySnapshot.docs
          .map(
            (doc) => app_route.Route.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get routes: $e');
    }
  }

  /// Update route
  Future<void> updateRoute(String routeId, Map<String, dynamic> updates) async {
    try {
      await _routesCollection.doc(routeId).update(updates);
    } catch (e) {
      throw Exception('Failed to update route: $e');
    }
  }

  /// Delete route
  Future<void> deleteRoute(String routeId) async {
    try {
      await _routesCollection.doc(routeId).delete();
    } catch (e) {
      throw Exception('Failed to delete route: $e');
    }
  }

  // ========== STOP OPERATIONS ==========

  /// Create a new stop
  Future<String> createStop(Stop stop) async {
    try {
      final docRef = await _stopsCollection.add(stop.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create stop: $e');
    }
  }

  /// Get stop by ID
  Future<Stop?> getStop(String stopId) async {
    try {
      final doc = await _stopsCollection.doc(stopId).get();
      if (!doc.exists) return null;
      return Stop.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Failed to get stop: $e');
    }
  }

  /// Get stops by route ID
  Future<List<Stop>> getStopsByRoute(String routeId) async {
    try {
      final querySnapshot = await _stopsCollection
          .where('routeId', isEqualTo: routeId)
          .orderBy('order')
          .get();

      return querySnapshot.docs
          .map(
            (doc) => Stop.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get stops: $e');
    }
  }

  /// Update stop
  Future<void> updateStop(String stopId, Map<String, dynamic> updates) async {
    try {
      await _stopsCollection.doc(stopId).update(updates);
    } catch (e) {
      throw Exception('Failed to update stop: $e');
    }
  }

  /// Delete stop
  Future<void> deleteStop(String stopId) async {
    try {
      await _stopsCollection.doc(stopId).delete();
    } catch (e) {
      throw Exception('Failed to delete stop: $e');
    }
  }

  // ========== REAL-TIME LISTENERS ==========

  /// Listen to bus location updates
  Stream<Bus> listenToBus(String busId) {
    return _busesCollection.doc(busId).snapshots().map((doc) {
      return Bus.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  /// Listen to all buses on a route
  Stream<List<Bus>> listenToBusesOnRoute(String routeId) {
    return _busesCollection
        .where('currentRouteId', isEqualTo: routeId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) =>
                    Bus.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList();
        });
  }
}
