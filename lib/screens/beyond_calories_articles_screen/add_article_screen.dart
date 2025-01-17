import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/controllers/beyond_calories_article_controller.dart';
import 'package:foodlink_admin_panel/providers/settings_provider.dart';
import 'package:foodlink_admin_panel/screens/widgets/custom_app_textfield.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../core/constants/assets.dart';
import '../../providers/beyond_calories_articles_provider.dart';
import '../widgets/custom_button.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({super.key});

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  @override
  Widget build(BuildContext context) {
    final BeyondCaloriesArticlesProvider beyondCaloriesArticlesProvider =
        Provider.of<BeyondCaloriesArticlesProvider>(context, listen: true);
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DottedBorder(
            borderType: BorderType.RRect,
            child: ClipRect(
              child: Container(
                width: SizeConfig.getProperVerticalSpace(3),
                height: SizeConfig.getProperVerticalSpace(3),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: beyondCaloriesArticlesProvider.imageIsPicked == false
                    ? IconButton(
                        onPressed: BeyondCaloriesArticlesProvider().pickImage,
                        icon: const Icon(Icons.add_a_photo))
                    : SizedBox(
                        width: SizeConfig.getProperVerticalSpace(3),
                        height: SizeConfig.getProperVerticalSpace(3),
                        child: Image.memory(
                          beyondCaloriesArticlesProvider
                              .pickedFile!.files.first.bytes!,
                          fit: BoxFit.fill,
                        ),
                      ),
              ),
            ),
          ),
          SizeConfig.customSizedBox(null, 50, null),
          CustomAppTextField(
            width: 500,
            height: 100,
            hintText: "put_url",
            icon: Assets.web,
            controller: BeyondCaloriesArticlesController().urlController,
            maxLines: 1,
            iconSizeFactor: 1,
            settingsProvider: settingsProvider,
            isCentered: true,
            textAlign: TextAlign.left,
          ),
          SizeConfig.customSizedBox(null, 50, null),
          CustomButton(
              onTap: () async {
                if (beyondCaloriesArticlesProvider.pickedFile == null ||
                    BeyondCaloriesArticlesController()
                        .urlController
                        .text
                        .isEmpty) {
                  BeyondCaloriesArticlesController()
                      .showFailedAddDialog(context, settingsProvider);
                  return;
                }
                await BeyondCaloriesArticlesController()
                    .addArticle(beyondCaloriesArticlesProvider);
                beyondCaloriesArticlesProvider.resetValues();
                BeyondCaloriesArticlesController()
                    .showSuccessDialog(context, settingsProvider);
              },
              text: "confirm",
              width: 200,
              height: 100)
        ],
      ),
    );
  }
}
