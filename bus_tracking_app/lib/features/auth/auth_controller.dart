import 'package:bus_tracking_app/models/user.dart';

class AuthController {
  static final AuthController _instance = AuthController._internal();

  factory AuthController() {
    return _instance;
  }

  AuthController._internal();

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock login - replace with actual authentication
      if (email.isNotEmpty && password.length >= 6) {
        _currentUser = User(
          id: '1',
          name: 'User Name',
          email: email,
          phoneNumber: '+94712345678',
          userType: email.contains('admin') ? UserType.admin : UserType.passenger,
          busCompanyName: email.contains('admin') ? 'SriLankan Buses Ltd' : null,
          createdAt: DateTime.now(),
        );
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Login failed: $e');
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

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      _currentUser = User(
        id: '1',
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        userType: userType,
        busCompanyName: busCompanyName,
        createdAt: DateTime.now(),
      );
      return true;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Logout
  void logout() {
    _currentUser = null;
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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
