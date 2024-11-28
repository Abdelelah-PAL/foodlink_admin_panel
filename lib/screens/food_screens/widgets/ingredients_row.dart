import 'package:flutter/material.dart';
import '../../../core/constants/assets.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';

class IngredientsRow extends StatelessWidget {
  const IngredientsRow(
      {super.key,
      required this.meal,
      required this.fontSize,
      required this.textWidth,
      required this.maxLines,
      required this.settingsProvider});

  final Meal meal;
  final double fontSize;
  final double textWidth;
  final int maxLines;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return settingsProvider.language == 'en'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Assets.mealIngredients),
              SizeConfig.customSizedBox(10, null, null),
              SizeConfig.customSizedBox(
                textWidth,
                null,
                Text(
                  meal.ingredients.join('-'),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: settingsProvider.language == 'en'
                          ? 'salsa'
                          : 'MyriadArabic'),
                ),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizeConfig.customSizedBox(
                  textWidth,
                  null,
                  Text(
                    meal.ingredients.join('-'),
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: settingsProvider.language == 'en'
                            ? 'salsa'
                            : 'MyriadArabic'),
                  )),
              Image.asset(Assets.mealIngredients),
            ],
          );
  }
}
