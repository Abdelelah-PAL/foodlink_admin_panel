import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/meals_provider.dart';
import '../../../services/translation_services.dart';
import '../../widgets/custom_back_button.dart';

class MealImageContainer extends StatefulWidget {
  const MealImageContainer(
      {super.key,
      this.imageUrl,
      required this.isAddSource,
      required this.isUpdateSource});

  final bool isAddSource;
  final bool isUpdateSource;
  final String? imageUrl;

  @override
  State<MealImageContainer> createState() => _MealImageContainerState();
}

class _MealImageContainerState extends State<MealImageContainer> {
  bool isUploading = false;
  String? uploadedImageUrl;

  @override
  Widget build(BuildContext context) {
    final MealsProvider mealsProvider =
        Provider.of<MealsProvider>(context, listen: true);
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
                  child: mealsProvider.imageIsPicked
                      ? Image.memory(
                          mealsProvider.pickedFile!.files.first.bytes!,
                          fit: BoxFit.cover,
                        )
                      : widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                          ? Image.network(
                              widget.imageUrl!,
                              fit: BoxFit.fill,
                            )
                          : null,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.getProperVerticalSpace(12)),
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        await mealsProvider.pickImage("meal");
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
                const CustomBackButton(),
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
                          await mealsProvider.pickImage("meal");
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
                if (mealsProvider.imageIsPicked && widget.isAddSource)
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
                      mealsProvider.pickedFile!.files.first.bytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                const CustomBackButton(),
              ],
            ),
    );
  }
}
