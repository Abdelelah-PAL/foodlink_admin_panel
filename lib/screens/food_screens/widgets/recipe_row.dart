import 'package:flutter/material.dart';
import '../../../controllers/meal_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';

class RecipeRow extends StatelessWidget {
  const RecipeRow({super.key, required this.meal, required this.fontSize, required this.settingsProvider});

  final Meal meal;
  final double fontSize;
  final SettingsProvider settingsProvider;


  @override
  Widget build(BuildContext context) {
    String writtenLanguage = MealController().detectLanguage(meal.recipe!);

    return settingsProvider.language == 'en'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Assets.mealRecipe),
              SizeConfig.customSizedBox(
                250,
                200,
                Text(
                  maxLines: 10,
                  meal.recipe!,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontFamily:
                          writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic'),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizeConfig.customSizedBox(
                250,
                200,
                Text(
                  maxLines: 10,
                  meal.recipe!,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontFamily:
                          writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic'),
                ),
              ),
              Image.asset(Assets.mealRecipe),
            ],
          );
  }
}
