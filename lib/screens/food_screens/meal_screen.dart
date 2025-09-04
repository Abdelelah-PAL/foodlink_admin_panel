import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/providers/storage_provider.dart';
import 'package:foodlink_admin_panel/screens/food_screens/edit_suggestion_meal_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/translation_services.dart';
import '../dashboard/dashboard.dart';
import '../widgets/custom_button.dart';
import 'add_planned_meal_screen.dart';
import 'widgets/ingredients_meal_view.dart';
import 'widgets/meal_image_container.dart';
import 'widgets/name_row.dart';
import 'widgets/recipe_meal_view.dart';
import 'widgets/source_meal_view.dart';

class MealScreen extends StatelessWidget {
  const MealScreen(
      {super.key, required this.meal, this.index, required this.source});

  final Meal meal;
  final int? index;
  final String source;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    StorageProvider storageProvider = Provider.of<StorageProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MealImageContainer(
              imageUrl: meal.imageUrl,
              isAddSource: false,
              isUpdateSource: false,
              backButtonOnPressed: () {
                if (source == "planned") {
                  MealsProvider().resetPlannedMealValues(storageProvider);
                } else {
                  MealsProvider().resetSuggestedMealValues(storageProvider);
                }
                Get.back();
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.getProportionalWidth(20),
                right: SizeConfig.getProportionalWidth(20),
                bottom: SizeConfig.getProportionalHeight(70),
                top: SizeConfig.getProportionalHeight(20),
              ),
              child: Column(
                crossAxisAlignment: settingsProvider.language == 'en'
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.getProportionalWidth(10)),
                    child: NameRow(
                      name: meal.name,
                      fontSize: 20,
                      textWidth: 280,
                      settingsProvider: settingsProvider,
                    ),
                  ),
                  SizeConfig.customSizedBox(null, 30, null),
                  IngredientsMealView(
                    meal: meal,
                    settingsProvider: settingsProvider,
                  ),
                  SizeConfig.customSizedBox(null, 30, null),
                  RecipeMealView(
                    meal: meal,
                    fontSize: 15,
                    settingsProvider: settingsProvider,
                  ),
                  SizeConfig.customSizedBox(null, 30, null),
                  SourceMealView(
                    meal: meal,
                    settingsProvider: settingsProvider,
                  )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    bottom: SizeConfig.getProportionalHeight(20)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        onTap: () {
                          Get.to(const Dashboard());
                        },
                        text: TranslationService().translate("proceed"),
                        width: 137,
                        height: 45,
                      ),
                      SizeConfig.customSizedBox(null, 20, null),
                      CustomButton(
                        onTap: () {
                          if (source == "planned") {
                            MealsProvider().fillDataForEditionPlannedMeal(meal);
                            Get.to(AddPlannedMealScreen(
                              isAddScreen: false,
                              meal: meal,
                              isUpdateScreen: true,
                            ));
                          } else {
                            MealsProvider()
                                .fillDataForEditionSuggestedMeal(meal);
                            Get.to(EditSuggestionMealScreen(meal: meal));
                          }
                        },
                        text: TranslationService().translate("edit"),
                        width: 137,
                        height: 45,
                      ),
                      SizeConfig.customSizedBox(null, 20, null),
                    ]))
          ],
        ),
      ),
    );
  }
}
