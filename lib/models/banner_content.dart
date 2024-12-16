class BannerContent {
  final String content;

  BannerContent({required this.content});

  factory BannerContent.fromJson(Map<String, dynamic> json) {
    return BannerContent(content: json['content']);
  }
}