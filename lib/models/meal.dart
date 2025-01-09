class Meal {
  String? documentId;
  int? categoryId;
  String name;
  String? imageUrl;
  List<String> ingredients;
  String? recipe;
  DateTime? date;
  String? day;
  bool isPlanned ;

  Meal({
    this.documentId,
    this.categoryId,
    required this.name,
    this.imageUrl,
    required this.ingredients,
    this.recipe,
    this.date,
    this.day,
    this.isPlanned =true
  });

  factory Meal.fromJson(Map<String, dynamic> json, docId) {
    return Meal(
      documentId: docId,
      categoryId: json['category_id'],
      name: json['name'],
      imageUrl: json['image_url'],
      ingredients: List<String>.from(json['ingredients']),
      recipe: json['recipe'],
      date: json['date'].toDate(),
      day: json['day'],
      isPlanned: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'name': name,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'recipe': recipe,
      'date': date,
      'day': day,
      'is_planned':true,
    };
  }
}
