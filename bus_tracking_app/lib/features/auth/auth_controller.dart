import 'package:bus_tracking_app/models/user.dart';
import 'package:bus_tracking_app/core/services/auth_service.dart';

class AuthController {
  static final AuthController _instance = AuthController._internal();

  factory AuthController() {
    return _instance;
  }

  AuthController._internal();

  final AuthService _authService = AuthService();
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _authService.isLoggedIn;

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    try {
      _currentUser = await _authService.signIn(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required UserType userType,
    String? busCompanyName,
  }) async {
    try {
      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      _currentUser = await _authService.register(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        userType: userType,
        busCompanyName: busCompanyName,
      );
      return true;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _authService.signOut();
      _currentUser = null;
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get current user data
  Future<void> loadCurrentUser() async {
    try {
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate Sri Lankan phone number
  static bool isValidPhoneNumber(String phone) {
    // Sri Lankan phone format: +94XXXXXXXXX or 0XXXXXXXXX
    final phoneRegex = RegExp(r'^(\+94|0)[0-9]{9}$');
    return phoneRegex.hasMatch(phone);
  }

  /// Validate password strength
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
}
