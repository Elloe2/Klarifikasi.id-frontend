// === KLARIFIKASI.ID SEARCH PAGE ===
// Halaman utama aplikasi pencarian fakta dengan fitur-fitur canggih:
// - Scroll behavior untuk suggestion panel
// - Rate limiting dengan cooldown system
// - Animasi staggered untuk hasil pencarian
// - Layout horizontal untuk link dan credibility badge
// - Error handling dan loading states yang komprehensif

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/search_result.dart';
import '../models/gemini_analysis.dart';
import '../services/search_api.dart';
import '../theme/app_theme.dart';
import '../widgets/error_banner.dart';
import '../widgets/gemini_chatbot.dart';

// === WIDGET UTAMA: SEARCH PAGE ===
// StatefulWidget yang menangani seluruh logika pencarian dan state management
// Mengintegrasikan berbagai komponen UI untuk memberikan pengalaman pencarian yang optimal
class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.api, this.onSettingsTap});

  final SearchApi api;
  final VoidCallback? onSettingsTap;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _FallbackNotice extends StatelessWidget {
  const _FallbackNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppTheme.primarySeedColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Google Custom Search sedang tidak tersedia. Menampilkan analisis AI berbasis data yang ada.',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackState extends StatelessWidget {
  const _FallbackState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                ),
                child: const Icon(Icons.bolt_outlined, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                'Analisis AI fallback ditampilkan',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Kami belum mendapatkan hasil dari Google Custom Search, namun Gemini tetap memberikan ringkasan berdasarkan informasi yang tersedia.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.subduedGray),
              ),
              const SizedBox(height: 24),
              Text(
                'Coba cari lagi beberapa saat atau gunakan kata kunci lain untuk mendapatkan hasil lengkap.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.mutedGray),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === STATE MANAGEMENT CLASS ===
// Mengelola semua state dan logic bisnis untuk halaman pencarian
// Mengimplementasikan pattern BLoC sederhana untuk state management
class _SearchPageState extends State<SearchPage> {
  // === SCROLL CONTROLLER ===
  // Controller untuk menangani scroll behavior dan visibility suggestion panel
  final ScrollController _scrollController = ScrollController();

  // === PAGE CONTROLLER ===
  // Controller untuk horizontal slide antara Gemini dan Search Results
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  // === TEXT INPUT CONTROLLERS ===
  // Controller untuk menangani input text pencarian dari user
  final TextEditingController _controller = TextEditingController();
  // Focus node untuk mengelola keyboard dan focus events
  final FocusNode _queryFocus = FocusNode();

  // === RATE LIMITING SYSTEM ===
  // Duration cooldown antara pencarian (5 detik untuk mencegah spam)
  final Duration _cooldown = const Duration(seconds: 5);

  // === SEARCH RESULTS STATE ===
  // List untuk menyimpan hasil pencarian dari API
  List<SearchResult> _results = const [];
  // Boolean untuk menunjukkan status loading saat pencarian sedang berlangsung
  bool _isLoading = false;
  // Gemini AI analysis result
  GeminiAnalysis? _geminiAnalysis;
  // String untuk menyimpan error message jika terjadi kesalahan
  String? _error;
  // Timestamp pencarian terakhir untuk rate limiting
  DateTime? _lastSearchTime;
  // Timer untuk menghitung mundur cooldown period
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    // Setup scroll listener untuk mengontrol suggestion panel visibility
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // === CLEANUP ===
    // Bersihkan semua controller dan listener untuk mencegah memory leak
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _pageController.dispose();
    _controller.dispose();
    _queryFocus.dispose();

    // Cancel timer jika masih aktif
    _cooldownTimer?.cancel();

    // Call parent dispose
    super.dispose();
  }

  void _onScroll() {
    // Scroll listener - currently not used since suggestion panel is removed
    // Kept for potential future features
  }

  void _startCooldownTimer() {
    // === TIMER COOLDOWN ===
    // Method ini memulai timer periodik untuk menghitung mundur cooldown
    // Timer berjalan setiap 1 detik dan akan otomatis berhenti ketika cooldown habis

    // Cancel timer sebelumnya jika masih aktif untuk menghindari memory leak
    _cooldownTimer?.cancel();

    // Membuat timer periodik yang berjalan setiap 1 detik
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Ambil waktu pencarian terakhir dari state
      final last = _lastSearchTime;

      // Jika tidak ada waktu pencarian terakhir, hentikan timer
      if (last == null) {
        timer.cancel();
        return;
      }

      // Hitung selisih waktu antara sekarang dengan waktu pencarian terakhir
      final diff = DateTime.now().difference(last);

      // Hitung sisa waktu cooldown yang tersisa
      final remaining = _cooldown - diff;

      // Jika cooldown sudah habis (remaining negatif atau 0)
      if (remaining.isNegative) {
        // Update UI untuk menunjukkan cooldown sudah selesai
        setState(() {});
        // Hentikan timer karena sudah tidak diperlukan lagi
        timer.cancel();
      } else {
        // Update UI untuk menunjukkan sisa waktu cooldown
        // Progress bar akan ter-update berdasarkan sisa waktu ini
        setState(() {});
      }
    });
  }

  Duration? _checkCooldown() {
    // === CEK STATUS COOLDOWN ===
    // Method ini menghitung dan mengembalikan sisa waktu cooldown
    // Return null jika cooldown sudah habis, atau Duration jika masih aktif

    // Jika belum pernah melakukan pencarian, return null (tidak ada cooldown)
    if (_lastSearchTime == null) return null;

    // Hitung selisih waktu antara sekarang dengan waktu pencarian terakhir
    final diff = DateTime.now().difference(_lastSearchTime!);

    // Hitung sisa waktu cooldown yang tersisa
    final remaining = _cooldown - diff;

    // Jika sisa waktu negatif atau 0, berarti cooldown sudah habis
    if (remaining.isNegative) {
      return null; // Tidak ada cooldown aktif
    }

    // Return sisa waktu cooldown yang tersisa
    return remaining;
  }

  void _performSearchWithLimit() async {
    // === METODE PENCARIAN UTAMA ===
    // Method ini menangani proses pencarian dengan semua validasi dan error handling
    // Mengimplementasikan rate limiting dan validasi input

    // Safety check untuk memastikan widget masih mounted sebelum async operation
    if (!mounted) return;

    // Ambil dan bersihkan query dari text controller
    final query = _controller.text.trim();

    // === VALIDASI INPUT ===
    // Validasi 1: Pastikan query tidak kosong
    if (query.isEmpty) {
      _showSnackBar('Masukkan kata kunci pencarian.');
      return;
    }

    // Validasi 2: Pastikan query minimal 3 karakter untuk hasil yang relevan
    if (query.length < 3) {
      _showSnackBar('Kata kunci minimal 3 karakter.');
      return;
    }

    // === CEK RATE LIMITING ===
    // Validasi 3: Cek apakah masih dalam periode cooldown
    final cooldown = _checkCooldown();
    if (cooldown != null) {
      _showSnackBar('Tunggu ${cooldown.inSeconds} detik sebelum mencari lagi.');
      return;
    }

    // === MULAI PROSES PENCARIAN ===
    // Update state untuk menunjukkan loading state dan reset error
    setState(() {
      _isLoading = true; // Aktifkan loading indicator
      _error = null; // Reset error message
      _lastSearchTime = DateTime.now(); // Record waktu pencarian
    });

    // Mulai timer cooldown untuk rate limiting
    _startCooldownTimer();

    // === EKSEKUSI PENCARIAN ===
    try {
      // Panggil API dengan query dan limit hasil (default 20)
      final response = await widget.api.search(query, limit: 20);

      // Safety check lagi setelah await
      if (mounted) {
        // Update state dengan hasil pencarian dan Gemini analysis
        setState(() {
          _results =
              response['results'] as List<SearchResult>; // Set hasil pencarian
          _geminiAnalysis =
              response['gemini_analysis']
                  as GeminiAnalysis?; // Set Gemini analysis
          _isLoading = false; // Matikan loading indicator
          _currentPageIndex = 0; // Auto-navigate to Gemini analysis tab
        });
      }
    } catch (e) {
      // === ERROR HANDLING ===
      // Tangani error yang terjadi selama proses pencarian
      if (mounted) {
        setState(() {
          _error = e.toString(); // Simpan error message
          _isLoading = false; // Matikan loading indicator
          _geminiAnalysis = null; // Reset Gemini analysis
        });
      }
    }
  }

  Future<void> _openResult(String url) async {
    // === BUKA URL HASIL PENCARIAN ===
    // Method ini menangani pembukaan URL hasil pencarian di browser eksternal

    // Parse URL untuk memastikan formatnya valid
    final uri = Uri.tryParse(url);

    // Validasi URL yang diterima
    if (uri == null) {
      _showSnackBar('URL tidak valid.');
      return;
    }

    // Coba buka URL menggunakan launcher dengan mode external application
    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);

    // Berikan feedback jika gagal membuka URL
    if (!success) {
      _showSnackBar('Tidak dapat membuka tautan.');
    }
  }

  void _showSnackBar(String message) {
    // === TAMPILKAN NOTIFIKASI ===
    // Method utility untuk menampilkan snackbar dengan pesan tertentu

    // Safety check untuk memastikan widget masih mounted
    if (!mounted) return;

    // Tampilkan snackbar menggunakan ScaffoldMessenger
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _copyLink(String url) async {
    // === COPY URL KE CLIPBOARD ===
    // Method ini menyalin URL hasil pencarian ke clipboard device

    // Gunakan Clipboard API untuk menyalin text ke clipboard
    await Clipboard.setData(ClipboardData(text: url));

    // Berikan feedback bahwa URL berhasil disalin
    _showSnackBar('Tautan sumber disalin ke clipboard.');
  }

  @override
  Widget build(BuildContext context) {
    // === MAIN UI BUILDER ===
    // Method utama yang membangun seluruh interface pengguna
    // Menggunakan conditional rendering berdasarkan state aplikasi

    // Ambil theme context untuk styling yang konsisten
    final theme = Theme.of(context);
    // Cek status cooldown untuk menampilkan progress bar jika aktif
    final onCooldown = _checkCooldown();

    return Scaffold(
      // === SCAFFOLD SETUP ===
      // Background transparan untuk menggunakan gradient background
      backgroundColor: Colors.transparent,
      // Extend body untuk menggunakan full screen area
      extendBody: true,

      // === SPOTIFY-STYLE APP BAR ===
      // Clean header seperti Spotify with settings button
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Klarifikasi.id',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          // Settings button
          if (widget.onSettingsTap != null)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: widget.onSettingsTap,
              tooltip: 'Pengaturan',
              color: Colors.white,
            ),
        ],
      ),

      // === MAIN BODY ===
      body: Container(
        // === BACKGROUND GRADIENT ===
        // Menggunakan gradient background sesuai tema aplikasi
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),

        child: Align(
          // === CENTERED LAYOUT ===
          // Menggunakan alignment top center untuk layout yang konsisten
          alignment: Alignment.topCenter,

          child: ConstrainedBox(
            // === RESPONSIVE CONSTRAINT ===
            // Membatasi lebar maksimal untuk layout desktop yang optimal
            constraints: const BoxConstraints(maxWidth: 920),

            child: Padding(
              // === HORIZONTAL PADDING ===
              // Memberikan padding horizontal untuk spacing yang konsisten
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Column(
                // === MAIN COLUMN LAYOUT ===
                // Layout utama menggunakan column dengan stretch alignment
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  // === TOP SPACING ===
                  const SizedBox(height: 24),

                  // === SEARCH CARD ===
                  // Komponen utama untuk input pencarian dengan semua fitur
                  _SearchCard(
                    controller: _controller,
                    focusNode: _queryFocus,
                    isLoading: _isLoading,
                    cooldown: onCooldown,
                    onSearch: () => _performSearchWithLimit(),
                  ),

                  // === COOLDOWN PROGRESS INDICATOR ===
                  // Menampilkan progress bar dan countdown jika dalam periode cooldown
                  if (onCooldown != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text countdown timer
                          Text(
                            'Tunggu ${onCooldown.inSeconds} detik sebelum mencari lagi.',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 6),
                          // Progress bar untuk visual feedback
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              // Calculate progress based on elapsed vs total cooldown time
                              value:
                                  ((_cooldown.inMilliseconds -
                                              onCooldown.inMilliseconds) /
                                          _cooldown.inMilliseconds)
                                      .clamp(0.0, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // === SPACING ===
                  const SizedBox(height: 20),

                  // === SUGGESTION PANEL REMOVED ===
                  // Suggestion panel has been removed per user request

                  // === ERROR BANNER ===
                  // Tampilkan error message jika terjadi kesalahan
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    ErrorBanner(message: _error!),
                  ],

                  // === HORIZONTAL SLIDE CONTENT ===
                  // PageView untuk slide antara Gemini Analysis dan Search Results
                  if (_results.isNotEmpty || _isLoading || _geminiAnalysis != null) ...[
                    const SizedBox(height: 12),
                    
                    // Tab Indicator
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _TabButton(
                              icon: Icons.auto_awesome,
                              label: 'Analisis AI',
                              isActive: _currentPageIndex == 0,
                              onTap: () {
                                _pageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _TabButton(
                              icon: Icons.search,
                              label: 'Hasil Pencarian',
                              isActive: _currentPageIndex == 1,
                              onTap: () {
                                _pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                  ],

                  // === MAIN CONTENT AREA ===
                  Expanded(
                    child: (_results.isNotEmpty || _isLoading || _geminiAnalysis != null)
                        ? PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPageIndex = index;
                              });
                            },
                            children: [
                              // Page 1: Gemini Analysis
                              SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    if (_results.isEmpty && !_isLoading && _geminiAnalysis != null)
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 12),
                                        child: _FallbackNotice(),
                                      ),
                                    GeminiChatbot(
                                      analysis: _geminiAnalysis,
                                      isLoading: _isLoading,
                                      onRetry: () {
                                        _performSearchWithLimit();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Page 2: Search Results
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: _isLoading
                                    ? const _LoadingState()
                                    : _results.isEmpty
                                        ? (_geminiAnalysis != null
                                            ? const _FallbackState()
                                            : const _EmptyState())
                                        : _ResultsList(
                                            results: _results,
                                            onOpen: _openResult,
                                            onCopy: _copyLink,
                                          ),
                              ),
                            ],
                          )
                        : const _EmptyState(),
                  ),

                  // === BOTTOM SPACING ===
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// === SUGGESTION PANEL CLASSES REMOVED ===
// All suggestion panel related classes have been removed per user request
// (_SuggestionPanel, _SuggestionChips, _AnimatedSuggestionChip)

// === SEARCH CARD WIDGET ===
// Widget stateful yang menangani input pencarian dengan search button
// Komponen utama untuk user interaction dengan fitur loading state dan cooldown indicator
class _SearchCard extends StatefulWidget {
  const _SearchCard({
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.cooldown,
    required this.onSearch,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLoading;
  final Duration? cooldown;
  final VoidCallback onSearch;

  @override
  State<_SearchCard> createState() => _SearchCardState();
}

// === SEARCH CARD STATE ===
// State management untuk search card dengan focus dan interaction handling
class _SearchCardState extends State<_SearchCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    onSubmitted: (_) => _performSearch(),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: "Cari fakta dari klaim di media sosial...",
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: AppTheme.surfaceDark,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.primaryGradient.colors.first,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: widget.isLoading ? null : _performSearch,
                    icon: widget.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch() {
    widget.onSearch();
  }
}

// === LOADING STATE WIDGET ===
// Widget untuk menampilkan loading indicator saat proses pencarian sedang berlangsung
// Memberikan visual feedback yang menarik dengan spinner dan text informatif
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Mencari sumber terpercaya...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// === EMPTY STATE WIDGET ===
// Widget kompleks yang ditampilkan ketika belum ada hasil pencarian
// Berisi animasi, statistik, dan tips verifikasi untuk user experience yang engaging
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // === ANIMATED ICON ===
              // Icon dengan animasi pulse menggunakan TweenAnimationBuilder
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.85, end: 1),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Image.asset(
                  'assets/logo/logo_klarifikasi_hanya_icon_kacamata_pembesar.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: AppTheme.secondaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.travel_explore,
                      size: 46,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // === GRADIENT TEXT TITLE ===
              // Judul dengan efek gradient menggunakan ShaderMask
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.white, Colors.white.withValues(alpha: 0.8)],
                ).createShader(bounds),
                child: Text(
                  'Verifikasi klaim di media sosial',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              // === DESCRIPTIVE CONTAINER ===
              // Container dengan informasi cara penggunaan aplikasi
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  "Ketikkan klaim dari sosial media yang ingin diperiksa. Sistem kami akan mencari sumber terpercaya untuk memverifikasi kebenarannya.",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // === TIPS SECTION ===
              // Container dengan tips verifikasi untuk user
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryGradient.colors.first.withValues(
                        alpha: 0.1,
                      ),
                      AppTheme.accentGradient.colors.first.withValues(
                        alpha: 0.05,
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryGradient.colors.first.withValues(
                      alpha: 0.2,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: AppTheme.tertiaryAccentColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tips Verifikasi',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TipItem(text: 'Periksa tanggal berita dan klaim yang ada'),
                    _TipItem(
                      text:
                          'Bandingkan dengan sumber resmi pemerintah atau lembaga terpercaya',
                    ),
                    _TipItem(
                      text:
                          'Waspadai judul clickbait yang provokatif di internet',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === TIP ITEM WIDGET ===
// Widget untuk menampilkan individual tip dengan bullet point dan styling
// Menggunakan Row layout dengan bullet point dan expanded text
class _TipItem extends StatelessWidget {
  const _TipItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.tertiaryAccentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// === RESULTS LIST WIDGET ===
// Widget untuk menampilkan daftar hasil pencarian dengan separator dan animations
// Menggunakan ListView.separated untuk layout yang optimal
class _ResultsList extends StatelessWidget {
  const _ResultsList({
    required this.results,
    required this.onOpen,
    required this.onCopy,
  });

  final List<SearchResult> results;
  final ValueChanged<String> onOpen;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: ValueKey(results.length),
      padding: const EdgeInsets.only(bottom: 8),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final result = results[index];
        return _AnimatedResultCard(
          result: result,
          onOpen: onOpen,
          onCopy: onCopy,
          index: index,
        );
      },
    );
  }
}

// === ANIMATED RESULT CARD WIDGET ===
// StatefulWidget wrapper yang memberikan animasi pada result card
// Menggunakan staggered animation berdasarkan index untuk efek yang smooth
class _AnimatedResultCard extends StatefulWidget {
  const _AnimatedResultCard({
    required this.result,
    required this.onOpen,
    required this.onCopy,
    required this.index,
  });

  final SearchResult result;
  final ValueChanged<String> onOpen;
  final ValueChanged<String> onCopy;
  final int index;

  @override
  State<_AnimatedResultCard> createState() => _AnimatedResultCardState();
}

// === ANIMATED RESULT CARD STATE ===
// State management untuk animasi result card dengan staggered delay
class _AnimatedResultCardState extends State<_AnimatedResultCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // === STAGGERED ANIMATION ===
    // Setiap card muncul dengan delay berdasarkan index untuk efek waterfall
    Future.delayed(Duration(milliseconds: widget.index * 150), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: _ResultCard(
              result: widget.result,
              onOpen: widget.onOpen,
              onCopy: widget.onCopy,
            ),
          ),
        );
      },
    );
  }
}

