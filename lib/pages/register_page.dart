import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _institutionController = TextEditingController();

  // State
  String? _selectedEducation;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<Map<String, String>> _educationOptions = [
    {'value': 'sd', 'label': 'Sekolah Dasar'},
    {'value': 'smp', 'label': 'Sekolah Menengah Pertama'},
    {'value': 'sma', 'label': 'Sekolah Menengah Atas'},
    {'value': 'kuliah', 'label': 'Mahasiswa/Kuliah'},
  ];

  @override
  void initState() {
    super.initState();
    // Listen for authentication state changes
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

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthDateController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isAuthenticated && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 365 * 18),
      ), // 18 tahun lalu
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primarySeedColor,
              surface: AppTheme.surfaceDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        birthDate: _birthDateController.text.isNotEmpty
            ? _birthDateController.text
            : null,
        educationLevel: _selectedEducation,
        institution: _institutionController.text.isNotEmpty
            ? _institutionController.text
            : null,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Registrasi berhasil!')));
        // AuthProvider akan handle navigation otomatis via listener
      }
    } catch (e) {
      if (mounted) {
        _handleRegisterError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleRegisterError(String errorMessage) {
    // Cek apakah error menunjukkan email sudah terdaftar
    if (errorMessage.toLowerCase().contains('email sudah terdaftar') ||
        errorMessage.toLowerCase().contains('email already exists') ||
        errorMessage.toLowerCase().contains('duplicate entry')) {
      _showEmailExistsDialog();
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

  void _showEmailExistsDialog() {
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
              Icon(Icons.email_outlined, color: Colors.orangeAccent, size: 28),
              const SizedBox(width: 12),
              Text(
                'Email Sudah Terdaftar',
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
                'Email ${_emailController.text} sudah terdaftar di sistem.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orangeAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'Email: ${_emailController.text}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Silakan gunakan email lain atau masuk jika Anda sudah memiliki akun.',
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
                'Ganti Email',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context).pushReplacementNamed('/login');
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
                'Masuk',
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
      resizeToAvoidBottomInset: false, // Prevent keyboard overlap
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                            // Clean logo tanpa container yang berlebihan
                            SvgPicture.asset(
                              'assets/logo/FIX_white.svg',
                              width: 80,
                              height: 80,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                              placeholderBuilder: (context) => const Icon(
                                Icons.person_add,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 60),
                            Text(
                              'Buat Akun Baru',
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 32,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bergabunglah untuk mulai verifikasi informasi',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Form Fields
                      _buildTextField(
                        controller: _nameController,
                        label: 'Nama Lengkap',
                        hint: 'Masukkan nama lengkap Anda',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),

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

                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Minimal 8 karakter',
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
                          if (value.length < 8) {
                            return 'Password minimal 8 karakter';
                          }
                          return null;
                        },
                      ),

                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Konfirmasi Password',
                        hint: 'Ulangi password Anda',
                        icon: Icons.lock,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password tidak boleh kosong';
                          }
                          if (value != _passwordController.text) {
                            return 'Password tidak cocok';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Birth Date Field
                      _buildDateField(),

                      const SizedBox(height: 16),

                      // Education Level Dropdown
                      _buildEducationDropdown(),

                      if (_selectedEducation != null) ...[
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _institutionController,
                          label:
                              'Nama ${_educationOptions.firstWhere((e) => e['value'] == _selectedEducation)['label']}',
                          hint:
                              'Masukkan nama ${_educationOptions.firstWhere((e) => e['value'] == _selectedEducation)['label'].toString().toLowerCase()}',
                          icon: Icons.school,
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: LoadingButton(
                          isLoading: _isLoading,
                          onPressed: _register,
                          child: Text(
                            'Daftar',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Login Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sudah punya akun? ',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(
                                context,
                              ).pushReplacementNamed('/login'),
                              child: Text(
                                'Masuk',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.primarySeedColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
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

  Widget _buildDateField() {
    return TextFormField(
      controller: _birthDateController,
      decoration: InputDecoration(
        labelText: 'Tanggal Lahir',
        hintText: 'Pilih tanggal lahir',
        prefixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.white70),
          onPressed: _selectBirthDate,
        ),
        filled: true,
        fillColor: AppTheme.surfaceDark.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primarySeedColor),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
      ),
      style: const TextStyle(color: Colors.white),
      readOnly: true,
      onTap: _selectBirthDate,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Tanggal lahir tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildEducationDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedEducation,
      decoration: InputDecoration(
        labelText: 'Pendidikan',
        prefixIcon: const Icon(Icons.school, color: Colors.white70),
        filled: true,
        fillColor: AppTheme.surfaceDark.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primarySeedColor),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
      ),
      style: const TextStyle(color: Colors.white),
      dropdownColor: AppTheme.surfaceDark,
      items: _educationOptions.map((option) {
        return DropdownMenuItem(
          value: option['value'],
          child: Text(
            option['label']!,
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedEducation = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Pendidikan tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
