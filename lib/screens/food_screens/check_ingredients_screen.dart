import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/screens/food_screens/widgets/meal_image_container.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/meal_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/translation_services.dart';
import '../widgets/custom_app_textfield.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'widgets/checkbox_tile.dart';
import 'widgets/name_row.dart';

class CheckIngredientsScreen extends StatelessWidget {
  const CheckIngredientsScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    MealsProvider mealsProvider =
        Provider.of<MealsProvider>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            MealImageContainer(
                isAddSource: false,
                imageUrl: meal.imageUrl,
                mealsProvider: context.watch<MealsProvider>()),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(20),
              ),
              child: Column(
                children: [
                  NameRow(
                    name: meal.name,
                    fontSize: 30,
                    textWidth: 250,
                    settingsProvider: settingsProvider,
                  ),
                  SizeConfig.customSizedBox(null, 10, null),
                  settingsProvider.language == 'en'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(Assets.mealIngredients),
                            SizeConfig.customSizedBox(10, null, null),
                            const CustomText(
                                isCenter: false,
                                text: "ingredients",
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                                isCenter: false,
                                text: "ingredients",
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            SizeConfig.customSizedBox(10, null, null),
                            Image.asset(Assets.mealIngredients),
                          ],
                        ),
                  SizeConfig.customSizedBox(
                    null,
                    250,
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: meal.ingredients.length,
                      itemBuilder: (ctx, index) {
                        return CheckboxTile(
                            text: meal.ingredients[index],
                            settingsProvider: settingsProvider,
                            mealsProvider: mealsProvider,
                            index: index,
                            ingredientsLength: meal.ingredients.length);
                      },
                    ),
                  ),
                  CustomAppTextField(
                      width: 263,
                      height: 79,
                      headerText: "add_notes",
                      icon: Assets.note,
                      controller: MealController().addNoteController,
                      maxLines: 7,
                      iconSizeFactor: 31,
                      settingsProvider: settingsProvider),
                ],
              ),
            ),
            SizeConfig.customSizedBox(null, 30, null),
            if (settingsProvider.language == 'en')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      onTap: () {
                      },
                      text: TranslationService().translate("notify"),
                      width: 137,
                      height: 45),
                  SizeConfig.customSizedBox(20, null, null),
                  CustomButton(
                      onTap: Get.back,
                      text: TranslationService().translate("back"),
                      width: 137,
                      height: 45),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      onTap: Get.back,
                      text: TranslationService().translate("back"),
                      width: 137,
                      height: 45),
                  SizeConfig.customSizedBox(20, null, null),
                  CustomButton(
                      onTap: () async {

                        MealController()
                            .showSuccessDialog(context, settingsProvider);
                      },
                      text: TranslationService().translate("notify"),
                      width: 137,
                      height: 45),
                ],
              )
          ],
        ),
      ),
    );
  }
}
