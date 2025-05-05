import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/meals_provider.dart';
import '../../../services/translation_services.dart';

class MealImageContainer extends StatefulWidget {
  const MealImageContainer({super.key, this.imageUrl});

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
      child: Stack(
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
                bottom:
                    BorderSide(width: 1, color: AppColors.defaultBorderColor),
              ),
            ),
          ),
          widget.imageUrl != null
              ? Container(
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
                  child: Image.network(
                    widget.imageUrl!,
                    fit: BoxFit.cover, // Keep BoxFit.cover for best result
                  ),
                )
              : Positioned.fill(
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
                            TranslationService().translate("upload_food_image"),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.primaryFont,
                            ),
                          ),
                          SizeConfig.customSizedBox(10, null, null),
                          const Icon(Icons.file_upload_outlined),
                        ],
                      ),
                    ),
                  ),
                ),
          if (mealsProvider.imageIsPicked)
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
                child: Image.memory(
                  mealsProvider.pickedFile!.files.first.bytes!,
                  fit: BoxFit.cover, // Use BoxFit.cover here as well
                )),
        ],
      ),
    );
  }
}
