class Meal {
  String? documentId;
  int? categoryId;
  String name;
  String? imageUrl;
  List<String> ingredients;
  String? recipe;

  Meal(
      {this.documentId,
      this.categoryId,
      required this.name,
      this.imageUrl,
      required this.ingredients,
      this.recipe,});

  factory Meal.fromJson(Map<String, dynamic> json, docId) {
    return Meal(
        documentId: docId,
        categoryId: json['category_id'],
        name: json['name'],
        imageUrl: json['image_url'],
        ingredients: List<String>.from(json['ingredients']),
        recipe: json['recipe'],
     );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'name': name,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'recipe': recipe,
    };
  }
}
