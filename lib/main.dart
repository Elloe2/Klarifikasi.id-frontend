import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/search_history_entry.dart';
import 'models/search_result.dart';
import 'services/search_api.dart';

final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier(ThemeMode.system);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Hoax Checker',
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF1B5EFA)),
            scaffoldBackgroundColor: const Color(0xFFF4F6FB),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF90CAF9),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: mode,
          home: const HomeShell(),
        );
      },
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  final SearchApi _api = const SearchApi();

  @override
  Widget build(BuildContext context) {
    final pages = [
      SearchPage(api: _api),
      HistoryPage(api: _api),
      const SettingsPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Cari',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.api});

  final SearchApi api;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _queryFocus = FocusNode();
  final List<String> _suggestions = const [
    'hoax vaksin terbaru',
    'klarifikasi berita gempa',
    'fact check politik',
    'penipuan bantuan sosial',
  ];
  final Duration _cooldown = const Duration(seconds: 5);

  List<SearchResult> _results = const [];
  bool _isLoading = false;
  String? _error;
  DateTime? _lastSearchTime;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _controller.dispose();
    _queryFocus.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final last = _lastSearchTime;
      if (last == null) {
        timer.cancel();
        return;
      }

      final diff = DateTime.now().difference(last);
      final remaining = _cooldown - diff;
      if (remaining.isNegative) {
        setState(() {});
        timer.cancel();
      } else {
        setState(() {});
      }
    });
  }

  Duration? _checkCooldown() {
    if (_lastSearchTime == null) return null;
    final diff = DateTime.now().difference(_lastSearchTime!);
    final remaining = _cooldown - diff;
    if (remaining.isNegative) {
      return null;
    }
    return remaining;
  }

  Future<void> _performSearch() async {
    final query = _controller.text.trim();

    if (query.length < 3) {
      setState(() {
        _error = 'Masukkan kata kunci minimal 3 karakter.';
      });
      return;
    }

    final remaining = _checkCooldown();
    if (remaining != null) {
      _showSnackBar(
        'Harap tunggu ${remaining.inSeconds} detik sebelum mencari lagi.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await widget.api.search(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _lastSearchTime = DateTime.now();
      });
      _startCooldownTimer();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _results = const [];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openResult(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showSnackBar('URL tidak valid.');
      return;
    }

    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!success) {
      _showSnackBar('Tidak dapat membuka tautan.');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onCooldown = _checkCooldown();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoax Checker',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Telusuri & bandingkan informasi secara cepat',
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SearchCard(
              controller: _controller,
              focusNode: _queryFocus,
              isLoading: _isLoading,
              onSearch: _performSearch,
            ),
            if (onCooldown != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Batas pencarian tercapai. Tunggu ${onCooldown.inSeconds} detik.',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: ((
                                _cooldown.inMilliseconds -
                                onCooldown.inMilliseconds) /
                              _cooldown.inMilliseconds)
                          .clamp(0.0, 1.0),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            _SuggestionChips(
              suggestions: _suggestions,
              onSelected: (value) {
                _controller
                  ..text = value
                  ..selection =
                      TextSelection.collapsed(offset: value.length);
                _performSearch();
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              _ErrorBanner(message: _error!),
            ],
            const SizedBox(height: 12),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _isLoading
                    ? const _LoadingState()
                    : _results.isEmpty
                        ? const _EmptyState()
                        : _ResultsList(
                            results: _results,
                            onOpen: _openResult,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.api});

  final SearchApi api;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<SearchHistoryEntry>> _futureHistory;

  @override
  void initState() {
    super.initState();
    _futureHistory = widget.api.fetchHistory();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureHistory = widget.api.fetchHistory();
    });
    await _futureHistory;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pencarian'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: () => _refresh(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<SearchHistoryEntry>>(
          future: _futureHistory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: _ErrorBanner(
                  message: 'Gagal memuat riwayat: ${snapshot.error}',
                ),
              );
            }

            final histories = snapshot.data ?? [];
            if (histories.isEmpty) {
              return const Center(
                child: Text('Belum ada riwayat pencarian.'),
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                itemCount: histories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final history = histories[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: history.topThumbnail != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                history.topThumbnail!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.history),
                      title: Text(history.query),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (history.topTitle != null)
                            Text(
                              history.topTitle!,
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            'Total hasil: ${history.resultsCount}',
                            style: theme.textTheme.labelSmall,
                          ),
                          Text(
                            history.createdAtLabel,
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: history.topLink == null
                          ? null
                          : () async {
                              final uri = Uri.tryParse(history.topLink!);
                              if (uri != null) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Mode Tampilan',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, mode, _) {
              return SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: Icon(Icons.auto_mode),
                    label: Text('Sistem'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: Icon(Icons.light_mode),
                    label: Text('Terang'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: Icon(Icons.dark_mode),
                    label: Text('Gelap'),
                  ),
                ],
                selected: {mode},
                onSelectionChanged: (selection) {
                  if (selection.isNotEmpty) {
                    themeModeNotifier.value = selection.first;
                  }
                },
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Tentang Aplikasi',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: const Text('Versi 0.1.0'),
            subtitle: const Text(
              'Aplikasi pencarian hoaks dengan integrasi Google Custom Search.',
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.onSearch,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLoading;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan kata kunci yang ingin diperiksa',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              focusNode: focusNode,
              onSubmitted: (_) => onSearch(),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Contoh: klaim vaksin terbaru',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isLoading ? null : onSearch,
                icon: const Icon(Icons.manage_search),
                label: const Text('Cari Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChips extends StatelessWidget {
  const _SuggestionChips({
    required this.suggestions,
    required this.onSelected,
  });

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
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions
              .map(
                (text) => ActionChip(
                  avatar: const Icon(Icons.flash_on, size: 18),
                  label: Text(text),
                  onPressed: () => onSelected(text),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Sedang menelusuri sumber terpercaya...'),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_rounded,
          size: 64,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        Text(
          'Mulai dengan mencari klaim atau berita tertentu.',
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih salah satu contoh pencarian di atas untuk melihat bagaimana sistem bekerja.',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({
    required this.results,
    required this.onOpen,
  });

  final List<SearchResult> results;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: ValueKey(results.length),
      padding: const EdgeInsets.only(bottom: 8),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final result = results[index];
        return _ResultCard(
          result: result,
          onOpen: onOpen,
        );
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.result,
    required this.onOpen,
  });

  final SearchResult result;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (result.thumbnail != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      result.thumbnail!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                    ),
                  )
                else
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.article_outlined),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (result.displayLink.isNotEmpty)
                        Text(
                          result.displayLink,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        result.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (result.snippet.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          result.snippet,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: result.link.isEmpty
                      ? null
                      : () => onOpen(result.link),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Buka sumber'),
                ),
                const SizedBox(width: 8),
                if (result.formattedUrl.isNotEmpty)
                  Expanded(
                    child: Text(
                      result.formattedUrl,
                      style: theme.textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
