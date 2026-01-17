import 'package:flutter/material.dart';
import 'package:bus_tracking_app/features/auth/auth_controller.dart';
import 'package:bus_tracking_app/models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _busCompanyController = TextEditingController();
  final _authController = AuthController();

  UserType _selectedUserType = UserType.passenger;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _busCompanyController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final success = await _authController.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          userType: _selectedUserType,
          busCompanyName: _selectedUserType == UserType.admin
              ? _busCompanyController.text.trim()
              : null,
        );

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration successful! Please sign in.'),
              ),
            );
            Navigator.of(context).pop();
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = e.toString();
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade700,
                Colors.blue.shade400,
              ],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Join BusTrack Sri Lanka',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create your account to get started',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Error Message
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red.shade700, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_errorMessage != null) const SizedBox(height: 16),
                      // User Type Selection
                      const Text(
                        'Account Type',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedUserType = UserType.passenger;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _selectedUserType == UserType.passenger
                                      ? Colors.blue.shade50
                                      : Colors.grey.shade100,
                                  border: Border.all(
                                    color:
                                        _selectedUserType == UserType.passenger
                                            ? Colors.blue.shade700
                                            : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: _selectedUserType ==
                                              UserType.passenger
                                          ? Colors.blue.shade700
                                          : Colors.grey,
                                      size: 28,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Passenger',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            _selectedUserType ==
                                                    UserType.passenger
                                                ? Colors.blue.shade700
                                                : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedUserType = UserType.admin;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _selectedUserType == UserType.admin
                                      ? Colors.blue.shade50
                                      : Colors.grey.shade100,
                                  border: Border.all(
                                    color: _selectedUserType == UserType.admin
                                        ? Colors.blue.shade700
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.admin_panel_settings,
                                      color:
                                          _selectedUserType == UserType.admin
                                              ? Colors.blue.shade700
                                              : Colors.grey,
                                      size: 28,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Bus Admin',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            _selectedUserType == UserType.admin
                                                ? Colors.blue.shade700
                                                : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Email is required';
                          }
                          if (!AuthController.isValidEmail(value!)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Phone Number
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '+94XXXXXXXXX',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Phone number is required';
                          }
                          if (!AuthController.isValidPhoneNumber(value!)) {
                            return 'Enter valid Sri Lankan phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Bus Company (Admin only)
                      if (_selectedUserType == UserType.admin)
                        Column(
                          children: [
                            TextFormField(
                              controller: _busCompanyController,
                              decoration: InputDecoration(
                                labelText: 'Bus Company Name',
                                prefixIcon: const Icon(Icons.business),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (_selectedUserType == UserType.admin &&
                                    (value?.isEmpty ?? true)) {
                                  return 'Bus company name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Password is required';
                          }
                          if (!AuthController.isValidPassword(value!)) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Confirm Password
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please confirm password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Create Account',
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
