import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/screens/widgets/custom_button.dart';
import '../../../controllers/meal_types.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/feature.dart';
import '../../../models/meal.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/storage_provider.dart';
import '../../../services/translation_services.dart';
import '../../widgets/custom_app_textfield.dart';
import 'ingredient_box.dart';
import 'step_box.dart';

class SuggestionTile extends StatelessWidget {
  const SuggestionTile({
    super.key,
    required this.mealsProvider,
    required this.settingsProvider,
    required this.storageProvider,
    required this.feature,
    required this.index,
    required this.length,
  });

  final MealsProvider mealsProvider;
  final StorageProvider storageProvider;
  final SettingsProvider settingsProvider;
  final Feature feature;
  final int index;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: [
          CustomAppTextField(
            width: SizeConfig.getProportionalWidth(100),
            height: SizeConfig.getProportionalHeight(50),
            icon: Assets.keyword,
            controller: mealsProvider.suggestionMealNameControllers[index],
            maxLines: 1,
            iconSizeFactor: 1,
            settingsProvider: settingsProvider,
            isCentered: true,
            textAlign: TextAlign.left,
          ),
          CustomAppTextField(
            width: 100,
            height: 500,
            icon: Assets.keyword,
            controller:
                mealsProvider.suggestionMealIngredientsControllers[index],
            maxLines: 20,
            iconSizeFactor: 1,
            settingsProvider: settingsProvider,
            isCentered: true,
            textAlign: TextAlign.left,
          ),
          CustomAppTextField(
            width: 100,
            height: 500,
            icon: Assets.keyword,
            controller: mealsProvider.suggestionMealRecipeControllers[index],
            maxLines: 50,
            iconSizeFactor: 1,
            settingsProvider: settingsProvider,
            isCentered: true,
            textAlign: TextAlign.left,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: SizeConfig.getProportionalWidth(200),
                height: SizeConfig.getProportionalHeight(200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.widgetsColor,
                ),
                child: storageProvider.featuresImagesArePicked[index]
                            ['ar_image_picked'] ==
                        true
                    ? Image.memory(
                        storageProvider.featuresPickedImages[index]['ar_image']
                            .files.first.bytes,
                        fit: BoxFit.fill)
                    : feature.arImageURL != ""
                        ? Image.network(feature.arImageURL, fit: BoxFit.fill)
                        : null,
              ),
            ],
          ),
          SizeConfig.customSizedBox(null, 10, null),
          IconButton(
              onPressed: () =>
                  storageProvider.pickFeatureImage("ar_feature", index),
              icon: const Icon(Icons.camera_alt_outlined)),
          SizeConfig.customSizedBox(null, 35, null)
        ],
      ),
      if (index != length) const Divider()
    ]);
  }
}

class EmptySuggestionTile extends StatefulWidget {
  const EmptySuggestionTile({
    super.key,
    required this.mealsProvider,
    required this.settingsProvider,
    required this.storageProvider,
    required this.tileIndex,
  });

  final MealsProvider mealsProvider;
  final SettingsProvider settingsProvider;
  final StorageProvider storageProvider;
  final int tileIndex;

  @override
  State<EmptySuggestionTile> createState() => _EmptySuggestionTileState();
}

class _EmptySuggestionTileState extends State<EmptySuggestionTile> {
  final items = [
    TranslationService().translate("Breakfast"),
    TranslationService().translate("Lunch"),
    TranslationService().translate("Dinner"),
    TranslationService().translate("Sweets"),
    TranslationService().translate("Snacks"),
    TranslationService().translate("Drinks"),
  ];
  List<TextEditingController> ingredientControllers = [];
  List<TextEditingController> stepsControllers = [];
  String? selectedValue;
  int? categoryId;

  @override
  void initState() {
    super.initState();
    ingredientControllers = [
      TextEditingController(),
    ];
    stepsControllers = [
      TextEditingController(),
    ];
  }

