import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../providers/meals_provider.dart';
import '../../providers/storage_provider.dart';
import '../../services/translation_services.dart';
import 'add_suggestions_screen.dart';
import 'widgets/list_header.dart';
import 'widgets/suggested_meal_tile.dart';

class SuggestionMealsListScreen extends StatefulWidget {
  const SuggestionMealsListScreen({
    super.key,
  });

  @override
  State<SuggestionMealsListScreen> createState() =>
      _SuggestionMealsListScreenState();
}

class _SuggestionMealsListScreenState extends State<SuggestionMealsListScreen> {
  @override
  void initState() {
    MealsProvider().getAllSuggestedMeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProviderWatcher = context.watch<MealsProvider>();
    StorageProvider storageProvider = context.watch<StorageProvider>();

    return mealsProviderWatcher.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(SizeConfig.getProportionalHeight(100)),
              child: SafeArea(
                  child: ListHeader(
                     text: "suggested_meals",
                     onTap: () {
                  MealsProvider().resetValues(storageProvider);
                  Get.to(const AddSuggestionsScreen());
                },
                spaceFactor: 3,
              )),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(20),
              ),
              child: mealsProviderWatcher.suggestions.isEmpty
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
                            itemCount: mealsProvider.suggestions.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, index) {
                              Meal meal = mealsProvider.suggestions[index];
                              return SuggestedMealTile(
                                meal: meal,
                                index: index,
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
