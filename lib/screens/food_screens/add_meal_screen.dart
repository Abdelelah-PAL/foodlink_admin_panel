import 'package:flutter/material.dart';
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
import 'widgets/ingredient_box.dart';
import 'widgets/meal_image_container.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({
    super.key,
    required this.isAddScreen,
    this.meal,
  });

  final bool isAddScreen;
  final Meal? meal;

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProvider =
        Provider.of<MealsProvider>(context, listen: true);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                const MealImageContainer(),
                SizeConfig.customSizedBox(null, 20, null),
                Row(
                  textDirection: settingsProvider.language == 'en'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  children: [
                    CustomAppTextField(
                      width: 348,
                      height: 100,
                      headerText: "meal_name",
                      icon: Assets.mealNameIcon,
                      controller: MealController().nameController,
                      maxLines: 2,
                      iconSizeFactor: 31,
                      settingsProvider: settingsProvider,
                      isCentered: false,
                    ),
                    SizeConfig.customSizedBox(100, null, null),
                    CustomButton(
                        onTap: () async {
                          await MealController().selectDate(context);
                        },
                        text: "pick_date",
                        width: 200,
                        height: 100),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getProportionalWidth(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    textDirection: settingsProvider.language == 'en'
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizeConfig.customSizedBox(
                            31, 31, Image.asset(Assets.mealIngredients)),
                      ),
                      CustomText(
                        isCenter: false,
                        text: TranslationService().translate("ingredients"),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      SizeConfig.customSizedBox(15, null, null),
                      SizeConfig.customSizedBox(
                          420,
                          130,
                          Directionality(
                            textDirection: settingsProvider.language == 'ar'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 50,
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 3,
                                      childAspectRatio: 10),
                              itemCount: mealsProvider.numberOfIngredients,
                              itemBuilder: (context, index) {
                                if (index ==
                                    mealsProvider.numberOfIngredients - 1) {
                                  return AddIngredientBox(
                                      mealsProvider: mealsProvider);
                                }
                                return IngredientBox(
                                    settingsProvider: settingsProvider,
                                    controller: mealsProvider
                                        .ingredientsControllers[index]);
                              },
                            ),
                          )),
                    ],
                  ),
                ),
                CustomAppTextField(
                  width: 348,
                  height: 300,
                  headerText: "recipe",
                  icon: Assets.mealRecipe,
                  controller: MealController().recipeController,
                  maxLines: 10,
                  iconSizeFactor: 48,
                  settingsProvider: settingsProvider,
                  isCentered: false,
                ),
                SizeConfig.customSizedBox(null, 50, null),
                CustomButton(
                  onTap: () async {
                    widget.isAddScreen
                        ? {
                            if (MealController().nameController.text.isEmpty ||
                                MealController()
                                    .recipeController
                                    .text
                                    .isEmpty ||
                                MealController().day == null ||
                                MealController().day!.isEmpty ||
                                MealController().selectedDate == null)
                              {
                                MealController().showFailedAddDialog(
                                    context, settingsProvider),
                              }
                            else
                              await MealController().addMeal(mealsProvider)
                          }
                        : {
                            if (MealController().nameController.text.isEmpty ||
                                MealController()
                                    .recipeController
                                    .text
                                    .isEmpty ||
                                MealController().day == null ||
                                MealController().day!.isEmpty ||
                                MealController().selectedDate == null)
                              {
                                MealController().showFailedAddDialog(
                                    context, settingsProvider),
                              }
                            else
                              await MealController()
                                  .updateMeal(mealsProvider, widget.meal)
                          };
                  },
                  text: TranslationService()
                      .translate(widget.isAddScreen ? "confirm" : "edit"),
                  width: SizeConfig.getProportionalWidth(126),
                  height: SizeConfig.getProportionalHeight(400),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
