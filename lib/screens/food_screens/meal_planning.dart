import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/admins_provider.dart';
import '../dashboard/widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/image_container.dart';
import '../widgets/profile_circle.dart';

class MealPlanning extends StatefulWidget {
  const MealPlanning({super.key});

  @override
  State<MealPlanning> createState() => _MealPlanningState();
}

class _MealPlanningState extends State<MealPlanning> {
  @override
  void initState() {
    // MealsProvider()
    //     .getAllMealsByCategory(AdminsProvider().selectedAdmin!.adminId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    MealsProvider mealsProvider = Provider.of<MealsProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getProportionalWidth(50),
                horizontal: SizeConfig.getProportionalWidth(20)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBackButton(),
                CustomText(
                    isCenter: true,
                    text: "meal_planning_inline",
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                ProfileCircle(height: 50, width: 50, iconSize: 25)
              ],
            ),
          )),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar:
          const CustomBottomNavigationBar(fromDashboard: false),
      body: Column(children: [
        ImageContainer(imageUrl: Assets.mealPlanningHeaderImage),
        Align(
          alignment: settingsProvider.language == 'en'
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getProportionalHeight(20),
                horizontal: SizeConfig.getProportionalWidth(20)),
            child: const CustomText(
                isCenter: false,
                text: "meal_plan",
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        // ListView.builder(
        //     itemCount: 7,
        //     itemBuilder: (ctx, index) {
        //       return PlanMealTile(
        //           meal: meal,
        //           day: day,
        //           date: date,
        //           index: index,
        //           mealsProvider: mealsProvider);
        //     })
      ]),
    );
  }
}
