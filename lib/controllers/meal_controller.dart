import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/utils/size_config.dart';
import '../models/meal.dart';
import '../providers/meals_provider.dart';
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

  MealsServices ms = MealsServices();

  List<String> missingIngredients = [];

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

  Future<void> addMeal(mealsProvider) async {
    String imageUrl = '';
    if (mealsProvider.imageIsPicked) {
      imageUrl = await MealsProvider()
          .uploadImage(mealsProvider.pickedFile, "planned_meals_images");
    }
    List<String> ingredients = MealsProvider()
        .ingredientsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();

    final addedMeal = await MealsProvider().addMeal(
      Meal(
        name: MealController().nameController.text,
        ingredients: ingredients,
        recipe: MealController().recipeController.text,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      ),
    );

    mealsProvider.resetValues();
    if (addedMeal == null) return;
    Get.to(MealScreen(meal: addedMeal));
  }

  Future<void> updateMeal(mealsProvider, meal) async {
    String imageUrl = '';
    if (mealsProvider.imageIsPicked) {
      imageUrl = await MealsProvider()
          .uploadImage(mealsProvider.pickedFile, "planned_meals_images");
    }
    List<String> ingredients = MealsProvider()
        .ingredientsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();

    var updatedMeal = await MealsProvider().updateMeal(Meal(
      documentId: meal.documentId,
      categoryId: meal.categoryId,
      name: MealController().nameController.text,
      ingredients: ingredients,
      recipe: MealController().recipeController.text,
      imageUrl: imageUrl.isNotEmpty ? imageUrl : meal.imageUrl,
    ));
    if (updatedMeal == null) return;

    Get.to(MealScreen(meal: updatedMeal));
  }

  Meal findMealById(meals, id) {
    Meal meal = meals.firstWhere((meal) => meal.documentId == id);
    return meal;
  }

  void showSuccessDialog(BuildContext context, settingsProvider) {
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
              children: settingsProvider.language == 'en'
                  ? [
                      const Icon(Icons.check_circle,
                          size: 30, color: Colors.green),
                      const CustomText(
                          isCenter: true,
                          text: 'notification_sent',
                          fontSize: 20,
                          fontWeight: FontWeight.normal)
                    ]
                  : [
                      const CustomText(
                          isCenter: true,
                          text: 'notification_sent',
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                      SizeConfig.customSizedBox(10, null, null),
                      const Icon(Icons.check_circle,
                          size: 30, color: Colors.green),
                    ],
            ),
          ),
        );
      },
    );
  }
}
