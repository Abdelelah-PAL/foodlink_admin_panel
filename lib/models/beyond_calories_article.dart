class BeyondCaloriesArticle {
  String? documentId;
  String imageUrl;
  String url;

  BeyondCaloriesArticle({
    this.documentId,
    required this.imageUrl,
    required this.url,
  });

  factory BeyondCaloriesArticle.fromJson(Map<String, dynamic> json, docId) {
    return BeyondCaloriesArticle(
      documentId: docId,
      imageUrl: json['image_url'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image_url': imageUrl,
      'url': url,
    };
  }
}
