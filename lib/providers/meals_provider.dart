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
  List<Meal> suggestionsToAdd = [
    Meal(
        name: "",
        imageUrl: "",
        ingredients: [],
        recipe: [],
        categoryId: 0,
        typeId: MealTypes.suggestedMeal)
  ];

  final MealsServices _ms = MealsServices();
  int suggestedMealCategoryId = 0;
  bool isLoading = false;
  int numberOfPlannedMealIngredients = 2;
  int numberOfPlannedMealSteps = 2;
  int numberOfEditedSuggestedMealIngredients = 2;
  int numberOfEditedSuggestedMealSteps = 2;
  int numberOfSuggestionsToAdd = 2;
  DateTime? selectedDate;
  String? day;
  List<TextEditingController> addedSuggestedMealNameControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> addedSuggestedMealIngredientsControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> addedSuggestedMealRecipeControllers = [
    TextEditingController(),
  ];

  List<TextEditingController> plannedMealIngredientsControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> plannedMealStepsControllers = [
    TextEditingController(),
  ];

  List<TextEditingController> editedSuggestedMealIngredientsControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> editedSuggestedMealStepsControllers = [
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

  Future<void> getAllSuggestedMeals() async {
    try {
      isLoading = true;
      suggestions.clear();
      List<Meal> fetchedMeals = await _ms.getAllSuggestedMeals();
      for (var doc in fetchedMeals) {
        Meal meal = Meal(
            documentId: doc.documentId,
            name: doc.name,
            imageUrl: doc.imageUrl,
            categoryId: doc.categoryId,
            ingredients: doc.ingredients,
            recipe: doc.recipe,
            typeId: MealTypes.suggestedMeal);
        suggestions.add(meal);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  Future<List<Meal>> addSuggestedMeals(StorageProvider storageProvider) async {
    var addedMeals = await _ms.addSuggestedMeals(suggestionsToAdd, storageProvider);
    return addedMeals;
  }

  Future<Meal> updateSuggestedMeal(Meal meal) async {
    Meal updatedMeal = await _ms.updateSuggestedMeal(meal);
    return updatedMeal;
  }

  Future<void> deleteSuggestedMeal(String docId) async {
    await _ms.deletePlannedMeal(docId);
  }

  Future<void> deleteImage(imageUrl) async {
    await _ms.deleteImage(imageUrl);
  }

  void resetPlannedMealValues(StorageProvider storageProvider) {
    selectedDate = null;
    storageProvider.mealImageIsPicked = false;
    storageProvider.pickedMealImage = null;
    numberOfPlannedMealIngredients = 2;
    numberOfPlannedMealSteps = 2;
    MealController().sourceController.clear();
    MealController().plannedMealNameController.clear();
    plannedMealIngredientsControllers = [
      TextEditingController(),
    ];
    plannedMealStepsControllers = [
      TextEditingController(),
    ];
    plannedMealIngredientsControllers.map((controller) => {controller.clear()});
    plannedMealStepsControllers.map((controller) => {controller.clear()});
    notifyListeners();
  }

  void resetSuggestedMealValues(StorageProvider storageProvider) {
    storageProvider.mealImageIsPicked = false;
    storageProvider.pickedMealImage = null;
    numberOfEditedSuggestedMealIngredients = 2;
    numberOfEditedSuggestedMealSteps = 2;
    MealController().suggestedMealNameController.clear();
    editedSuggestedMealIngredientsControllers = [
      TextEditingController(),
    ];
    editedSuggestedMealStepsControllers = [
      TextEditingController(),
    ];
    editedSuggestedMealIngredientsControllers.map((controller) => {controller.clear()});
    editedSuggestedMealStepsControllers.map((controller) => {controller.clear()});
    notifyListeners();
  }


  void increasePlannedMealIngredients() {
    numberOfPlannedMealIngredients++;
    plannedMealIngredientsControllers.add(TextEditingController());
    notifyListeners();
  }

  void increaseSuggestedMealIngredients() {
    numberOfEditedSuggestedMealIngredients++;
    editedSuggestedMealIngredientsControllers.add(TextEditingController());
    notifyListeners();
  }
  void increaseSuggestedMealSteps() {
    numberOfEditedSuggestedMealSteps++;
    editedSuggestedMealStepsControllers.add(TextEditingController());
    notifyListeners();
  }

  void fillDataForEditionPlannedMeal(plannedMeal) {
    MealController().plannedMealNameController.text = plannedMeal.name;
    MealController().sourceController.text = plannedMeal.source ?? "";
    selectedDate = plannedMeal.date;
    day = getDayOfWeek(plannedMeal.date);
    numberOfPlannedMealIngredients = plannedMeal.ingredients.length + 1;
    plannedMeal.ingredients.asMap().forEach((index, controller) {
      if (index + 1 > plannedMealIngredientsControllers.length) {
        plannedMealIngredientsControllers.add(TextEditingController());
      }
      plannedMealIngredientsControllers[index].text = plannedMeal.ingredients[index];
    });
    numberOfPlannedMealSteps = plannedMeal.recipe.length + 1;
    plannedMeal.recipe.asMap().forEach((index, controller) {
      if (index + 1 > plannedMealStepsControllers.length) {
        plannedMealStepsControllers.add(TextEditingController());
      }
      plannedMealStepsControllers[index].text = plannedMeal.recipe[index];
    });
    notifyListeners();
  }

  void fillDataForEditionSuggestedMeal(Meal suggestedMeal) {
    MealController().suggestedMealNameController.text = suggestedMeal.name;
    numberOfEditedSuggestedMealIngredients = suggestedMeal.ingredients.length + 1;
    suggestedMeal.ingredients.asMap().forEach((index, controller) {
      if (index + 1 > addedSuggestedMealIngredientsControllers.length) {
        editedSuggestedMealIngredientsControllers.add(TextEditingController());
      }
      editedSuggestedMealIngredientsControllers[index].text = suggestedMeal.ingredients[index];
    });
    numberOfEditedSuggestedMealSteps = suggestedMeal.recipe!.length + 1;
    suggestedMeal.recipe!.asMap().forEach((index, controller) {
      if (index + 1 > addedSuggestedMealRecipeControllers.length) {
        editedSuggestedMealStepsControllers.add(TextEditingController());
      }
      editedSuggestedMealStepsControllers[index].text = suggestedMeal.recipe![index];
    });
    suggestedMealCategoryId = suggestedMeal.categoryId!;
    notifyListeners();
  }

  void increaseSteps() {
    numberOfPlannedMealSteps++;
    plannedMealStepsControllers.add(TextEditingController());
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
    suggestionsToAdd.add(Meal(
        name: "",
        imageUrl: "",
        ingredients: [],
        recipe: [],
        categoryId: 0,
        typeId: MealTypes.suggestedMeal));
    addedSuggestedMealNameControllers.add(TextEditingController());
    storageProvider.suggestionsPickedImages.add(null);
    storageProvider.suggestionsImagesArePicked.add(false);
    notifyListeners();
  }

  void addSuggestedMeal(Meal meal) {
    suggestionsToAdd.add(meal);
    notifyListeners();
  }

  void removeSuggestedMeal(int index) {

    if (index >= 0 && index < suggestionsToAdd.length) {
      suggestionsToAdd.removeAt(index);
      addedSuggestedMealNameControllers.removeAt(index);
      notifyListeners();
    }
  }

  void changeSuggestedMealCategoryId(int categoryId) {
    suggestedMealCategoryId = categoryId;
    notifyListeners();
  }
}
