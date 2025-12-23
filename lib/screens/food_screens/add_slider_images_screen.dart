import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/meal_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/storage_provider.dart';
import '../dashboard/dashboard.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class AddSliderImagesScreen extends StatefulWidget {
  const AddSliderImagesScreen({super.key});

  @override
  State<AddSliderImagesScreen> createState() => _AddSliderImagesScreenState();
}

class _AddSliderImagesScreenState extends State<AddSliderImagesScreen> {
  late MealsProvider mealsProvider;
  late StorageProvider storageProvider;

  @override
  Widget build(BuildContext context) {
    mealsProvider = context.watch<MealsProvider>();
    storageProvider = context.watch<StorageProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child:  Row(
          children: [
            const CustomBackButton(),
            SizedBox(
              width: SizeConfig.getProperHorizontalSpace(2.3),
            ),
            const CustomText(
              isCenter: true,
              text: "slider_images",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: IconButton(
              onPressed: () => storageProvider.pickFile("DOW"),
              icon: const Icon(Icons.add_a_photo, size: 30),
            ),
          ),
          if (storageProvider.dOWIsPicked && storageProvider.pickedDOW != null)
            Center(
              child: Image.memory(
                storageProvider.pickedDOW!.files.first.bytes!,
                width: SizeConfig.getProperHorizontalSpace(7),
                height: SizeConfig.getProperVerticalSpace(5),
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
                      var imageUrl = await storageProvider.uploadFile(
                        storageProvider.pickedDOW!,
                        "dish_of_the_week",
                      );

                      if (!context.mounted) return;
                      MealController().showSuccessUploadingDialog(
                          context, settingsProvider);
                      mealsProvider.resetPlannedMealValues(storageProvider);
                      await storageProvider.saveImageMetadata(
                        imageUrl!,
                        true,
                      );
                      Get.to(const Dashboard());
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
