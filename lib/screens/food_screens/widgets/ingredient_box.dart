import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';

class IngredientBox extends StatelessWidget {
  const IngredientBox({
    super.key,
    required this.settingsProvider,
    this.onChanged,
    required this.mealsProvider,
    required this.edition,
    required this.index,
  });

  final SettingsProvider settingsProvider;
  final MealsProvider mealsProvider;
  final ValueChanged<String>? onChanged;
  final bool edition;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(10),
            horizontal: SizeConfig.getProportionalWidth(3),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1.0, color: AppColors.widgetsColor),
          ),
          child: TextField(
            onChanged: onChanged,
            controller: mealsProvider.plannedMealIngredientsControllers[index],
            textDirection: settingsProvider.language == 'en'
                ? TextDirection.ltr
                : TextDirection.rtl,
            textAlign: settingsProvider.language == 'en'
                ? TextAlign.left
                : TextAlign.right,
            style: const TextStyle(fontSize: 12),
            // Set font size here
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                  SizeConfig.getProportionalWidth(10),
                  SizeConfig.getProportionalHeight(0),
                  SizeConfig.getProportionalWidth(10),
                  SizeConfig.getProportionalHeight(15)),
              border: InputBorder.none,
            ),
          ),
        ),
        Positioned(
            left: -10,
            top: 0,
            child: IconButton(
                onPressed: () {
                  edition == true
                      ? mealsProvider.removeEditionIngredient(index)
                      : mealsProvider.removeAdditionIngredient(index);
                },
                icon: const Icon(
                  Icons.highlight_remove_rounded,
                  size: 18,
                  color: Colors.grey,
                )))
      ],
    );
  }
}

class AddIngredientBox extends StatelessWidget {
  const AddIngredientBox({super.key, required this.mealsProvider, this.onTap});

  final MealsProvider mealsProvider;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? mealsProvider.increasePlannedMealIngredients,
      child: Container(
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(10),
            horizontal: SizeConfig.getProportionalWidth(3),
          ),
          decoration: BoxDecoration(
            color: AppColors.widgetsColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.add)),
    );
  }
}

class AddIngredientBoxForSuggestion extends StatelessWidget {
  const AddIngredientBoxForSuggestion(
      {super.key, required this.mealsProvider, this.onTap});

  final MealsProvider mealsProvider;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? mealsProvider.increasePlannedMealIngredients,
      child: Container(
          width: SizeConfig.getProperHorizontalSpace(10),
          height: SizeConfig.getProportionalWidth(15),
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(10),
            horizontal: SizeConfig.getProportionalWidth(3),
          ),
          decoration: BoxDecoration(
            color: AppColors.widgetsColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.add)),
    );
  }
}
