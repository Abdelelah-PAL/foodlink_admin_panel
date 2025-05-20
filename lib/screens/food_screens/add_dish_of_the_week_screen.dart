import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/meal_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/storage_provider.dart';
import '../widgets/custom_button.dart';

class AddDishOfTheWeekScreen extends StatefulWidget {
  const AddDishOfTheWeekScreen({super.key});

  @override
  State<AddDishOfTheWeekScreen> createState() => _AddDishOfTheWeekScreenState();
}

class _AddDishOfTheWeekScreenState extends State<AddDishOfTheWeekScreen> {
  Offset _position = Offset.zero;
  late MealsProvider mealsProvider;
  late StorageProvider storageProvider;
  final GlobalKey imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      setState(() {
        _position = Offset(
          (screenSize.width - 100) / 2,
          (screenSize.height - 100) / 2,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mealsProvider = context.watch<MealsProvider>();
    storageProvider = context.watch<StorageProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              Assets.dishOfTheWeek,
              key: imageKey,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () => storageProvider.pickImage("DOW"),
              icon: const Icon(Icons.add_a_photo, size: 30),
            ),
          ),
          if (storageProvider.dOWIsPicked && storageProvider.pickedDOW != null)
            Positioned(
              left: _position.dx,
              top: _position.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _position += details.delta;
                  });
                },
                child: Image.memory(
                  storageProvider.pickedDOW!.files.first.bytes!,
                  width: SizeConfig.getProperHorizontalSpace(7),
                  height: SizeConfig.getProperVerticalSpace(5),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                CustomButton(
                  onTap: () async {
                    try {
                      if (storageProvider.pickedDOW == null) {
                        throw Exception('pickedDOW is null');
                      }

                      var imageUrl = await storageProvider.uploadImage(
                        storageProvider.pickedDOW!,
                        "dish_of_the_week",
                      );

                      final RenderBox imageBox = imageKey.currentContext
                          ?.findRenderObject() as RenderBox;
                      final Offset imageTopLeft =
                          imageBox.localToGlobal(Offset.zero);
                      final Offset relativePosition = _position - imageTopLeft;

                      final double x =
                          relativePosition.dx / imageBox.size.width;
                      final double y =
                          relativePosition.dy / imageBox.size.height;

                      final double rawWidth =
                          SizeConfig.getProperHorizontalSpace(7);
                      final double rawHeight =
                          SizeConfig.getProperVerticalSpace(5);

                      final double width = rawWidth / imageBox.size.width;
                      final double height = rawHeight / imageBox.size.height;
                      await storageProvider.saveImageMetadata(
                        imageUrl!,
                        x,
                        y,
                        width,
                        height,
                      );

                      if (!context.mounted) return;
                      MealController().showSuccessUploadingDialog(
                          context, settingsProvider);
                      mealsProvider.resetValues(storageProvider);
                    } catch (e) {
                      log('uploadImage : $e');
                    }
                  },
                  text: "Upload",
                  width: 100,
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
