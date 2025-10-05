import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:8000/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<User?> getCurrentUser() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$_baseUrl/auth/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else if (response.statusCode == 401) {
        // Token expired, delete it
        await _storage.delete(key: 'auth_token');
        return null;
      } else {
        return null;
      }
    } catch (e) {
      await _storage.delete(key: 'auth_token');
      return null;
    }
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? birthDate,
    String? educationLevel,
    String? institution,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        if (birthDate != null) 'birth_date': birthDate,
        if (educationLevel != null) 'education_level': educationLevel,
        if (institution != null) 'institution': institution,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      // Save token
      await _storage.write(key: 'auth_token', value: token);

      return User.fromJson(data['user']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Registration failed');
    }
  }

  Future<User> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      // Save token
      await _storage.write(key: 'auth_token', value: token);

      return User.fromJson(data['user']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      try {
        await http.post(
          Uri.parse('$_baseUrl/auth/logout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
      } catch (e) {
        // Ignore errors during logout
      }
    }

    await _storage.delete(key: 'auth_token');
  }

  Future<User> updateProfile({
    String? name,
    String? email,
    String? birthDate,
    String? educationLevel,
    String? institution,
  }) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$_baseUrl/auth/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (birthDate != null) 'birth_date': birthDate,
        if (educationLevel != null) 'education_level': educationLevel,
        if (institution != null) 'institution': institution,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Update failed');
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
