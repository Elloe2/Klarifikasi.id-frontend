import 'package:intl/intl.dart';

/// Representasi satu catatan riwayat pencarian yang dikembalikan backend.
class SearchHistoryEntry {
  const SearchHistoryEntry({
    required this.id,
    required this.query,
    required this.resultsCount,
    this.topTitle,
    this.topLink,
    this.topThumbnail,
    required this.createdAt,
  });

  final int id;
  final String query;
  final int resultsCount;
  final String? topTitle;
  final String? topLink;
  final String? topThumbnail;
  final DateTime createdAt;

  /// Factory helper untuk mengubah payload JSON menjadi instance model.
  factory SearchHistoryEntry.fromJson(Map<String, dynamic> json) {
    return SearchHistoryEntry(
      id: json['id'] as int,
      query: json['query'] as String? ?? '',
      resultsCount: json['results_count'] as int? ?? 0,
      topTitle: json['top_title'] as String?,
      topLink: json['top_link'] as String?,
      topThumbnail: json['top_thumbnail'] as String?,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// Menformat waktu pencarian menjadi string yang ramah pengguna.
  String get createdAtLabel {
    final formatter = DateFormat('dd MMM yyyy • HH:mm');
    return formatter.format(createdAt);
  }
}
