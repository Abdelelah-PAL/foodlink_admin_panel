class Feature {
  String? documentId;
  String arImageURL;
  String enImageURL;
  bool active;
  bool premium;
  String keyword;

  Feature(
      {this.documentId,
      required this.arImageURL,
      required this.enImageURL,
      required this.active,
      required this.premium,
      required this.keyword});

  factory Feature.fromJson(Map<String, dynamic> json, docId) {
    return Feature(
        documentId: docId,
        arImageURL: json['ar_image_url'],
        enImageURL: json['en_image_url'],
        active: json['active'],
        premium: json['premium'],
        keyword: json['keyword']);
  }

  Map<String, dynamic> toMap() {
    return {
      'ar_image_url': arImageURL,
      'en_image_url': enImageURL,
      'active': active,
      'premium': premium,
      'keyword': keyword
    };
  }
}
