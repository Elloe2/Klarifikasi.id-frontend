import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  bool _isLoading = false;
  bool _isInitialized = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      _currentUser = null;
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.login(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Re-throw dengan informasi error yang lebih spesifik
      if (e.toString().toLowerCase().contains('invalid credentials') ||
          e.toString().toLowerCase().contains('unauthorized') ||
          e.toString().toLowerCase().contains('401')) {
        throw Exception('Email atau password salah. Silakan periksa kembali kredensial Anda.');
      } else if (e.toString().toLowerCase().contains('network') ||
                 e.toString().toLowerCase().contains('connection')) {
        throw Exception('Koneksi internet bermasalah. Silakan periksa koneksi Anda.');
      } else if (e.toString().toLowerCase().contains('timeout')) {
        throw Exception('Koneksi timeout. Silakan coba lagi.');
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? birthDate,
    String? educationLevel,
    String? institution,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.register(
        name: name,
        email: email,
        password: password,
        birthDate: birthDate,
        educationLevel: educationLevel,
        institution: institution,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    String? birthDate,
    String? educationLevel,
    String? institution,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.updateProfile(
        name: name,
        email: email,
        birthDate: birthDate,
        educationLevel: educationLevel,
        institution: institution,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> handleAuthError() async {
    await logout();
    // Navigation will be handled by listeners
  }

  Future<bool> isLoggedIn() async {
    try {
      return await _authService.isLoggedIn();
    } catch (e) {
      return false;
    }
  }
}
