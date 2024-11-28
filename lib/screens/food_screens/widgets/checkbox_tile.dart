import 'package:flutter/material.dart';
import '../../../controllers/meal_controller.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';

class CheckboxTile extends StatelessWidget {
  const CheckboxTile({
    super.key,
    required this.text,
    required this.settingsProvider,
    required this.mealsProvider,
    required this.index,
    required this.ingredientsLength,
  });

  final String text;
  final SettingsProvider settingsProvider;
  final MealsProvider mealsProvider;
  final int index;
  final int ingredientsLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: 0,
            right: SizeConfig.getProportionalWidth(20),
            left: SizeConfig.getProportionalWidth(20)),
        child: settingsProvider.language == 'en'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                      isCenter: false,
                      text: text,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                  Checkbox(
                    value: mealsProvider.isIngredientChecked,
                    onChanged: (bool? value) {
                      mealsProvider.toggleCheckedIngredient(
                          value,  index);
                    },
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomText(
                      isCenter: false,
                      text: text,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                  Checkbox(
                    value: mealsProvider.checkboxValues[index],
                    onChanged: (bool? value) {
                      mealsProvider.toggleCheckedIngredient(value, index);
                      if(value == true) {
                        MealController().missingIngredients.add(text);
                      }
                    },
                  )
                ],
              ));
  }
}
