class SearchResult {
  const SearchResult({
    required this.title,
    required this.snippet,
    required this.link,
    required this.displayLink,
    required this.formattedUrl,
    this.thumbnail,
  });

  final String title;
  final String snippet;
  final String link;
  final String displayLink;
  final String formattedUrl;
  final String? thumbnail;

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: json['title'] as String? ?? 'Tanpa judul',
      snippet: json['snippet'] as String? ?? '',
      link: json['link'] as String? ?? '',
      displayLink: json['displayLink'] as String? ?? '',
      formattedUrl: json['formattedUrl'] as String? ?? '',
      thumbnail: json['thumbnail'] as String?,
    );
  }
}
