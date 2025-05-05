class OnBoardingContent {
  String imageURL;
  String firstTextSpan;
  String secondTextSpan;
  String? thirdTextSpan;

  OnBoardingContent(
      {required this.imageURL,
      required this.firstTextSpan,
      required this.secondTextSpan,
      this.thirdTextSpan});

  factory OnBoardingContent.fromJson(Map<String, dynamic> json) {
    return OnBoardingContent(
      imageURL: json['image_url'],
      firstTextSpan: json['first_text_span'],
      secondTextSpan: json['second_text_span'],
      thirdTextSpan: json['third_text_span'],
    );
  }
}
