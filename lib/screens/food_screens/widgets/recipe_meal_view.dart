import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';
import 'meal_properties_header.dart';

class RecipeMealView extends StatelessWidget {
  const RecipeMealView({
    super.key,
    required this.meal,
    required this.fontSize,
    required this.settingsProvider,
  });

  final Meal meal;
  final double fontSize;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.getProportionalWidth(10)),
      child: Column(
        children: [
          MealPropertiesHeader(
              settingsProvider: settingsProvider,
              icon: Assets.mealRecipe,
              text: 'recipe'),
          Container(
            height: SizeConfig.getProportionalHeight(200),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalHeight(20)),
            child: meal.recipe!.isEmpty
                ? const Center(
                    child: CustomText(
                        isCenter: true,
                        text: "no_recipe",
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  )
                : ListView.builder(
                    itemCount: meal.recipe!.length,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      return RichText(
                        textDirection: settingsProvider.language == 'en'
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${index + 1} ',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.widgetsColor,
                                  fontFamily: AppFonts.primaryFont),
                            ),
                            TextSpan(
                              text: meal.recipe![index].tr, // Recipe text
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.fontColor,
                                  fontFamily:  AppFonts.primaryFont),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
