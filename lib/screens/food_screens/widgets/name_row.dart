import 'package:flutter/material.dart';
import '../../../controllers/meal_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';

class NameRow extends StatelessWidget {
  const NameRow({super.key, required this.name, required this.fontSize, required this.textWidth, required this.settingsProvider});

  final String name;
  final double fontSize;
  final double textWidth;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = MealController().detectLanguage(name);
    return settingsProvider.language == 'en'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(Assets.mealNameIcon),
              SizeConfig.customSizedBox(10, null, null),
              SizeConfig.customSizedBox(
                textWidth,
                null,
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  name,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: writtenLanguage == 'en'? 'salsa' : 'MyriadArabic'),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizeConfig.customSizedBox(
                textWidth,
                null,
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  name,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: writtenLanguage == 'en'? 'salsa' : 'MyriadArabic'),
                ),
              ),
              SizeConfig.customSizedBox(10, null, null),
              Image.asset(Assets.mealNameIcon),
            ],
          );
  }
}
