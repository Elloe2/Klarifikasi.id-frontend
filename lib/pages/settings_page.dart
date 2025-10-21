import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!authProvider.isAuthenticated) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Pengaturan'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.backgroundGradient,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Login untuk mengakses pengaturan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primarySeedColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Masuk / Daftar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Pengaturan'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white70),
                tooltip: 'Keluar',
                onPressed: () => _showLogoutDialog(context, authProvider),
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile Card
                _ProfileCard(user: authProvider.currentUser!),

                const SizedBox(height: 16),

                // Edit Profile Card
                _EditProfileCard(user: authProvider.currentUser!),

                const SizedBox(height: 16),

                // App Info Card
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.cardGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.cardShadows,
                  ),
                  child: const ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(Icons.info_outline, color: Colors.white70),
                    title: Text(
                      'Versi Aplikasi',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'v2.0.0 - Sistem autentikasi terintegrasi',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar Akun?'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              // Tutup dialog terlebih dahulu
              Navigator.of(dialogContext).pop();

              // Lakukan logout
              await authProvider.logout();

              // Gunakan context dari State untuk operasi UI
              if (mounted) {
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('Berhasil keluar')),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadows,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primarySeedColor,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              user.email,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
            if (user.age != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primarySeedColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${user.age} tahun',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.primarySeedColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (user.educationDisplay != null) ...[
              const SizedBox(height: 4),
              Text(
                user.educationDisplay!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white60),
              ),
            ],
            if (user.institution != null) ...[
              Text(
                user.institution!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white60),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EditProfileCard extends StatefulWidget {
  const _EditProfileCard({required this.user});

  final User user;

  @override
  State<_EditProfileCard> createState() => _EditProfileCardState();
}

class _EditProfileCardState extends State<_EditProfileCard> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _birthDateController;
  late TextEditingController _institutionController;

  String? _selectedEducation;
  bool _isEditing = false;
  bool _isLoading = false;

  final List<Map<String, String>> _educationOptions = [
    {'value': 'sd', 'label': 'Sekolah Dasar'},
    {'value': 'smp', 'label': 'Sekolah Menengah Pertama'},
    {'value': 'sma', 'label': 'Sekolah Menengah Atas'},
    {'value': 'kuliah', 'label': 'Mahasiswa/Kuliah'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _birthDateController = TextEditingController(text: widget.user.birthDate);
    _institutionController = TextEditingController(
      text: widget.user.institution,
    );
    _selectedEducation = widget.user.educationLevel;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_isEditing) {
      setState(() => _isEditing = true);
      return;
    }

    // Validasi form sebelum submit
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validasi format email
    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format email tidak valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Pastikan masih mounted sebelum mengakses context
      if (!mounted) return;

      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        birthDate: _birthDateController.text.isNotEmpty
            ? _birthDateController.text
            : null,
        educationLevel: _selectedEducation,
        institution: _institutionController.text.isNotEmpty
            ? _institutionController.text
            : null,
      );

      if (!mounted) return;

      if (success) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Pastikan widget masih mounted sebelum menggunakan context
      if (mounted) {
        _handleUpdateError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleUpdateError(String errorMessage) {
    if (errorMessage.toLowerCase().contains('email sudah digunakan') ||
        errorMessage.toLowerCase().contains('email already exists')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email sudah digunakan oleh pengguna lain'),
          backgroundColor: Colors.orange,
        ),
      );
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui profil: $errorMessage'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadows,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profil Pengguna',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton.icon(
                  onPressed: _updateProfile,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          _isEditing ? Icons.save : Icons.edit,
                          color: AppTheme.primarySeedColor,
                        ),
                  label: Text(
                    _isEditing ? 'Simpan' : 'Edit',
                    style: TextStyle(color: AppTheme.primarySeedColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name Field
            _buildField(
              label: 'Nama Lengkap',
              controller: _nameController,
              enabled: _isEditing,
              icon: Icons.person,
            ),

            const SizedBox(height: 12),

            // Email Field
            _buildField(
              label: 'Email',
              controller: _emailController,
              enabled: _isEditing,
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 12),

            // Birth Date Field
            _buildDateField(),

            const SizedBox(height: 12),

            // Education Dropdown
            _buildEducationDropdown(),

            if (_selectedEducation != null) ...[
              const SizedBox(height: 12),
              _buildField(
                label:
                    'Nama ${_educationOptions.firstWhere((e) => e['value'] == _selectedEducation)['label']}',
                controller: _institutionController,
                enabled: _isEditing,
                icon: Icons.school,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: enabled
            ? AppTheme.surfaceDark.withValues(alpha: 0.5)
            : Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: _birthDateController,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: 'Tanggal Lahir',
        prefixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
        suffixIcon: _isEditing
            ? IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white70),
                onPressed: _isEditing
                    ? () async {
                        if (!mounted) return;

                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().subtract(
                            const Duration(days: 365 * 18),
                          ),
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

                        if (picked != null && mounted) {
                          setState(() {
                            _birthDateController.text = picked.toString().split(
                              ' ',
                            )[0];
                          });
                        }
                      }
                    : null,
              )
            : null,
        filled: true,
        fillColor: _isEditing
            ? AppTheme.surfaceDark.withValues(alpha: 0.5)
            : Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white),
      readOnly: !_isEditing,
      onTap: _isEditing
          ? () async {
              if (!mounted) return;

              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(
                  const Duration(days: 365 * 18),
                ),
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

              if (picked != null && mounted) {
                setState(() {
                  _birthDateController.text = picked.toString().split(' ')[0];
                });
              }
            }
          : null,
    );
  }

  Widget _buildEducationDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedEducation,
      decoration: InputDecoration(
        labelText: 'Pendidikan',
        prefixIcon: const Icon(Icons.school, color: Colors.white70),
        filled: true,
        fillColor: _isEditing
            ? AppTheme.surfaceDark.withValues(alpha: 0.5)
            : Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white),
      dropdownColor: AppTheme.surfaceDark,
      onChanged: _isEditing
          ? (value) => setState(() => _selectedEducation = value)
          : null,
      items: _educationOptions.map((option) {
        return DropdownMenuItem(
          value: option['value'],
          child: Text(
            option['label']!,
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