// === RESULT CARD WIDGET ===
// Widget utama untuk menampilkan individual search result dengan layout adaptif
// Berisi thumbnail (conditional), title, metadata, dan action buttons dengan layout yang responsive
class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.result,
    required this.onOpen,
    required this.onCopy,
  });

  final SearchResult result;
  final ValueChanged<String> onOpen;
  final ValueChanged<String> onCopy;

  // Credibility helper methods removed since credibility badge is removed

  /// Format social media links to display as "Postingan di [Platform]"
  String _formatSocialMediaLink(String displayLink) {
    final lowerLink = displayLink.toLowerCase();
    
    if (lowerLink.contains('instagram.com')) {
      return 'Postingan di Instagram';
    } else if (lowerLink.contains('facebook.com') || lowerLink.contains('fb.com')) {
      return 'Postingan di Facebook';
    } else if (lowerLink.contains('twitter.com') || lowerLink.contains('x.com')) {
      return 'Postingan di X';
    } else if (lowerLink.contains('youtube.com') || lowerLink.contains('youtu.be')) {
      return 'Postingan di YouTube';
    } else if (lowerLink.contains('reddit.com')) {
      return 'Postingan di Reddit';
    } else if (lowerLink.contains('tiktok.com')) {
      return 'Postingan di TikTok';
    } else if (lowerLink.contains('linkedin.com')) {
      return 'Postingan di LinkedIn';
    } else if (lowerLink.contains('threads.net')) {
      return 'Postingan di Threads';
    }
    
    // Return original display link if not a social media platform
    return displayLink;
  }

  String _getRelativeTime(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === ADAPTIVE LAYOUT: THUMBNAIL + CONTENT ===
            // Layout yang menyesuaikan berdasarkan ada/tidaknya thumbnail
            // Jika thumbnail ada: thumbnail + spacing + content
            // Jika thumbnail tidak ada: content memenuhi seluruh lebar
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === CONDITIONAL THUMBNAIL ===
                // Hanya tampilkan thumbnail jika tersedia dan tidak kosong
                // Sistem ini memberikan UX yang lebih bersih tanpa placeholder yang tidak perlu
                if (result.thumbnail != null && result.thumbnail!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      result.thumbnail!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      // === ERROR HANDLING ===
                      // Jika thumbnail gagal dimuat (broken URL), hilangkan thumbnail
                      // Daripada menampilkan placeholder yang tidak berguna
                      errorBuilder: (context, error, stackTrace) {
                        // Kembalikan widget kosong untuk menghilangkan thumbnail
                        return const SizedBox.shrink();
                      },
                      // === LOADING HANDLING ===
                      // Saat thumbnail sedang dimuat, tampilkan placeholder sementara
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.image,
                            color: Colors.white38,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),

                // === DYNAMIC SPACING ===
                // Spacing hanya diterapkan jika thumbnail ada
                // Jika thumbnail tidak ada, spacing juga tidak diperlukan
                if (result.thumbnail != null && result.thumbnail!.isNotEmpty)
                  const SizedBox(width: 16),

                // === ADAPTIVE CONTENT ===
                // Konten teks yang secara otomatis menyesuaikan lebar
                // Jika ada thumbnail: lebar terbatas dengan Expanded
                // Jika tidak ada thumbnail: memenuhi seluruh ruang yang tersedia
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // === ARTICLE TITLE ===
                      // Judul artikel dengan typography yang konsisten
                      Text(
                        result.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // === METADATA ROW: WEBSITE LINK + CREDIBILITY BADGE ===
                      // Layout horizontal untuk metadata dengan spacing yang konsisten
                      Row(
                        children: [
                          // === WEBSITE LINK BADGE ===
                          // Badge yang menunjukkan sumber website artikel
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFECE3),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.public,
                                    size: 16,
                                    color: Color(0xFF4A70A9),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _formatSocialMediaLink(result.displayLink),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: const Color(0xFF4A70A9),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Credibility badge removed per user request
                        ],
                      ),

                      // === CONDITIONAL TIMESTAMP ===
                      // Timestamp relatif hanya ditampilkan jika ada data tanggal
                      if (_getRelativeTime(result.publishedDate).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            _getRelativeTime(result.publishedDate),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),

                      // === SPACING BEFORE SNIPPET ===
                      const SizedBox(height: 12),

                      // === ARTICLE SNIPPET ===
                      // Cuplikan artikel dengan typography yang mudah dibaca
                      Text(
                        result.snippet,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // === SPACING BEFORE ACTION BUTTONS ===
            const SizedBox(height: 12),

            // === ACTION BUTTONS ===
            // Tombol aksi untuk membuka sumber dan menyalin tautan
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                // === PRIMARY ACTION: OPEN SOURCE ===
                FilledButton.tonal(
                  onPressed: result.link.isEmpty
                      ? null
                      : () => onOpen(result.link),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryGradient.colors.first,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    minimumSize: const Size(120, 44),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.open_in_new, size: 18),
                      SizedBox(width: 8),
                      Text('Buka sumber'),
                    ],
                  ),
                ),

                // === SECONDARY ACTION: COPY LINK ===
                OutlinedButton.icon(
                  onPressed: result.link.isEmpty
                      ? null
                      : () => onCopy(result.link),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    minimumSize: const Size(120, 44),
                  ),
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Salin tautan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// === TAB BUTTON WIDGET ===
// Custom tab button untuk switching antara Gemini Analysis dan Search Results
class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isActive ? AppTheme.primaryGradient : null,
          color: isActive ? null : AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : AppTheme.subduedGray,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isActive ? Colors.white : AppTheme.subduedGray,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
