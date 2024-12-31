import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/screens/dashboard/dashboard.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/translation_services.dart';
import '../widgets/custom_button.dart';
import 'add_meal_screen.dart';
import 'widgets/ingredients_row.dart';
import 'widgets/meal_image_container.dart';
import 'widgets/name_row.dart';
import 'widgets/recipe_row.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({super.key, required this.meal, this.index});

  final Meal meal;
  final int? index;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    MealsProvider mealsProvider =
        Provider.of<MealsProvider>(context, listen: true);
    return Scaffold(
      body: Column(
        children: [
          MealImageContainer(
            imageUrl: meal.imageUrl,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionalWidth(20),
            ),
            child: Column(
              children: [
                NameRow(
                  name: meal.name,
                  fontSize: 30,
                  textWidth: 250,
                  settingsProvider: settingsProvider,
                ),
                IngredientsRow(
                  meal: meal,
                  fontSize: 20,
                  textWidth: 250,
                  maxLines: 7,
                  settingsProvider: settingsProvider,
                ),
                SizeConfig.customSizedBox(null, 20, null),
                RecipeRow(
                    meal: meal,
                    fontSize: 15,
                    settingsProvider: settingsProvider)
              ],
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                        onTap: () {
                          Get.to(const Dashboard());
                        },
                        text: TranslationService().translate("proceed"),
                        width: 216,
                        height: 150),
                    SizeConfig.customSizedBox(null, 20, null),
                    CustomButton(
                        onTap: () {
                          MealsProvider().fillDataForEdition(meal);
                          Get.to(AddMealScreen(isAddScreen: false, meal: meal));
                        },
                        text: TranslationService().translate("edit"),
                        width: 216,
                        height: 150),
                    SizeConfig.customSizedBox(null, 20, null),
                  ]))
        ],
      ),
    );
  }
}
