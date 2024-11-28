import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/meal_categories_provider.dart';
import '../../providers/meals_provider.dart';
import '../../providers/admins_provider.dart';
import '../../services/translation_services.dart';
import '../dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'add_meal_screen.dart';
import 'widgets/list_header.dart';
import 'widgets/list_meal_tile.dart';

class MealsListScreen extends StatefulWidget {
  const MealsListScreen({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<MealsListScreen> createState() => _MealsListScreenState();
}

class _MealsListScreenState extends State<MealsListScreen> {
  final mealCategories = MealCategoriesProvider().mealCategories;

  @override
  void initState() {
    MealsProvider().getAllMealsByCategory(AdminsProvider().selectedAdmin!.adminId);
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
              child: SafeArea(
                child: ListHeader(
                  text: TranslationService()
                      .translate(mealCategories[widget.index].mealsName),
                  isEmpty: mealsProviderWatcher.meals.isEmpty,
                  favorites: false,
                ),
              ),
            ),
            bottomNavigationBar: const CustomBottomNavigationBar(
              fromDashboard: false,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(const AddMealScreen(
                                   isAddScreen: true,
                                ));
                              },
                              child: Container(
                                width: SizeConfig.getProportionalWidth(105),
                                height: SizeConfig.getProportionalHeight(73),
                                decoration: BoxDecoration(
                                  color: AppColors.widgetsColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(Icons.add),
                              ),
                            ),
                            SizeConfig.customSizedBox(null, 20, null),
                            Text(
                              TranslationService().translate("add_first_meal"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: AppFonts.primaryFont,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
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
                                  favorites: false, index: index,);
                            },
                          ),
                        );
                      },
                    ),
            ),
          );
  }
}
