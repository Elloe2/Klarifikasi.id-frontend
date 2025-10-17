// === KLARIFIKASI.ID SEARCH PAGE ===
// Halaman utama aplikasi pencarian fakta dengan fitur-fitur canggih:
// - Scroll behavior untuk suggestion panel
// - Rate limiting dengan cooldown system
// - Animasi staggered untuk hasil pencarian
// - Layout horizontal untuk link dan credibility badge
// - Error handling dan loading states yang komprehensif

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/search_result.dart';
import '../services/search_api.dart';
import '../theme/app_theme.dart';
import '../widgets/error_banner.dart';

// === WIDGET UTAMA: SEARCH PAGE ===
// StatefulWidget yang menangani seluruh logika pencarian dan state management
// Mengintegrasikan berbagai komponen UI untuk memberikan pengalaman pencarian yang optimal
class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.api});

  final SearchApi api;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

// === STATE MANAGEMENT CLASS ===
// Mengelola semua state dan logic bisnis untuk halaman pencarian
// Mengimplementasikan pattern BLoC sederhana untuk state management
class _SearchPageState extends State<SearchPage> {
  // === SCROLL CONTROLLER ===
  // Controller untuk menangani scroll behavior dan visibility suggestion panel
  final ScrollController _scrollController = ScrollController();

  // === UI STATE VARIABLES ===
  // Boolean flag untuk mengontrol visibility suggestion panel berdasarkan scroll position
  bool _showSuggestions = true;

  // === TEXT INPUT CONTROLLERS ===
  // Controller untuk menangani input text pencarian dari user
  final TextEditingController _controller = TextEditingController();
  // Focus node untuk mengelola keyboard dan focus events
  final FocusNode _queryFocus = FocusNode();

  // === SEARCH SUGGESTIONS ===
  // List contoh pencarian yang akan ditampilkan sebagai suggestion chips
  final List<String> _suggestions = const [
    'berita terbaru hari ini',
    'kabar politik hari ini',
    'hoax terbaru hari ini',
    'informasi bencana alam hari ini',
  ];

  // === RATE LIMITING SYSTEM ===
  // Duration cooldown antara pencarian (5 detik untuk mencegah spam)
  final Duration _cooldown = const Duration(seconds: 5);

  // === SEARCH RESULTS STATE ===
  // List untuk menyimpan hasil pencarian dari API
  List<SearchResult> _results = const [];
  // Boolean untuk menunjukkan status loading saat pencarian sedang berlangsung
  bool _isLoading = false;
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
    // === CLEANUP RESOURCES ===
    // Pastikan semua resource dibersihkan dengan benar untuk mencegah memory leak

    // Hapus scroll listener sebelum dispose
    _scrollController.removeListener(_onScroll);
    // Dispose scroll controller
    _scrollController.dispose();

    // Dispose text controllers dan focus nodes
    _controller.dispose();
    _queryFocus.dispose();

    // Cancel timer jika masih aktif
    _cooldownTimer?.cancel();

