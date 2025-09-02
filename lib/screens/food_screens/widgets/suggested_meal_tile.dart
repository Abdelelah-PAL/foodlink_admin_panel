import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/screens/food_screens/edit_suggestion_meal_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/assets.dart';
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
    Get.to(MealScreen(meal: widget.meal));
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: SizeConfig.getProportionalWidth(355),
          height: SizeConfig.getProportionalHeight(200),
          margin: EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(10)),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 7,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            textDirection: settingsProvider.language == "en"
                ? TextDirection.ltr
                : TextDirection.rtl,
            children: [
              Container(
                width: SizeConfig.getProportionalWidth(150),
                height: SizeConfig.getProportionalHeight(200),
                decoration: const BoxDecoration(
                  color: AppColors.widgetsColor,
                ),
                child: widget.meal.imageUrl != null &&
                        widget.meal.imageUrl!.isNotEmpty
                    ? Image.network(
                        widget.meal.imageUrl!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      )
                    : Image.asset(
                        Assets.defaultMealImage,
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.getProportionalHeight(10),
                      left: settingsProvider.language == 'en'
                          ? 0
                          : SizeConfig.getProportionalWidth(5),
                      right: settingsProvider.language == 'en'
                          ? SizeConfig.getProportionalWidth(5)
                          : 0),
                  child: Column(
                    children: [
                      NameRow(
                        name: widget.meal.name,
                        fontSize: 15,
                        textWidth: 135,
                        settingsProvider: settingsProvider,
                      ),
                      IngredientsRow(
                        meal: widget.meal,
                        fontSize: 14,
                        textWidth: 135,
                        maxLines: 2,
                        settingsProvider: settingsProvider,
                      ),
                      SizeConfig.customSizedBox(
                        null,
                        13,
                        Row(
                          mainAxisAlignment: settingsProvider.language == "en"
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            SizeConfig.customSizedBox(5, null, null),
                            GestureDetector(
                                onTap: () async {
                                  await MealsProvider().deleteSuggestedMeal(
                                      widget.meal.documentId!);
                                  if (widget.meal.imageUrl != null &&
                                      widget.meal.imageUrl != "") {
                                    await MealsProvider()
                                        .deleteImage(widget.meal.imageUrl);
                                  }
                                },
                                child: const Icon(Icons.delete_outlined)),
                            SizeConfig.customSizedBox(5, null, null),
                            GestureDetector(
                                onTap: () {
                                  MealsProvider().fillDataForEditionSuggestedMeal(widget.meal, widget.index);
                                  Get.to(EditSuggestionMealScreen(
                                    meal: widget.meal,
                                    index: widget.index,
                                  ));
                                },
                                child: const Icon(Icons.edit)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
