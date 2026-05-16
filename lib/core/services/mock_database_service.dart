import 'package:flutter_antonx_boilerplate/core/models/body/login_body.dart';
import 'package:flutter_antonx_boilerplate/core/models/body/signup_body.dart';
import 'package:flutter_antonx_boilerplate/core/models/responses/auth_response.dart';
import 'package:flutter_antonx_boilerplate/core/others/logger_customizations/custom_logger.dart';
import 'package:logger/logger.dart';

/// Mock Database Service for demonstration purposes
/// In a real app, this would connect to your backend API
class MockDatabaseService {
  static final Logger log = CustomLogger(className: 'MockDatabaseService');

  // Mock users database (in memory)
  static final Map<String, Map<String, dynamic>> _mockUsers = {
    'demo@example.com': {
      'id': '1',
      'email': 'demo@example.com',
      'password': 'password123', // In real app, this would be hashed
      'name': 'Demo User',
      'phone': '+1234567890',
      'created_at': '2024-01-01T00:00:00Z',
    },
    'admin@example.com': {
      'id': '2',
      'email': 'admin@example.com',
      'password': 'admin123',
      'name': 'Admin User',
      'phone': '+1234567891',
      'created_at': '2024-01-02T00:00:00Z',
    },
  };

  /// Mock login method
  Future<AuthResponse> loginWithEmailAndPassword(LoginBody body) async {
    log.d('Mock login attempt for: ${body.email}');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final email = body.email?.toLowerCase();
    final password = body.password;

    if (email == null || password == null) {
      return AuthResponse(false, error: 'Email and password are required');
    }

    final user = _mockUsers[email];
    if (user == null) {
      log.d('User not found: $email');
      return AuthResponse(false, error: 'User not found');
    }

    if (user['password'] != password) {
      log.d('Invalid password for: $email');
      return AuthResponse(false, error: 'Invalid password');
    }

    // Generate mock token
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

    log.d('Login successful for: $email');
    return AuthResponse(true, accessToken: token);
  }

  /// Mock signup method
  Future<AuthResponse> createAccount(SignUpBody body) async {
    log.d('Mock signup attempt for: ${body.email}');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final email = body.email?.toLowerCase();
    final password = body.password;
    final name = body.name;

    if (email == null || password == null || name == null) {
      return AuthResponse(
        false,
        error: 'Email, password, and name are required',
      );
    }

    // Check if user already exists
    if (_mockUsers.containsKey(email)) {
      log.d('User already exists: $email');
      return AuthResponse(false, error: 'User already exists');
    }

    // Create new user
    final newUser = {
      'id': (_mockUsers.length + 1).toString(),
      'email': email,
      'password': password, // In real app, this would be hashed
      'name': name,
      'phone': body.phone ?? '',
      'created_at': DateTime.now().toIso8601String(),
    };

    _mockUsers[email] = newUser;

    // Generate mock token
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

    log.d('Signup successful for: $email');
    return AuthResponse(true, accessToken: token);
  }

  /// Mock method to get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    log.d('Mock getUserProfile called');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return a mock user profile
    return {
      'id': '1',
      'email': 'demo@example.com',
      'name': 'Demo User',
      'phone': '+1234567890',
      'avatar': null,
      'created_at': '2024-01-01T00:00:00Z',
      'updated_at': '2024-01-01T00:00:00Z',
    };
  }

  /// Mock method to update FCM token
  Future<bool> updateFcmToken(String deviceId, String fcmToken) async {
    log.d('Mock updateFcmToken called for device: $deviceId');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock success
    return true;
  }

  /// Mock method to clear FCM token
  Future<bool> clearFcmToken(String deviceId) async {
    log.d('Mock clearFcmToken called for device: $deviceId');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock success
    return true;
  }

  /// Mock method to reset password
  Future<AuthResponse> resetPassword(dynamic body) async {
    log.d('Mock resetPassword called');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock success
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    return AuthResponse(true, accessToken: token);
  }
}
