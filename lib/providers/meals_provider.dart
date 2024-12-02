import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
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
  XFile? pickedFile;
  int numberOfIngredients = 2;
  List<TextEditingController> ingredientsControllers = [
    TextEditingController(),
  ];


  void getAllPlannedMeals() async {
    try {
      isLoading = true;
      meals.clear();
      List<Meal> fetchedMeals =
      await _ms.getAllPlannedMeals();
      for (var doc in fetchedMeals) {
        Meal meal = Meal(
            documentId: doc.documentId,
            name: doc.name,
            imageUrl: doc.imageUrl,
            categoryId: doc.categoryId,
            ingredients: doc.ingredients,
            recipe: doc.recipe,
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

  Future<void> pickImage() async {
    try {
      final file = await ImagePickerWeb.getImageAsBytes();
      if (file != null) {
        pickedFile = XFile.fromData(file);
        imageIsPicked = true;
      }
      notifyListeners();
    } catch (e) {
      print("Error picking image: $e");
      rethrow;
    }
  }

  Future<String> uploadImage(image, source) async {
    String? downloadUrl = await _ms.uploadImage(image, source);
    return downloadUrl!;
  }

  void resetValues() {
    imageIsPicked = false;
    pickedFile = null;
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

}
