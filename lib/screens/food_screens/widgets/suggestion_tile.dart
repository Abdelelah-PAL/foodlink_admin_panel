import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/screens/food_screens/widgets/ingredient_box.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/feature.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/storage_provider.dart';
import '../../widgets/custom_app_textfield.dart';

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
            controller:
                mealsProvider.suggestionMealRecipeControllers[index],
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
                        storageProvider
                            .featuresPickedImages[index]['ar_image']
                            .files
                            .first
                            .bytes,
                        fit: BoxFit.fill)
                    : feature.arImageURL != ""
                        ? Image.network(feature.arImageURL,
                            fit: BoxFit.fill)
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
  List<TextEditingController> ingredientControllers = [];

  @override
  void initState() {
    super.initState();
    ingredientControllers = [
      TextEditingController(),
    ];
  }

  @override
  void dispose() {
    for (var c in ingredientControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void addIngredient() {
    setState(() {
      ingredientControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAppTextField(
          width: 70,
          height: 50,
          icon: Assets.keyword,
          controller: widget.mealsProvider
              .suggestionMealNameControllers[widget.tileIndex],
          maxLines: 1,
          iconSizeFactor: 1,
          settingsProvider: widget.settingsProvider,
          isCentered: true,
          textAlign: TextAlign.left,
        ),

        Flexible(
          child: SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...ingredientControllers.map(
                  (controller) =>  IngredientBox(
                      settingsProvider: widget.settingsProvider,
                      controller: controller,
                    ),
                ),
                AddIngredientBox(
                  mealsProvider: widget.mealsProvider,
                  onTap: addIngredient,
                ),
              ],
            ),
          ),
        ),


        // Recipe field
        CustomAppTextField(
          width: 70,
          height: 50,
          icon: Assets.keyword,
          controller: widget.mealsProvider
              .suggestionMealRecipeControllers[widget.tileIndex],
          maxLines: 50,
          iconSizeFactor: 1,
          settingsProvider: widget.settingsProvider,
          isCentered: true,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

class AddSuggestionTile extends StatelessWidget {
  const AddSuggestionTile({super.key, required this.mealsProvider});

  final MealsProvider mealsProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: mealsProvider.increaseSuggestions,
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
