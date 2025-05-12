import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controllers/meal_controller.dart';
import '../models/meal.dart';
import '../services/meals_services.dart';

class MealsProvider with ChangeNotifier {
  static final MealsProvider _instance = MealsProvider._internal();

  factory MealsProvider() => _instance;

  MealsProvider._internal();

  List<Meal> meals = [];
  List<Meal> favoriteMeals = [];
  final MealsServices _ms = MealsServices();
  bool isLoading = false;
  bool imageIsPicked = false;
  bool dOWIsPicked = false;
  FilePickerResult? pickedFile;
  FilePickerResult? pickedDOW;
  int numberOfIngredients = 2;
  int numberOfSteps = 2;
  List<TextEditingController> ingredientsControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> stepsControllers = [
    TextEditingController(),
  ];

  void getAllPlannedMeals() async {
    try {
      isLoading = true;
      meals.clear();
      List<Meal> fetchedMeals = await _ms.getAllPlannedMeals();
      for (var doc in fetchedMeals) {
        Meal meal = Meal(
          documentId: doc.documentId,
          name: doc.name,
          imageUrl: doc.imageUrl,
          categoryId: doc.categoryId,
          ingredients: doc.ingredients,
          recipe: doc.recipe,
          date: doc.date,
          day: doc.day,
        );
        meals.add(meal);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  Future<Meal> addMeal(Meal meal) async {
    var addedMeal = await _ms.addMeal(meal);
    return addedMeal;
  }

  Future<Meal> updateMeal(Meal meal) async {
    Meal updatedMeal = await _ms.updateMeal(meal);
    return updatedMeal;
  }

  Future<void> deleteMeal(String docId) async {
    await _ms.deleteMeal(docId);
  }

  Future<void> pickImage(String source) async {
    try {
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (file != null) {
        if (source == "meal") {
          pickedFile = file;
          imageIsPicked = true;
        } else if (source == "DOW") {
          pickedDOW = file;
          dOWIsPicked = true;
        }
      }
      notifyListeners();
    } catch (e) {
      print("Error picking image: $e");
      rethrow;
    }
  }

  Future<String?> uploadImage(FilePickerResult path, String tag) async {
    return _ms.uploadImage(path, tag);
  }

  Future<void> saveImageMetadata(String imageUrl, double dx, double dy,
      double width, double height) async {
    _ms.saveImageMetadata(
        imageUrl: imageUrl, dx: dx, dy: dy, width: width, height: height);
  }

  void resetValues() {
    imageIsPicked = false;
    dOWIsPicked = false;
    pickedFile = null;
    pickedDOW = null;
    numberOfIngredients = 2;
    MealController().recipeController.clear();
    MealController().ingredientsController.clear();
    MealController().nameController.clear();
    ingredientsControllers = [
      TextEditingController(),
    ];
    ingredientsControllers.map((controller) => {controller.clear()});
    notifyListeners();
  }

  void increaseIngredients() {
    numberOfIngredients++;
    ingredientsControllers.add(TextEditingController());
    notifyListeners();
  }

  void fillDataForEdition(meal) {
    MealController().nameController.text = meal.name;
    MealController().recipeController.text = meal.recipe ?? "";
    numberOfIngredients = meal.ingredients.length + 1;
    meal.ingredients.asMap().forEach((index, controller) {
      if (index + 1 > ingredientsControllers.length) {
        ingredientsControllers.add(TextEditingController());
      }
      ingredientsControllers[index].text = meal.ingredients[index];
    });
    notifyListeners();
  }

  void increaseSteps() {
    numberOfSteps++;
    stepsControllers.add(TextEditingController());
    notifyListeners();
  }
}
