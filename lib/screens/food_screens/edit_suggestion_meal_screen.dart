import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/meal_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/storage_provider.dart';
import '../../services/translation_services.dart';
import '../widgets/custom_app_textfield.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'widgets/ingredient_box.dart';
import 'widgets/meal_image_container.dart';
import 'widgets/step_box.dart';

class EditSuggestionMealScreen extends StatefulWidget {
  const EditSuggestionMealScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  State<EditSuggestionMealScreen> createState() =>
      _EditSuggestionMealScreenState();
}

class _EditSuggestionMealScreenState extends State<EditSuggestionMealScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProvider =
    Provider.of<MealsProvider>(context, listen: true);
    StorageProvider storageProvider =
    Provider.of<StorageProvider>(context, listen: true);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProperHorizontalSpace(16)),
              child: Column(
                children: [
                  MealImageContainer(
                    isAddSource: false,
                    isUpdateSource: true,
                    imageUrl: widget.meal.imageUrl,
                    backButtonOnPressed: () {
                      MealsProvider().resetSuggestedMealValues(storageProvider);
                      Get.back();
                    },
                  ),
                  SizeConfig.customSizedBox(null, 20, null),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: settingsProvider.language == 'en'
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    children: [
                      CustomAppTextField(
                        width: 100,
                        height: 100,
                        headerText: "meal_name",
                        icon: Assets.mealNameIcon,
                        controller:
                        MealController().suggestedMealNameController,
                        maxLines: 2,
                        iconSizeFactor: 31,
                        settingsProvider: settingsProvider,
                        isCentered: false,
                      ),
                      SizedBox(
                        width: SizeConfig.getProportionalWidth(50),
                        child: DropdownButton<int>(
                          value: mealsProvider.suggestedMealCategoryId,
                          hint: const Text("Select meal type"),
                          isExpanded: true,
                          items: MealController()
                              .categories
                              .map((category) => DropdownMenuItem<int>(
                            value: category["id"] as int, // 👈 use map key
                            child: Text(category["name"] as String), // 👈 use map key
                          ))
                              .toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              mealsProvider.changeSuggestedMealCategoryId(newValue);
                            }
                          },
                        ),
                      ),

                    ],
                  ),
                  Row(
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
                          600,
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
                              itemCount: mealsProvider
                                  .numberOfEditedSuggestedMealIngredients,
                              itemBuilder: (context, index) {
                                if (index ==
                                    mealsProvider
                                        .numberOfEditedSuggestedMealIngredients -
                                        1) {
                                  return AddIngredientBox(
                                      onTap: () {
                                        mealsProvider
                                            .increaseSuggestedMealIngredients();
                                      },
                                      mealsProvider: mealsProvider);
                                }
                                return Stack(
                                  children: [
                                    IngredientBox(
                                        settingsProvider: settingsProvider,
                                        controller: mealsProvider
                                            .editedSuggestedMealIngredientsControllers[
                                        index]),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: InkWell(
                                        onTap: () {
                                          mealsProvider
                                              .removeSuggestedMealIngredient(index);
                                        },
                                        child: const Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          )),
                    ],
                  ),
                  Row(
                    textDirection: settingsProvider.language == 'en'
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizeConfig.customSizedBox(
                          31, 31, Image.asset(Assets.mealRecipe)),
                      CustomText(
                        isCenter: false,
                        text: TranslationService().translate("recipe"),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  Container(
                      width: SizeConfig.getProperHorizontalSpace(1),
                      height: SizeConfig.getProperVerticalSpace(4),
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.getProportionalWidth(26)),
                      child: ListView.builder(
                        itemCount:
                        mealsProvider.numberOfEditedSuggestedMealSteps,
                        itemBuilder: (context, index) {
                          if (index ==
                              mealsProvider.numberOfEditedSuggestedMealSteps -
                                  1) {
                            return AddStepBox(
                              onTap: () {
                                mealsProvider.increaseSuggestedMealSteps();
                              },
                              mealsProvider: mealsProvider,
                            );
                          }
                          return Stack(
                            children: [
                              StepBox(
                                  settingsProvider: settingsProvider,
                                  controller: mealsProvider
                                      .editedSuggestedMealStepsControllers[index]),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    mealsProvider.removeSuggestedMealStep(index);
                                  },
                                  child: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      )),
                  SizeConfig.customSizedBox(null, 20, null),
                  CustomButton(
                    onTap: () async {
                      if (MealController()
                          .suggestedMealNameController
                          .text
                          .isEmpty) {
                        MealController()
                            .showFailedAddDialog(context, settingsProvider);
                      } else {
                        await MealController().updateSuggestionMeal(
                            mealsProvider, storageProvider, widget.meal);
                        await MealsProvider().getAllSuggestedMeals();
                      }
                    },
                    text: TranslationService().translate("edit"),
                    width: SizeConfig.getProperHorizontalSpace(8),
                    height: SizeConfig.getProperVerticalSpace(10),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}