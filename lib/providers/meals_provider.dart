import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controllers/meal_controller.dart';
import '../models/meal.dart';
import '../services/meals_services.dart';
import 'storage_provider.dart';

class MealsProvider with ChangeNotifier {
  static final MealsProvider _instance = MealsProvider._internal();

  factory MealsProvider() => _instance;

  MealsProvider._internal();

  List<Meal> meals = [];
  List<Meal> favoriteMeals = [];
  final MealsServices _ms = MealsServices();
  bool isLoading = false;
  int numberOfIngredients = 2;
  int numberOfSteps = 2;
  DateTime? selectedDate;
  String? day;

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
            source: doc.source);
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


  void resetValues(StorageProvider storageProvider) {
    selectedDate = null;
    storageProvider.mealImageIsPicked = false;
    storageProvider.pickedMealImage = null;
    numberOfIngredients = 2;
    numberOfSteps = 2;
    MealController().sourceController.clear();
    MealController().nameController.clear();
    ingredientsControllers = [
      TextEditingController(),
    ];
    stepsControllers = [
      TextEditingController(),
    ];
    ingredientsControllers.map((controller) => {controller.clear()});
    stepsControllers.map((controller) => {controller.clear()});
    notifyListeners();
  }

  void increaseIngredients() {
    numberOfIngredients++;
    ingredientsControllers.add(TextEditingController());
    notifyListeners();
  }

  void fillDataForEdition(meal) {
    MealController().nameController.text = meal.name;
    MealController().sourceController.text = meal.source ?? "";
    selectedDate = meal.date;
    day = getDayOfWeek(meal.date);
    numberOfIngredients = meal.ingredients.length + 1;
    meal.ingredients.asMap().forEach((index, controller) {
      if (index + 1 > ingredientsControllers.length) {
        ingredientsControllers.add(TextEditingController());
      }
      ingredientsControllers[index].text = meal.ingredients[index];
    });
    numberOfSteps = meal.recipe.length + 1;
    meal.recipe.asMap().forEach((index, controller) {
      if (index + 1 > stepsControllers.length) {
        stepsControllers.add(TextEditingController());
      }
      stepsControllers[index].text = meal.recipe[index];
    });
    notifyListeners();
  }

  void increaseSteps() {
    numberOfSteps++;
    stepsControllers.add(TextEditingController());
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      day = getDayOfWeek(selectedDate!);
    }
    notifyListeners();
  }

  String getDayOfWeek(DateTime date) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return days[date.weekday - 1];
  }
}
