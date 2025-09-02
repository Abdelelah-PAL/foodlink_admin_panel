import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/storage_provider.dart';
import '../../services/translation_services.dart';
import 'add_planned_meal_screen.dart';
import 'widgets/list_header.dart';
import 'widgets/plan_meal_tile.dart';

class PlannedMealsListScreen extends StatefulWidget {
  const PlannedMealsListScreen({
    super.key,
  });

  @override
  State<PlannedMealsListScreen> createState() => _PlannedMealsListScreenState();
}

class _PlannedMealsListScreenState extends State<PlannedMealsListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProviderWatcher = context.watch<MealsProvider>();
    SettingsProvider settingsProvider = context.watch<SettingsProvider>();
    StorageProvider storageProvider = context.watch<StorageProvider>();

    return mealsProviderWatcher.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(SizeConfig.getProportionalHeight(100)),
              child: SafeArea(
                  child: ListHeader(
                text: "planned_meals",
                onTap: () {
                  MealsProvider().resetValues(storageProvider);
                  Get.to(const AddPlannedMealScreen(
                      isAddScreen: true, isUpdateScreen: false));
                },
                spaceFactor: 3,
              )),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(20),
              ),
              child: mealsProviderWatcher.plannedMeals.isEmpty
                  ? SizeConfig.customSizedBox(
                      null,
                      null,
                      Center(
                        child: Text(
                          TranslationService().translate("add_first_meal"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: AppFonts.primaryFont,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Consumer<MealsProvider>(
                      builder: (context, mealsProvider, child) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.getProportionalHeight(20)),
                          child: ListView.builder(
                            itemCount: mealsProvider.plannedMeals.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, index) {
                              Meal meal = mealsProvider.plannedMeals[index];
                              return PlanMealTile(
                                meal: mealsProvider.plannedMeals[index],
                                index: index,
                                day: meal.day!,
                                date: meal.date!,
                                mealsProvider: mealsProvider,
                                settingsProvider: settingsProvider,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          );
  }
}
