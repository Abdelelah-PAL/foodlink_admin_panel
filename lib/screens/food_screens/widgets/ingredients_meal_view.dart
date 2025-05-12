import 'package:flutter/material.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';
import 'meal_properties_header.dart';


class IngredientsMealView extends StatelessWidget {

  const IngredientsMealView({super.key, required this.settingsProvider, required this.meal});
  final SettingsProvider settingsProvider;
  final Meal meal;


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(horizontal: SizeConfig.getProportionalWidth(10)),
      child: Column(
        children: [
          MealPropertiesHeader(settingsProvider: settingsProvider, icon:  Assets.mealIngredients, text: 'ingredients'),
          Container(
            padding: EdgeInsets.only(
                top: SizeConfig.getProportionalHeight(10),
                left: SizeConfig.getProportionalWidth(20),
                right: SizeConfig.getProportionalWidth(20)),
            width: SizeConfig.getProportionalWidth(348),
            child: SizeConfig.customSizedBox(
              250,
              null,
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  meal.ingredients.join('\n'),
                  maxLines: 100,
                  overflow: TextOverflow.ellipsis,
                  textAlign: settingsProvider.language == 'en'
                      ? TextAlign.end
                      : TextAlign.start,
                  textDirection: settingsProvider.language == 'en'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: AppFonts.primaryFont,
                ),
              ),
            ),
          ),
          )],
      ),
    );
  }
}
