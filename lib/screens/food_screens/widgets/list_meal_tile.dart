import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';
import '../meal_screen.dart';
import 'ingredients_row.dart';
import 'name_row.dart';

class ListMealTile extends StatefulWidget {
  const ListMealTile({
    super.key,
    required this.meal,
    required this.favorites,
    required this.index,
  });

  final Meal meal;
  final bool favorites;
  final int index;

  @override
  State<ListMealTile> createState() => _ListMealTileState();
}

class _ListMealTileState extends State<ListMealTile> {
  onTap() {
    Get.to(MealScreen(
      meal: widget.meal,
      index: widget.index,
    ));
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(15)),
      child: settingsProvider.language == "en"
          ? Stack(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        width: SizeConfig.getProportionalWidth(182),
                        height: SizeConfig.getProportionalHeight(95),
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
                      )),
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
                            IngredientsRow(
                              meal: widget.meal,
                              fontSize: 14,
                              textWidth: 80,
                              maxLines: 3,
                              settingsProvider: settingsProvider,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          : Stack(children: [
              GestureDetector(
                onTap: onTap,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        NameRow(
                          name: widget.meal.name,
                          fontSize: 15,
                          textWidth: 115,
                          settingsProvider: settingsProvider,
                        ),
                        SizeConfig.customSizedBox(null, 10, null),
                        IngredientsRow(
                          meal: widget.meal,
                          fontSize: 14,
                          textWidth: 80,
                          maxLines: 3,
                          settingsProvider: settingsProvider,
                        ),
                      ],
                    ),
                    SizeConfig.customSizedBox(10, null, null),
                    Expanded(
                        child: Container(
                      width: SizeConfig.getProportionalWidth(182),
                      height: SizeConfig.getProportionalHeight(95),
                      decoration: BoxDecoration(
                        color: AppColors.widgetsColor,
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
                    )),
                  ],
                ),
              ),
            ]),
    );
  }
}
