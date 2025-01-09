import 'package:flutter/material.dart';
import '../../../controllers/meal_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';

class RecipeRow extends StatelessWidget {
  const RecipeRow(
      {super.key,
      required this.meal,
      required this.fontSize,
      required this.settingsProvider});

  final Meal meal;
  final double fontSize;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = MealController().detectLanguage(meal.recipe!);
    return Row(
      textDirection: settingsProvider.language == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      mainAxisAlignment: settingsProvider.language == 'en'
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(Assets.mealRecipe),
        SizeConfig.customSizedBox(
          250,
          200,
          SingleChildScrollView(
            child: Text(
              maxLines: 100,
              meal.recipe!,
              textDirection: settingsProvider.language == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              textAlign: settingsProvider.language == 'en'
                  ? TextAlign.end
                  : TextAlign.start,
              style: TextStyle(
                  fontSize: fontSize,
                  fontFamily:
                      writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic'),
            ),
          ),
        ),
      ],
    );
  }
}
