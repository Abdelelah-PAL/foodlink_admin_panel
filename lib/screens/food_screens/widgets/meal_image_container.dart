import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/storage_provider.dart';
import '../../../services/translation_services.dart';
import '../../widgets/custom_back_button.dart';

class MealImageContainer extends StatefulWidget {
  const MealImageContainer(
      {super.key,
      this.imageUrl,
      required this.isAddSource,
      required this.isUpdateSource,
      this.backButtonOnPressed});

  final bool isAddSource;
  final bool isUpdateSource;
  final String? imageUrl;
  final VoidCallback? backButtonOnPressed;

  @override
  State<MealImageContainer> createState() => _MealImageContainerState();
}

class _MealImageContainerState extends State<MealImageContainer> {
  bool isUploading = false;
  String? uploadedImageUrl;

  @override
  Widget build(BuildContext context) {
    final StorageProvider storageProvider =
        Provider.of<StorageProvider>(context, listen: true);
    return SafeArea(
      child: widget.isUpdateSource
          ? Stack(
              children: [
                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.getProperVerticalSpace(2),
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                      color: AppColors.widgetsColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      border: Border(
                        bottom: BorderSide(
                            width: 1, color: AppColors.defaultBorderColor),
                      )),
                  child: storageProvider.mealImageIsPicked
                      ? Image.memory(
                          storageProvider.pickedMealImage!.files.first.bytes!,
                          fit: BoxFit.cover,
                        )
                      : (!storageProvider.mealImageIsDeleted &&
                              widget.imageUrl != null &&
                              widget.imageUrl!.isNotEmpty)
                          ? Image.network(
                              widget.imageUrl!,
                              fit: BoxFit.fill,
                            )
                          : null,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.getProperVerticalSpace(12)),
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        await storageProvider.pickFile("meal");
                        if (mounted) setState(() {});
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                if (storageProvider.mealImageIsPicked ||
                    (!storageProvider.mealImageIsDeleted &&
                        widget.imageUrl != null &&
                        widget.imageUrl!.isNotEmpty))
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () {
                        storageProvider.deleteMealImage();
                        if (mounted) setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ),
                CustomBackButton(
                  onPressed: widget.backButtonOnPressed ?? () => Get.back(),
                ),
              ],
            )
          : Stack(
              children: [
                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.getProperVerticalSpace(2),
                  decoration: const BoxDecoration(
                    color: AppColors.widgetsColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    border: Border(
                      bottom: BorderSide(
                          width: 1, color: AppColors.defaultBorderColor),
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.getProperVerticalSpace(2),
                  decoration: const BoxDecoration(
                    color: AppColors.widgetsColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    border: Border(
                      bottom: BorderSide(
                          width: 1, color: AppColors.defaultBorderColor),
                    ),
                  ),
                  child: !widget.isAddSource &&
                          widget.imageUrl != null &&
                          widget.imageUrl!.isNotEmpty
                      ? Image.network(
                          widget.imageUrl!,
                          fit: BoxFit.fill,
                        )
                      : null,
                ),
                if (widget.isAddSource)
                  Positioned.fill(
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          await storageProvider.pickFile("meal");
                          if (mounted) setState(() {});
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                TranslationService()
                                    .translate("upload_food_image"),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.primaryFont)),
                            SizeConfig.customSizedBox(
                              10,
                              null,
                              null,
                            ),
                            const Icon(Icons.file_upload_outlined)
                          ],
                        ),
                      ),
                    ),
                  ),
                if (storageProvider.mealImageIsPicked && widget.isAddSource)
                  Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.getProperVerticalSpace(2),
                    padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                        color: AppColors.widgetsColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        border: Border(
                          bottom: BorderSide(
                              width: 1, color: AppColors.defaultBorderColor),
                        )),
                    child: Image.memory(
                      storageProvider.pickedMealImage!.files.first.bytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                CustomBackButton(
                  onPressed: widget.backButtonOnPressed ?? () => Get.back(),
                ),
              ],
            ),
    );
  }
}