    // Call parent dispose
    super.dispose();
  }

  void _onScroll() {
    // === FITUR UTAMA: SCROLL BEHAVIOR ===
    // Method ini menangani event scroll untuk mengontrol visibility suggestion panel
    // Ketika user scroll melewati search card, suggestion panel akan disembunyikan
    // untuk memberikan lebih banyak ruang pada hasil pencarian

    // Tinggi search card yang lebih akurat dengan semua padding dan spacing
    // Search card + app bar + top spacing + cooldown indicator = sekitar 250-300px
    final searchCardHeight =
        280.0; // Ditingkatkan dari 120px ke 280px untuk akurasi

    // Update state untuk mengontrol visibility suggestion panel
    // Jika scroll offset < searchCardHeight, maka suggestion tetap visible
    // Jika scroll offset >= searchCardHeight, maka suggestion akan hidden
    setState(() {
      _showSuggestions = _scrollController.offset < searchCardHeight;
    });
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
      final results = await widget.api.search(query, limit: 20);

      // Safety check lagi setelah await
      if (mounted) {
        // Update state dengan hasil pencarian
        setState(() {
          _results = results; // Set hasil pencarian
          _isLoading = false; // Matikan loading indicator
        });
      }
    } catch (e) {
      // === ERROR HANDLING ===
      // Tangani error yang terjadi selama proses pencarian
      if (mounted) {
        setState(() {
          _error = e.toString(); // Simpan error message
          _isLoading = false; // Matikan loading indicator
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
      // Clean header seperti Spotify
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

                  // === CONDITIONAL SUGGESTION PANEL ===
                  // Hanya tampilkan suggestion panel jika:
                  // 1. _showSuggestions = true (berdasarkan scroll position)
                  // 2. Belum ada hasil pencarian (_results.isEmpty)
                  // 3. Tidak ada error aktif
                  // Fitur ini memberikan UX yang lebih baik dengan scroll behavior
                  if (_showSuggestions && _results.isEmpty && _error == null)
                    _SuggestionPanel(
                      suggestions: _suggestions,
                      onTapSuggestion: (value) {
                        // Auto-fill search box dengan suggestion yang dipilih
                        _controller
                          ..text = value
                          ..selection = TextSelection.collapsed(
                            offset: value.length,
                          );
                        // Langsung lakukan pencarian
                        _performSearchWithLimit();
                      },
                    ),

                  // === ERROR BANNER ===
                  // Tampilkan error message jika terjadi kesalahan
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    ErrorBanner(message: _error!),
                  ],

                  // === SPACING ===
                  const SizedBox(height: 12),

                  // === MAIN CONTENT AREA ===
                  Expanded(
                    child: AnimatedSwitcher(
                      // === ANIMATED CONTENT SWITCHER ===
                      // Memberikan smooth transition antara loading, empty, dan results state
                      duration: const Duration(milliseconds: 250),

                      // === CONDITIONAL CONTENT ===
                      child: _isLoading
                          // Loading state dengan spinner dan text
                          ? const _LoadingState()
                          // Empty state ketika belum ada hasil pencarian
                          : _results.isEmpty
                          ? const _EmptyState()
                          // Results list dengan semua hasil pencarian
                          : _ResultsList(
                              results: _results,
                              onOpen: _openResult,
                              onCopy: _copyLink,
                            ),
                    ),
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

// === SUGGESTION PANEL WIDGET ===
// Widget stateless yang membungkus suggestion chips dalam container dengan styling
// Menampilkan koleksi suggestion chips dalam card dengan gradient background
class _SuggestionPanel extends StatelessWidget {
  const _SuggestionPanel({
    required this.suggestions,
    required this.onTapSuggestion,
  });

  final List<String> suggestions;
  final ValueChanged<String> onTapSuggestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: _SuggestionChips(
          suggestions: suggestions,
          onSelected: onTapSuggestion,
        ),
      ),
    );
  }
}

// === SUGGESTION CHIPS CONTAINER ===
// Widget yang mengatur layout dan styling untuk multiple suggestion chips
// Menggunakan Column layout dengan title dan Wrap untuk chips arrangement
class _SuggestionChips extends StatelessWidget {
  const _SuggestionChips({required this.suggestions, required this.onSelected});

  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contoh pencarian',
          style: theme.textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 18,
          runSpacing: 14,
          children: suggestions
              .mapIndexed(
                (index, text) => _AnimatedSuggestionChip(
                  label: text,
                  icon: Icons.newspaper, // Simplified icon selection
                  background:
                      AppTheme.primaryGradient, // Simplified gradient selection
                  onTap: () => onSelected(text),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// === ANIMATED SUGGESTION CHIP ===
// Individual suggestion chip dengan hover animation dan gradient background
// Menggunakan StatefulWidget untuk menangani hover state dan animasi
class _AnimatedSuggestionChip extends StatefulWidget {
  const _AnimatedSuggestionChip({
    required this.label,
    required this.icon,
    required this.background,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final LinearGradient background;
  final VoidCallback onTap;

  @override
  State<_AnimatedSuggestionChip> createState() =>
      _AnimatedSuggestionChipState();
}

// === ANIMATED SUGGESTION CHIP STATE ===
// State management untuk animated suggestion chip dengan hover effects
class _AnimatedSuggestionChipState extends State<_AnimatedSuggestionChip>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = widget.background;
    final hoveredGradient = LinearGradient(
      colors: gradient.colors
          .map(
            (color) =>
                Color.alphaBlend(Colors.black.withValues(alpha: 0.12), color),
          )
          .toList(),
      begin: gradient.begin,
      end: gradient.end,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: _hovered ? hoveredGradient : gradient,
          borderRadius: BorderRadius.circular(22),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

  Color _getCredibilityColor(int score) {
    if (score >= 80) return const Color(0xFF10B981);
    if (score >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  IconData _getCredibilityIcon(int score) {
    if (score >= 80) return Icons.verified;
    if (score >= 60) return Icons.info;
    return Icons.warning;
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
                                color: AppTheme.subduedGray,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.public,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    result.displayLink,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // === SPACING BETWEEN BADGES ===
                          const SizedBox(width: 12),

                          // === CREDIBILITY BADGE ===
                          // Badge yang menunjukkan tingkat kredibilitas artikel
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getCredibilityColor(
                                result.credibilityScore ?? 85,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getCredibilityColor(
                                  result.credibilityScore ?? 85,
                                ).withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getCredibilityIcon(
                                    result.credibilityScore ?? 85,
                                  ),
                                  size: 14,
                                  color: _getCredibilityColor(
                                    result.credibilityScore ?? 85,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Terpercaya',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: _getCredibilityColor(
                                      result.credibilityScore ?? 85,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
