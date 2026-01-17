import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:bus_tracking_app/models/user.dart';
import 'package:bus_tracking_app/core/services/firestore_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  /// Get current Firebase user
  firebase_auth.User? get currentFirebaseUser => _firebaseAuth.currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => currentFirebaseUser != null;

  /// Stream of authentication state changes
  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  /// Register new user with email and password
  Future<User> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required UserType userType,
    String? busCompanyName,
  }) async {
    try {
      // Create user in Firebase Authentication
      final firebase_auth.UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      // Create user document in Firestore
      final user = User(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        userType: userType,
        busCompanyName: busCompanyName,
        createdAt: DateTime.now(),
      );

      await _firestoreService.createUser(user);

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Sign in with email and password
  Future<User> signIn({required String email, required String password}) async {
    try {
      final firebase_auth.UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Get user data from Firestore
      final user = await _firestoreService.getUser(userCredential.user!.uid);

      if (user == null) {
        throw Exception('User data not found');
      }

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Get current user data from Firestore
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = currentFirebaseUser;
      if (firebaseUser == null) return null;

      return await _firestoreService.getUser(firebaseUser.uid);
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? phoneNumber,
    String? busCompanyName,
  }) async {
    try {
      final firebaseUser = currentFirebaseUser;
      if (firebaseUser == null) {
        throw Exception('No user logged in');
      }

      // Update display name in Firebase Auth if provided
      if (name != null) {
        await firebaseUser.updateDisplayName(name);
      }

      // Update user data in Firestore
      await _firestoreService.updateUser(
        firebaseUser.uid,
        name: name,
        phoneNumber: phoneNumber,
        busCompanyName: busCompanyName,
      );
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'Authentication error: ${e.message ?? e.code}';
    }
  }
}
