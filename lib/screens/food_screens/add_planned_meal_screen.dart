
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
import 'package:intl/intl.dart' as intl;

class AddPlannedMealScreen extends StatefulWidget {
  const AddPlannedMealScreen({
    super.key,
    required this.isAddScreen,
    this.meal, required this.isUpdateScreen,
  });

  final bool isUpdateScreen;
  final bool isAddScreen;
  final Meal? meal;

  @override
  State<AddPlannedMealScreen> createState() => _AddPlannedMealScreenState();
}

class _AddPlannedMealScreenState extends State<AddPlannedMealScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProvider =
    Provider.of<MealsProvider>(context, listen: true);
    StorageProvider storageProvider = Provider.of<StorageProvider>(
        context, listen: true);
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
                    isAddSource: widget.isAddScreen,
                    isUpdateSource: widget.isUpdateScreen,
                    imageUrl: widget.meal?.imageUrl,
                    backButtonOnPressed: () {
                      MealsProvider().resetPlannedMealValues(storageProvider);
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
                        controller: MealController().plannedMealNameController,
                        maxLines: 2,
                        iconSizeFactor: 31,
                        settingsProvider: settingsProvider,
                        isCentered: false,
                      ),
                      SizeConfig.customSizedBox(100, null, null),
                      Column(
                        children: [
                          CustomButton(
                            onTap: () async {
                              await mealsProvider.selectDate(context);
                            },
                            text: mealsProvider.selectedDate == null
                                ? "pick_date"
                                : intl.DateFormat('yyyy-MM-dd')
                                .format(mealsProvider.selectedDate!)
                                .toString(),
                            width: 100,
                            height: 100,
                          ),
                        ],
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
                              itemCount: mealsProvider.numberOfPlannedMealIngredients,
                              itemBuilder: (context, index) {
                                if (index ==
                                    mealsProvider.numberOfPlannedMealIngredients - 1) {
                                  return AddIngredientBox(
                                      mealsProvider: mealsProvider);
                                }
                                return IngredientBox(
                                    settingsProvider: settingsProvider,
                                    controller: mealsProvider
                                        .plannedMealIngredientsControllers[index]);
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
                        itemCount: mealsProvider.numberOfPlannedMealSteps,
                        itemBuilder: (context, index) {
                          if (index == mealsProvider.numberOfPlannedMealSteps - 1) {
                            return AddStepBox(
                              mealsProvider: mealsProvider,
                            );
                          }
                          return StepBox(
                              settingsProvider: settingsProvider,
                              controller:
                              mealsProvider.plannedMealStepsControllers[index]);
                        },
                      )),
                  SizeConfig.customSizedBox(null, 20, null),
                  CustomAppTextField(
                    width: 280,
                    height: 100,
                    headerText: "source",
                    icon: Assets.mealSource,
                    controller: MealController().sourceController,
                    maxLines: 2,
                    iconSizeFactor: 31,
                    settingsProvider: settingsProvider,
                    isCentered: false,
                  ),
                  SizeConfig.customSizedBox(null, 20, null),
                  CustomButton(
                    onTap: () async {
                      widget.isAddScreen
                          ? {
                        if (MealController()
                            .plannedMealNameController
                            .text
                            .isEmpty ||
                            mealsProvider.day == null ||
                            mealsProvider.day!.isEmpty ||
                            mealsProvider.selectedDate == null)
                          {
                            MealController().showFailedAddDialog(
                                context, settingsProvider),
                          }
                        else
                          await MealController().addPlannedMeal(mealsProvider, storageProvider)
                      }: {
                        if (MealController()
                            .plannedMealNameController
                            .text
                            .isEmpty ||
                            mealsProvider.day == null ||
                            mealsProvider.day!.isEmpty ||
                            mealsProvider.selectedDate == null)
                          {
                            MealController().showFailedAddDialog(
                                context, settingsProvider),
                          }
                        else
                          await MealController()
                              .updatePlannedMeal(mealsProvider,storageProvider, widget.meal!)
                      };
                    },
                    text: TranslationService()
                        .translate(widget.isAddScreen ? "confirm" : "edit"),
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
