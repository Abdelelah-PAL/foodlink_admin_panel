import 'package:flutter/material.dart';
import '../controllers/meal_controller.dart';
import '../controllers/meal_types.dart';
import '../models/meal.dart';
import '../services/meals_services.dart';
import 'storage_provider.dart';

class MealsProvider with ChangeNotifier {
  static final MealsProvider _instance = MealsProvider._internal();

  factory MealsProvider() => _instance;

  MealsProvider._internal();

  List<Meal> plannedMeals = [];
  List<Meal> suggestions = [];
  List<Meal> suggestionsToAdd = [];
  List<String?> suggestionMealTypes = [];

  final MealsServices _ms = MealsServices();
  bool isLoading = false;
  int numberOfPlannedMealIngredients = 2;
  int numberOfPlannedMealSteps = 2;
  int numberOfSuggestionsToAdd = 2;
  DateTime? selectedDate;
  String? day;
  List<TextEditingController> suggestionMealNameControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> suggestionMealIngredientsControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> suggestionMealRecipeControllers = [
    TextEditingController(),
  ];

  List<TextEditingController> ingredientsControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> stepsControllers = [
    TextEditingController(),
  ];

  void getAllPlannedMeals() async {
    try {
      isLoading = true;
      plannedMeals.clear();
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
            source: doc.source,
            typeId: MealTypes.plannedMeal);
        plannedMeals.add(meal);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  Future<Meal> addPlannedMeal(Meal meal) async {
    var addedMeal = await _ms.addPlannedMeal(meal);
    return addedMeal;
  }

  Future<Meal> updatePlannedMeal(Meal meal) async {
    Meal updatedMeal = await _ms.updatePlannedMeal(meal);
    return updatedMeal;
  }

  Future<void> deletePlannedMeal(String docId) async {
    await _ms.deletePlannedMeal(docId);
  }

  Future<List<Meal>> addSuggestedMeals(StorageProvider storageProvider) async {
    var addedMeals = await _ms.addSuggestedMeals(suggestions, storageProvider);
    return addedMeals;
  }

  void resetValues(StorageProvider storageProvider) {
    selectedDate = null;
    storageProvider.mealImageIsPicked = false;
    storageProvider.pickedMealImage = null;
    numberOfPlannedMealIngredients = 2;
    numberOfPlannedMealSteps = 2;
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
    numberOfPlannedMealIngredients++;
    ingredientsControllers.add(TextEditingController());
    notifyListeners();
  }

  void fillDataForEdition(plannedMeal) {
    MealController().nameController.text = plannedMeal.name;
    MealController().sourceController.text = plannedMeal.source ?? "";
    selectedDate = plannedMeal.date;
    day = getDayOfWeek(plannedMeal.date);
    numberOfPlannedMealIngredients = plannedMeal.ingredients.length + 1;
    plannedMeal.ingredients.asMap().forEach((index, controller) {
      if (index + 1 > ingredientsControllers.length) {
        ingredientsControllers.add(TextEditingController());
      }
      ingredientsControllers[index].text = plannedMeal.ingredients[index];
    });
    numberOfPlannedMealSteps = plannedMeal.recipe.length + 1;
    plannedMeal.recipe.asMap().forEach((index, controller) {
      if (index + 1 > stepsControllers.length) {
        stepsControllers.add(TextEditingController());
      }
      stepsControllers[index].text = plannedMeal.recipe[index];
    });
    notifyListeners();
  }

  void increaseSteps() {
    numberOfPlannedMealSteps++;
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

  void increaseSuggestions(StorageProvider storageProvider) {
    numberOfSuggestionsToAdd++;
    suggestionMealNameControllers.add(TextEditingController());
    suggestionMealTypes.add(null);
    storageProvider.suggestionsPickedImages.add(null);
    storageProvider.suggestionsImagesArePicked.add(false);
    notifyListeners();
  }

  void addSuggestedMeal(Meal meal) {
    suggestions.add(meal);
    notifyListeners();
  }

  void removeSuggestedMeal(int index) {
    if (index >= 0 && index < suggestionsToAdd.length) {
      suggestionsToAdd.removeAt(index);
      suggestionMealNameControllers.removeAt(index);
      suggestionMealIngredientsControllers.removeAt(index);
      suggestionMealRecipeControllers.removeAt(index);
      suggestionMealTypes.removeAt(index);
      notifyListeners();
    }
  }
}
