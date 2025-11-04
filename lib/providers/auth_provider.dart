import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

/// Provider yang menangani state autentikasi aplikasi.
/// Berinteraksi dengan `AuthService` untuk login, register, dan manajemen profil,
/// lalu memancarkan perubahan state ke widget yang mendengarkan.
class AuthProvider extends ChangeNotifier {
  // Service layer yang berkomunikasi dengan backend Laravel
  final AuthService _authService = AuthService();

  // State internal yang menyimpan data user dan status proses
  User? _currentUser;
  bool _isLoading = false;
  bool _isInitialized = false;

  // Getter untuk expose state ke UI tanpa memperbolehkan modifikasi langsung
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _isLoading = true;
    _safeNotifyListeners();

    try {
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      _currentUser = null;
    } finally {
      _isLoading = false;
      _isInitialized = true;
      _safeNotifyListeners();
    }
  }

  /// Safe notify listeners - only notify if not disposed
  void _safeNotifyListeners() {
    if (!hasListeners) return;
    try {
      notifyListeners();
    } catch (e) {
      // Widget already disposed, ignore
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _safeNotifyListeners();

    try {
      _currentUser = await _authService.login(email: email, password: password);
      _isLoading = false;
      _safeNotifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _safeNotifyListeners();

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
    _safeNotifyListeners();

    try {
      _currentUser = await _authService.register(
        name: name,
        email: email,
        password: password,
        birthDate: birthDate,
        educationLevel: educationLevel,
        institution: institution,
      );
      _safeNotifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _safeNotifyListeners();
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
    _safeNotifyListeners();

    try {
      _currentUser = await _authService.updateProfile(
        name: name,
        email: email,
        birthDate: birthDate,
        educationLevel: educationLevel,
        institution: institution,
      );
      _safeNotifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _safeNotifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _safeNotifyListeners();
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
