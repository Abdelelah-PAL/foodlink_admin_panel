import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/screens/food_screens/edit_suggestion_meal_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';
import '../meal_screen.dart';
import 'ingredients_row.dart';
import 'name_row.dart';

class SuggestedMealTile extends StatefulWidget {
  const SuggestedMealTile({
    super.key,
    required this.meal,
    required this.index,
  });

  final Meal meal;
  final int index;

  @override
  State<SuggestedMealTile> createState() => _SuggestedMealTileState();
}

class _SuggestedMealTileState extends State<SuggestedMealTile> {
  onTap() {
    Get.to(MealScreen(
      meal: widget.meal,
      index: widget.index,
      source: 'suggested',
    ));
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(15)),
        child: Stack(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Row(
                textDirection: settingsProvider.language == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizeConfig.getProperHorizontalSpace(3),
                    height: SizeConfig.getProperVerticalSpace(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: AppColors.defaultBorderColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: widget.meal.imageUrl != null &&
                        widget.meal.imageUrl!.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      // Apply the same radius here
                      child: Image.network(
                        widget.meal.imageUrl!,
                        fit: BoxFit.fill,
                      ),
                    )
                        : const Icon(Icons.camera_alt_outlined),
                  ),
                  SizeConfig.customSizedBox(10, null, null),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NameRow(
                          name: widget.meal.name,
                          fontSize: 15,
                          textWidth: 115,
                          settingsProvider: settingsProvider,
                        ),
                        SizeConfig.customSizedBox(null, 10, null),
                        Row(
                          textDirection: settingsProvider.language == 'en'
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          children: [
                            IngredientsRow(
                              meal: widget.meal,
                              fontSize: 14,
                              textWidth: 400,
                              maxLines: 3,
                              settingsProvider: settingsProvider,
                            ),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await MealsProvider()
                                          .deleteSuggestedMeal(
                                          widget.meal.documentId!);
                                      setState(() {
                                        MealsProvider().getAllSuggestedMeals();
                                      });
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      MealsProvider().updateSuggestedMeal(widget.meal);
                                      Get.to(EditSuggestionMealScreen);
                                    },
                                    icon: const Icon(Icons.delete)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
