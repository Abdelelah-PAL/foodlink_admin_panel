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

class MealController {
  static final MealController _instance = MealController._internal();

  factory MealController() => _instance;

  MealController._internal();

  TextEditingController nameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController recipeController = TextEditingController();
  TextEditingController addNoteController = TextEditingController();
  TextEditingController noteController = TextEditingController();
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
      .ingredientsControllers
      .map((controller) => controller.text)
      .where((text) => text.isNotEmpty)
      .toList();
  List<String> steps = MealsProvider()
      .stepsControllers
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

  Future<void> addMeal(MealsProvider mealsProvider, StorageProvider storageProvider) async {
    String? imageUrl;
    if (storageProvider.mealImageIsPicked) {
      imageUrl = await StorageProvider()
          .uploadImage(storageProvider.pickedMealImage!, "planned_meals_images");
    }
    List<String> ingredients = MealsProvider()
        .ingredientsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();
    List<String> steps = MealsProvider()
        .stepsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();

    var addedMeal = await MealsProvider().addMeal(Meal(
        name: nameController.text,
        ingredients: ingredients,
        recipe: steps,
        source: sourceController.text,
        imageUrl: (imageUrl?.isNotEmpty ?? false) ? imageUrl : null,
        day: mealsProvider.day,
        date: mealsProvider.selectedDate));

    FeaturesProvider().resetArticleValues(storageProvider);
    Get.to(MealScreen(meal: addedMeal));
  }

  Future<void> updateMeal(mealsProvider, meal) async {
    String? imageUrl = '';
    if (mealsProvider.mealImageIsPicked) {
      if (meal.imageUrl != null) {
        await StorageProvider().deleteImage(meal.imageUrl);
      }
      imageUrl = await StorageProvider().uploadImage(mealsProvider.pickedMealImage, "planned_meals_images");
    }
    List<String> ingredients = MealsProvider()
        .ingredientsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();
    List<String> steps = MealsProvider()
        .stepsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();
    var updatedMeal = await MealsProvider().updateMeal(Meal(
        documentId: meal.documentId,
        name: nameController.text,
        ingredients: ingredients,
        recipe: steps,
        source: sourceController.text,
        imageUrl: (imageUrl?.isNotEmpty ?? false) ? imageUrl : null,
        day: mealsProvider.day,
        date: mealsProvider.selectedDate));
    mealsProvider.resetArticleValues();

    Get.to(MealScreen(meal: updatedMeal));
  }

  Meal findMealById(meals, id) {
    Meal meal = meals.firstWhere((meal) => meal.documentId == id);
    return meal;
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
}
