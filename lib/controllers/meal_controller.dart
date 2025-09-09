import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/utils/size_config.dart';
import '../models/meal.dart';
import '../providers/features_provider.dart';
import '../providers/meals_provider.dart';
import '../providers/storage_provider.dart';
import '../screens/food_screens/meal_screen.dart';
import '../screens/widgets/custom_text.dart';
import '../services/meals_services.dart';
import '../services/translation_services.dart';
import 'meal_types.dart';

class MealController {
  static final MealController _instance = MealController._internal();

  factory MealController() => _instance;

  MealController._internal();

  TextEditingController plannedMealNameController = TextEditingController();
  TextEditingController suggestedMealNameController = TextEditingController();
  TextEditingController sourceController = TextEditingController();

  DateTime? selectedDate;
  String? selectedDay;
  String? day;
  MealsServices ms = MealsServices();
  List<TextEditingController> stepsControllers = [
    TextEditingController(),
  ];
  List<String> missingIngredients = [];
  List<String> ingredients = MealsProvider()
      .plannedMealIngredientsControllers
      .map((controller) => controller.text)
      .where((text) => text.isNotEmpty)
      .toList();
  List<String> steps = MealsProvider()
      .plannedMealStepsControllers
      .map((controller) => controller.text)
      .where((text) => text.isNotEmpty)
      .toList();

  String detectLanguage(String string) {
    String languageCode = 'en';

    final RegExp english = RegExp(r'^[a-zA-Z]+');
    final RegExp arabic = RegExp(r'^[\u0621-\u064A]+');

    if (english.hasMatch(string)) {
      languageCode = 'en';
    } else if (arabic.hasMatch(string)) {
      languageCode = 'ar';
    }
    return languageCode;
  }


  final List<Map<String, dynamic>> categories = [
  {"id": 1, "name": TranslationService().translate("Breakfast")},
  {"id": 2, "name": TranslationService().translate("Lunch")},
  {"id": 3, "name": TranslationService().translate("Dinner")},
  {"id": 4, "name": TranslationService().translate("Sweets")},
  {"id": 5, "name": TranslationService().translate("Snacks")},
  {"id": 6, "name": TranslationService().translate("Drinks")},
  ];

  Future<void> addPlannedMeal(MealsProvider mealsProvider, StorageProvider storageProvider) async {
    String? imageUrl;
    if (storageProvider.mealImageIsPicked) {
      imageUrl = await StorageProvider()
          .uploadFile(storageProvider.pickedMealImage!, "planned_meals_images");
    }
    List<String> ingredients = MealsProvider()
        .plannedMealIngredientsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();
    List<String> steps = MealsProvider()
        .plannedMealStepsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();

    var addedPlannedMeal = await MealsProvider().addPlannedMeal(Meal(
        name: plannedMealNameController.text,
        ingredients: ingredients,
        recipe: steps,
        source: sourceController.text,
        imageUrl: (imageUrl?.isNotEmpty ?? false) ? imageUrl : null,
        day: mealsProvider.day,
        date: mealsProvider.selectedDate,
        typeId: MealTypes.plannedMeal));

    FeaturesProvider().resetArticleValues(storageProvider);
    Get.to(MealScreen(meal: addedPlannedMeal, source: "planned",));
  }

  Future<void> updatePlannedMeal(MealsProvider mealsProvider,StorageProvider storageProvider, Meal meal) async {
    String? imageUrl = '';
    if (storageProvider.mealImageIsPicked) {
      if (meal.imageUrl != null || meal.imageUrl != "") {
        await StorageProvider().deleteImage(meal.imageUrl);
      }
      imageUrl = await StorageProvider()
          .uploadFile(storageProvider.pickedMealImage!, "planned_meals_images");
    }
    List<String> ingredients = MealsProvider()
        .plannedMealIngredientsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();
    List<String> steps = MealsProvider()
        .plannedMealStepsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();
    var updatedPlannedMeal = await MealsProvider().updatePlannedMeal(Meal(
        documentId: meal.documentId,
        name: plannedMealNameController.text,
        ingredients: ingredients,
        recipe: steps,
        source: sourceController.text,
        imageUrl: (imageUrl?.isNotEmpty ?? false) ? imageUrl : null,
        day: mealsProvider.day,
        date: mealsProvider.selectedDate,
        typeId: MealTypes.plannedMeal));

    mealsProvider.resetPlannedMealValues(storageProvider);

    Get.to(MealScreen(meal: updatedPlannedMeal, source: 'planned',));
  }

  Meal findPlannedMealById(meals, id) {
    Meal plannedMeal = meals.firstWhere((meal) => meal.documentId == id);
    return plannedMeal;
  }


  void showSuccessUploadingDialog(BuildContext context, settingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizeConfig.customSizedBox(
            205,
            56,
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: settingsProvider.language == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                children: const [
                  Icon(Icons.check_circle, size: 30, color: Colors.green),
                  CustomText(
                      isCenter: true,
                      text: 'image_uploaded',
                      fontSize: 20,
                      fontWeight: FontWeight.normal)
                ]),
          ),
        );
      },
    );
  }

  void showFailedAddDialog(BuildContext context, settingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizeConfig.customSizedBox(
            350,
            56,
            Row(
                textDirection: settingsProvider.language == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.error, size: 30, color: Colors.green),
                  CustomText(
                      isCenter: true,
                      text: 'fill_info',
                      fontSize: 20,
                      fontWeight: FontWeight.normal)
                ]),
          ),
        );
      },
    );
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

  Future<void> addSuggestionMeals(MealsProvider mealsProvider,StorageProvider storageProvider) async {
    await mealsProvider.addSuggestedMeals(storageProvider);
  }

  Future<void> updateSuggestionMeal(MealsProvider mealsProvider, StorageProvider storageProvider, Meal  suggestedMeal) async {
    String? imageUrl = '';
    if (storageProvider.mealImageIsPicked) {
      if (suggestedMeal.imageUrl != null && suggestedMeal.imageUrl != "") {
        await StorageProvider().deleteImage(suggestedMeal.imageUrl);
      }
      imageUrl = await StorageProvider()
          .uploadFile(storageProvider.pickedMealImage!, "suggested_meals_images");
    }
    List<String> ingredients = MealsProvider()
        .editedSuggestedMealIngredientsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();
    List<String> steps = MealsProvider()
        .editedSuggestedMealStepsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();
    var updatedSuggestedMeal = await MealsProvider().updateSuggestedMeal(Meal(
        documentId: suggestedMeal.documentId,
        name: suggestedMealNameController.text,
        ingredients: ingredients,
        recipe: steps,
        imageUrl: (imageUrl?.isNotEmpty ?? false) ? imageUrl : null,
        categoryId: mealsProvider.suggestedMealCategoryId,
        typeId: MealTypes.suggestedMeal));
    mealsProvider.resetSuggestedMealValues(storageProvider);

    Get.to(MealScreen(meal: updatedSuggestedMeal, source: 'suggested',));
  }

  Meal findSuggestedMealById(meals, id) {
    Meal suggestedMeals = meals.firstWhere((meal) => meal.documentId == id);
    return suggestedMeals;
  }
}
