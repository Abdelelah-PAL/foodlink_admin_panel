import 'package:flutter/material.dart';
import '../../../controllers/meal_types.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/storage_provider.dart';
import '../../../services/translation_services.dart';
import '../../widgets/custom_app_textfield.dart';
import '../../widgets/custom_button.dart';
import 'ingredient_box.dart';
import 'step_box.dart';


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

  Meal get meal => widget.mealsProvider.suggestionsToAdd[widget.tileIndex];

  @override
  void initState() {
    super.initState();
    // initialize with at least one box
    ingredientControllers.add(TextEditingController(text: meal.ingredients.isNotEmpty ? meal.ingredients[0] : ""));
    stepsControllers.add(TextEditingController(text: meal.recipe != null && meal.recipe!.isNotEmpty ? meal.recipe![0] : ""));
    // ensure meal lists have at least one item
    if (meal.ingredients.isEmpty) meal.ingredients.add("");
    if (meal.recipe == null) meal.recipe = [""];
  }

  void addIngredient() {
    setState(() {
      ingredientControllers.add(TextEditingController());
      meal.ingredients.add("");
    });
  }

  void addStep() {
    setState(() {
      stepsControllers.add(TextEditingController());
      meal.recipe!.add("");
    });
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
                  // Meal type dropdown
                  SizedBox(
                    width: SizeConfig.getProportionalWidth(50),
                    child: DropdownButton<int>(
                      value: meal.categoryId,
                      hint: const Text("Select meal type"),
                      isExpanded: true,
                      items: items.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final value = entry.value;
                        return DropdownMenuItem<int>(
                          value: idx,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() => meal.categoryId = newValue);
                        }
                      },
                    ),
                  ),
                  SizeConfig.customSizedBox(15, null, null),

                  // Meal name
                  CustomAppTextField(
                    width: SizeConfig.getProperHorizontalSpace(20),
                    height: SizeConfig.getProportionalHeight(50),
                    icon: Assets.keyword,
                    controller: widget.mealsProvider.addedSuggestedMealNameControllers[widget.tileIndex],
                    hintText: TranslationService().translate("meal_name"),
                    maxLines: 1,
                    iconSizeFactor: 1,
                    settingsProvider: widget.settingsProvider,
                    isCentered: true,
                    textAlign: TextAlign.left,
                    onChanged: (val) => meal.name = val,
                  ),
                  SizeConfig.customSizedBox(15, null, null),

                  // Ingredients
                  SizedBox(
                    width: SizeConfig.getProperHorizontalSpace(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...ingredientControllers.asMap().entries.map((entry) {
                          final i = entry.key;
                          final controller = entry.value;
                          while (meal.ingredients.length <= i) meal.ingredients.add("");
                          return IngredientBox(
                            settingsProvider: widget.settingsProvider,
                            controller: controller,
                            onChanged: (val) => meal.ingredients[i] = val,
                          );
                        }),
                        AddIngredientBoxForSuggestion(
                          mealsProvider: widget.mealsProvider,
                          onTap: addIngredient,
                        ),
                      ],
                    ),
                  ),
                  SizeConfig.customSizedBox(15, null, null),

                  // Recipe Steps
                  SizedBox(
                    width: SizeConfig.getProperHorizontalSpace(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...stepsControllers.asMap().entries.map((entry) {
                          final i = entry.key;
                          final controller = entry.value;
                          while (meal.recipe!.length <= i) meal.recipe!.add("");
                          return StepBox(
                            settingsProvider: widget.settingsProvider,
                            controller: controller,
                            onChanged: (val) => meal.recipe![i] = val,
                          );
                        }),
                        AddStepBox(
                          mealsProvider: widget.mealsProvider,
                          onTap: addStep,
                        ),
                      ],
                    ),
                  ),
                  SizeConfig.customSizedBox(15, null, null),

                  // Image picker
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
                        child: widget.storageProvider.suggestionsImagesArePicked[widget.tileIndex] == true
                            ? Image.memory(
                          widget.storageProvider.suggestionsPickedImages[widget.tileIndex].files.first.bytes,
                          fit: BoxFit.fill,
                        )
                            : (meal.imageUrl!.isNotEmpty ? Image.network(meal.imageUrl!, fit: BoxFit.fill) : null),
                      ),
                      IconButton(
                        onPressed: () async {
                          await StorageProvider().pickSuggestionImage(widget.tileIndex);
                          setState(() {
                            meal.imageUrl = ""; // update if needed
                          });
                        },
                        icon: const Icon(Icons.camera_alt_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // Remove meal button
        Positioned(
          left: 0,
          top: 20,
          child: IconButton(
            onPressed: () => widget.mealsProvider.removeSuggestedMeal(widget.tileIndex),
            icon: const Icon(Icons.remove_circle_outline),
          ),
        ),
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
            horizontal: SizeConfig.getProportionalWidth(151),
          ),
          decoration: BoxDecoration(
            color: AppColors.widgetsColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.add)),
    );
  }
}
