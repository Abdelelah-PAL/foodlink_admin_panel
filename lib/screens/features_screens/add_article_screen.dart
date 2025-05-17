import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../controllers/features_controller.dart';
import '../../core/constants/assets.dart';
import '../../providers/features_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/storage_provider.dart';
import '../widgets/custom_app_textfield.dart';
import '../widgets/custom_button.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({super.key});

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  @override
  Widget build(BuildContext context) {
    final FeaturesProvider featuresProvider =
        Provider.of<FeaturesProvider>(context, listen: true);
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    final StorageProvider storageProvider =
        Provider.of<StorageProvider>(context, listen: true);
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
                child: storageProvider.articleImageIsPicked == false
                    ? IconButton(
                        onPressed: () =>
                            StorageProvider().pickImage("articles"),
                        icon: const Icon(Icons.add_a_photo))
                    : SizedBox(
                        width: SizeConfig.getProperVerticalSpace(3),
                        height: SizeConfig.getProperVerticalSpace(3),
                        child: Image.memory(
                          storageProvider
                              .pickedArticleImage!.files.first.bytes!,
                          fit: BoxFit.fill,
                        ),
                      ),
              ),
            ),
          ),
          SizeConfig.customSizedBox(null, 50, null),
          CustomAppTextField(
            width: 300,
            height: 100,
            hintText: "put_url",
            icon: Assets.web,
            controller: FeaturesController().urlController,
            maxLines: 1,
            iconSizeFactor: 1,
            settingsProvider: settingsProvider,
            isCentered: true,
            textAlign: TextAlign.left,
          ),
          SizeConfig.customSizedBox(null, 50, null),
          CustomButton(
              onTap: () async {
                if (storageProvider.pickedArticleImage == null ||
                    FeaturesController().urlController.text.isEmpty) {
                  FeaturesController()
                      .showFailedAddDialog(context, settingsProvider);
                  return;
                }
                await FeaturesController().addArticle(storageProvider);
                featuresProvider.resetArticleValues(storageProvider);
                FeaturesController()
                    .showSuccessDialog(context, settingsProvider);
              },
              text: "confirm",
              width: 100,
              height: 50)
        ],
      ),
    );
  }
}
