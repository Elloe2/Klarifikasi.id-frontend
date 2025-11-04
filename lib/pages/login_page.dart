import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart'; // Provider yang mengelola status autentikasi
import '../theme/app_theme.dart'; // Palet warna dan gaya UI konsisten

/// Halaman login utama untuk pengguna Klarifikasi.id.
/// Menyediakan form email/password, validasi, dan feedback error terarah.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Kunci form untuk melakukan validasi dan menyimpan state form
  final _formKey = GlobalKey<FormState>();

  // Controller input untuk mengambil nilai email & password dari TextField
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Flag untuk menampilkan indikator loading saat request login diproses
  bool _isLoading = false;

  // Flag untuk mengendalikan visibilitas password pada field password
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Dengarkan perubahan autentikasi setelah frame pertama ter-render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      authProvider.addListener(_onAuthStateChanged);
    });
  }

  @override
  void dispose() {
    // Remove listener safely
    try {
      final authProvider = context.read<AuthProvider>();
      authProvider.removeListener(_onAuthStateChanged);
    } catch (e) {
      // Provider might be disposed already
    }

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (!mounted) return;
    
    try {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated && mounted) {
        // Jika user berhasil login, navigasikan ke dashboard utama
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        });
      }
    } catch (e) {
      // Context no longer valid, widget unmounted
    }
  }

  Future<void> _login() async {
    // Jalankan validasi form sebelum mengirim request ke server
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login berhasil!')));
        // AuthProvider akan handle navigation otomatis via listener
      }
    } catch (e) {
      if (mounted) {
        _handleLoginError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleLoginError(String errorMessage) {
    // Cek apakah error menunjukkan kredensial salah
    if (errorMessage.toLowerCase().contains('email atau password salah') ||
        errorMessage.toLowerCase().contains('invalid credentials') ||
        errorMessage.toLowerCase().contains('unauthorized')) {
      _showInvalidCredentialsDialog();
    } else if (errorMessage.toLowerCase().contains('koneksi internet') ||
        errorMessage.toLowerCase().contains('network error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Koneksi internet bermasalah. Silakan periksa koneksi Anda.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    } else if (errorMessage.toLowerCase().contains('timeout')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Koneksi timeout. Silakan coba lagi.'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      // Error lainnya tetap menggunakan snackbar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void _showInvalidCredentialsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.redAccent, size: 28),
              const SizedBox(width: 12),
              Text(
                'Login Gagal',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email atau password yang Anda masukkan salah.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'Email: ${_emailController.text}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pastikan email dan password sudah benar, atau daftar akun baru jika belum memiliki akun.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Coba Lagi',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context).pushReplacementNamed('/register');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primarySeedColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Daftar Akun',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(flex: 1),

                      // Spotify-style Header
                      Center(
                        child: Column(
                          children: [
                            // Logo KLARIFIKASI.ID yang baru
                            Image.asset(
                              'assets/logo/logo_klarifikasi_dengan_nama.png',
                              width: 200,
                              height: 80,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.verified_user,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 60),
                            Text(
                              'Selamat Datang',
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 32,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Masuk untuk melanjutkan verifikasi informasi',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Form Fields dengan width constraint seperti Spotify
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 400, // Maksimal lebar seperti Spotify
                            minWidth: 300, // Minimal lebar untuk mobile
                          ),
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'nama@email.com',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email tidak boleh kosong';
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return 'Format email tidak valid';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              _buildTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Masukkan password Anda',
                                icon: Icons.lock,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 32),

                              // Spotify-style Login Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primarySeedColor,
                                    foregroundColor: Colors
                                        .black, // Black text seperti Spotify
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        25,
                                      ), // More rounded seperti Spotify
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.black,
                                                ),
                                          ),
                                        )
                                      : Text(
                                          'Masuk',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Register Link dengan better styling
                              Center(
                                child: TextButton(
                                  onPressed: () => Navigator.of(
                                    context,
                                  ).pushReplacementNamed('/register'),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Belum punya akun? ',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                      children: [
                                        TextSpan(
                                          text: 'Daftar sekarang',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color:
                                                    AppTheme.primarySeedColor,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor:
                                                    AppTheme.primarySeedColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.primarySeedColor, size: 20),
          suffixIcon: suffixIcon,
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
