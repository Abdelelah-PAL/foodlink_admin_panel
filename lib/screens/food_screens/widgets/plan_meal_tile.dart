import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../../../../../models/meal.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../providers/meals_provider.dart';
import '../../../../providers/settings_provider.dart';
import '../../../../services/translation_services.dart';
import '../../../providers/storage_provider.dart';
import '../../widgets/custom_text.dart';
import '../meal_screen.dart';
import 'ingredients_row.dart';
import 'name_row.dart';

class PlanMealTile extends StatefulWidget {
  const PlanMealTile({
    super.key,
    required this.meal,
    required this.day,
    required this.date,
    required this.index,
    required this.mealsProvider,
    required this.settingsProvider,
  });

  final Meal meal;
  final String day;
  final DateTime date;
  final int index;
  final MealsProvider mealsProvider;
  final SettingsProvider settingsProvider;

  @override
  State<PlanMealTile> createState() => _PlanMealTileState();
}

class _PlanMealTileState extends State<PlanMealTile> {
  late String formattedDate;

  onTap() {
    Get.to(MealScreen(
      meal: widget.meal, source: 'planned',
    ));
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ar_SA', null);
    initializeDateFormatting('en_US', null);
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);

    String formattedDate = settingsProvider.language == "en"
        ? intl.DateFormat.yMMMMd('en_US')
            .format(widget.date)
            .split(' ')
            .reversed
            .join(' ')
        : intl.DateFormat.yMMMMd('ar_SA')
            .format(widget.date)
            .split(' ')
            .reversed
            .join(' ');
    return Column(
        crossAxisAlignment: SettingsProvider().language == "en"
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          SizeConfig.customSizedBox(
            180,
            null,
            Row(
              textDirection: SettingsProvider().language == "en"
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              children: [
                Expanded(
                  child: CustomText(
                      isCenter: false,
                      text: TranslationService().translate(widget.day),
                      fontSize: SettingsProvider().language == "en" ? 12 : 20,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: CustomText(
                      isCenter: false,
                      text: formattedDate,
                      fontSize: SettingsProvider().language == "en" ? 10 : 18,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(15)),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: Row(
                      textDirection: widget.settingsProvider.language == "en"
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      children: [
                        Expanded(
                            child: Container(
                          width: SizeConfig.getProportionalWidth(182),
                          height: SizeConfig.getProportionalHeight(250),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: AppColors.defaultBorderColor),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: widget.meal.imageUrl != null &&
                                  widget.meal.imageUrl!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
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
                                settingsProvider: widget.settingsProvider,
                              ),
                              SizeConfig.customSizedBox(null, 10, null),
                              IngredientsRow(
                                meal: widget.meal,
                                fontSize: 14,
                                textWidth: 115,
                                maxLines: 3,
                                settingsProvider: widget.settingsProvider,
                              ),
                              SizeConfig.customSizedBox(null, 10, null),
                              IconButton(
                                  onPressed: () async {
                                    await MealsProvider()
                                        .deletePlannedMeal(widget.meal.documentId!);
                                    if (widget.meal.imageUrl != null ||
                                        widget.meal.imageUrl != "") {
                                      await StorageProvider()
                                          .deleteImage(widget.meal.imageUrl);
                                    }
                                    MealsProvider().getAllPlannedMeals();
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ]);
  }
}
