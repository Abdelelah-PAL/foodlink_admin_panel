import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/controllers/meal_controller.dart';
import 'package:foodlink_admin_panel/screens/food_screens/suggestion_meals_list_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/storage_provider.dart';
import 'widgets/suggestion_tile.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class AddSuggestionsScreen extends StatefulWidget {
  const AddSuggestionsScreen({super.key});

  @override
  State<AddSuggestionsScreen> createState() => _AddSuggestionsScreenState();
}

class _AddSuggestionsScreenState extends State<AddSuggestionsScreen> {
  @override
  Widget build(BuildContext context) {
    final MealsProvider mealsProvider =
        Provider.of<MealsProvider>(context, listen: true);
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    final StorageProvider storageProvider =
        Provider.of<StorageProvider>(context, listen: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
        child: SafeArea(
          child: Row(
            children: [
              const CustomBackButton(),
              SizedBox(
                width: SizeConfig.getProperHorizontalSpace(2.3),
              ),
              const CustomText(
                isCenter: true,
                text: "uploading_suggestions",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.getProperVerticalSpace(10),
            horizontal: SizeConfig.getProperHorizontalSpace(20)),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: mealsProvider.suggestionsToAdd.length + 1,
                  itemBuilder: (ctx, index) {
                    return index == mealsProvider.suggestionsToAdd.length
                        ? AddSuggestionTile(
                            mealsProvider: mealsProvider,
                            storageProvider: storageProvider,
                          )
                        : Column(
                            children: [
                              EmptySuggestionTile(
                                mealsProvider: mealsProvider,
                                storageProvider: storageProvider,
                                settingsProvider: settingsProvider,
                                tileIndex: index,
                              ),
                              const Divider()
                            ],
                          );
                  },
                ),
                SizeConfig.customSizedBox(null, 20, null),
                CustomButton(
                  onTap: () async {
                    await MealController().addSuggestionMeals(mealsProvider, settingsProvider, storageProvider, context);
                    Get.to(() => const SuggestionMealsListScreen());
                  },
                  text: 'confirm',
                  width: SizeConfig.getProperVerticalSpace(18),
                  height: SizeConfig.getProperVerticalSpace(13),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
