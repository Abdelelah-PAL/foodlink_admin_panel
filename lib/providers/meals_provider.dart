import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  List<bool> checkboxValues = [];

  bool isIngredientChecked = false;

  Future<Meal> addMeal(Meal meal) async {
    var addedMeal = await _ms.addMeal(meal);
    return addedMeal;
  }

  Future<Meal> updateMeal(Meal meal) async {
    Meal updatedMeal = await _ms.updateMeal(meal);
    return updatedMeal;
  }

  Future<void> getFavorites(String userId, {bool forceRefresh = false}) async {
    if (isLoading || (!forceRefresh && favoriteMeals.isNotEmpty)) return;
    try {
      isLoading = true;
      favoriteMeals.clear();
      List<Meal> fetchedMeals = await _ms.getFavorites(userId);
      favoriteMeals.addAll(fetchedMeals);
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  void getAllMealsByCategory(userId) async {
    try {
      isLoading = true;
      meals.clear();
      List<Meal> fetchedMeals =
          await _ms.getAllMealsByCategory(userId);
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

  Future<void> pickImageFromSource(BuildContext context) async {
    final picker = ImagePicker();
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Text('Gallery'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );

    XFile? file = await picker.pickImage(source: source!);

    if (file != null) {
      pickedFile = XFile(file.path);
      imageIsPicked = true;
    }
    notifyListeners();
  }

  Future<String> uploadImage(image) async {
    String? downloadUrl = await _ms.uploadImage(image);
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
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
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

  void toggleCheckedIngredient(value, listIndex) {
    checkboxValues[listIndex] = value;
    notifyListeners();
  }
}