  @override
  void dispose() {
    for (var c in ingredientControllers) {
      c.dispose();
    }
    for (var c in stepsControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void addIngredient() {
    setState(() {
      ingredientControllers.add(TextEditingController());
    });
  }

  void addStepBox() {
    setState(() {
      stepsControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: SizeConfig.getProportionalHeight(100)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: SizeConfig.getProportionalWidth(50),
                    child: DropdownButton<String>(
                      value: selectedValue,
                      hint: const Text("Select meal type"),
                      isExpanded: true,
                      items: items.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final value = entry.value;
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                          onTap: () {
                            categoryId = idx; // store the index
                          },
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      },
                    ),
                  ),
                  SizeConfig.customSizedBox(15, null, null),
                  CustomAppTextField(
                    width: SizeConfig.getProperHorizontalSpace(20),
                    height: SizeConfig.getProportionalHeight(50),
                    icon: Assets.keyword,
                    controller: widget.mealsProvider
                        .suggestionMealNameControllers[widget.tileIndex],
                    hintText: TranslationService().translate("meal_name"),
                    maxLines: 1,
                    iconSizeFactor: 1,
                    settingsProvider: widget.settingsProvider,
                    isCentered: true,
                    textAlign: TextAlign.left,
                  ),
                  SizeConfig.customSizedBox(15, null, null),
                  SizedBox(
                    width: SizeConfig.getProperHorizontalSpace(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...ingredientControllers.map(
                          (controller) => IngredientBox(
                            settingsProvider: widget.settingsProvider,
                            controller: controller,
                          ),
                        ),
                        AddIngredientBoxForSuggestion(
                          mealsProvider: widget.mealsProvider,
                          onTap: addIngredient,
                        ),
                      ],
                    ),
                  ),
                  SizeConfig.customSizedBox(15, null, null),
                  SizedBox(
                    width: SizeConfig.getProperHorizontalSpace(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...stepsControllers.map(
                          (controller) => StepBox(
                            settingsProvider: widget.settingsProvider,
                            controller: controller,
                          ),
                        ),
                        AddStepBox(
                          mealsProvider: widget.mealsProvider,
                          onTap: addStepBox,
                        ),
                      ],
                    ),
                  ),
                  SizeConfig.customSizedBox(15, null, null),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: SizeConfig.getProperHorizontalSpace(5),
                        height: SizeConfig.getProportionalHeight(200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.widgetsColor,
                        ),
                        child: widget.storageProvider.suggestionsImagesArePicked[
                                    widget.tileIndex] ==
                                true
                            ? Image.memory(
                                widget
                                    .storageProvider
                                    .suggestionsPickedImages[widget.tileIndex]
                                    .files
                                    .first
                                    .bytes,
                                fit: BoxFit.fill)
                            : null,
                      ),
                      IconButton(
                          onPressed: () => StorageProvider()
                              .pickSuggestionImage(widget.tileIndex),
                          icon: const Icon(Icons.camera_alt_outlined))
                    ],
                  ),
                ],
              ),
              CustomButton(
                  onTap: () {
                    List<String> ingredients = ingredientControllers
                        .map((ingredientController) => ingredientController.text)
                        .where((text) => text.trim().isNotEmpty)
                        .toList();

                    List<String> steps = stepsControllers
                        .map((stepController) => stepController.text)
                        .where((text) => text.trim().isNotEmpty)
                        .toList();

                    Meal meal = Meal(
                      name: widget.mealsProvider
                          .suggestionMealNameControllers[widget.tileIndex].text,
                      ingredients: ingredients,
                      recipe: steps,
                      typeId: MealTypes.suggestedMeal,
                      categoryId: categoryId,
                    );
                    widget.mealsProvider.addSuggestedMeal(meal);
                  },
                  text: "Add",
                  width: SizeConfig.getProperHorizontalSpace(15),
                  height: SizeConfig.getProperVerticalSpace(15))
            ],
          ),
        ),
        Positioned(
            left: 0,
            top: 20,
            child: IconButton(
                onPressed: () =>
                    widget.mealsProvider.removeSuggestedMeal(widget.tileIndex),
                icon: const Icon(Icons.remove_circle_outline)))
      ],
    );
  }
}

class AddSuggestionTile extends StatelessWidget {
  const AddSuggestionTile(
      {super.key, required this.mealsProvider, required this.storageProvider});

  final MealsProvider mealsProvider;
  final StorageProvider storageProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => mealsProvider.increaseSuggestions(storageProvider),
      child: Container(
          width: SizeConfig.getProportionalWidth(100),
          height: SizeConfig.getProportionalHeight(50),
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(5),
            horizontal: SizeConfig.getProportionalWidth(3),
          ),
          decoration: BoxDecoration(
            color: AppColors.widgetsColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.add)),
    );
  }
}
