class Meal {
  String? documentId;
  int? categoryId;
  String name;
  String? imageUrl;
  List<String> ingredients;
  List<String>? recipe;
  String? userId;
  bool? isFavorite;
  DateTime? date;
  String? day;
  String? source;
  int typeId;


  Meal({
    this.documentId,
    this.categoryId,
    required this.name,
    this.imageUrl,
    required this.ingredients,
    this.recipe,
    this.userId,
    this.isFavorite = false,
    this.date,
    this.day,
    this.source,
    required this.typeId,
  });

  factory Meal.fromJson(Map<String, dynamic> json, docId) {
    return Meal(
      documentId: docId,
      categoryId: json['category_id'],
      name: json['name'],
      imageUrl: json['image_url'],
      ingredients: List<String>.from(json['ingredients']),
      recipe: List<String>.from(json['recipe']),
      userId: json['user_id'],
      isFavorite: json['is_favorite'],
      date: json['date']?.toDate(),
      day: json['day'],
      source: json['source'],
      typeId: json['type_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'name': name,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'recipe': recipe,
      'user_id': userId,
      'is_favorite': isFavorite,
      'date': date,
      'day': day,
      'source': source,
      'type_id': typeId
    };
  }
}
