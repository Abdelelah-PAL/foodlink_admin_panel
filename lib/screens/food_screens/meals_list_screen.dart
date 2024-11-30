import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/screens/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/meal_categories_provider.dart';
import '../../providers/meals_provider.dart';
import '../../services/translation_services.dart';
import 'widgets/list_meal_tile.dart';

class MealsListScreen extends StatefulWidget {
  const MealsListScreen({
    super.key,
  });


  @override
  State<MealsListScreen> createState() => _MealsListScreenState();
}

class _MealsListScreenState extends State<MealsListScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProviderWatcher = context.watch<MealsProvider>();
    return mealsProviderWatcher.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(SizeConfig.getProportionalHeight(100)),
              child: const SafeArea(
                  child: CustomText(
                      isCenter: true,
                      text: "planned_meals",
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(20),
              ),
              child: mealsProviderWatcher.meals.isEmpty
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
                            itemCount: mealsProvider.meals.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, index) {
                              return ListMealTile(
                                meal: mealsProvider.meals[index],
                                favorites: false,
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
