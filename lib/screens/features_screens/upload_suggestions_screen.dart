import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../controllers/features_controller.dart';
import '../../core/constants/assets.dart';
import '../../providers/features_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/storage_provider.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class UploadSuggestionsScreen extends StatefulWidget {
  const UploadSuggestionsScreen({super.key});

  @override
  State<UploadSuggestionsScreen> createState() =>
      _UploadSuggestionsScreenState();
}

class _UploadSuggestionsScreenState extends State<UploadSuggestionsScreen> {
  @override
  Widget build(BuildContext context) {
    final FeaturesProvider featuresProvider =
    Provider.of<FeaturesProvider>(context, listen: true);
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    final StorageProvider storageProvider =
        Provider.of<StorageProvider>(context, listen: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
        child: SafeArea(
          child: Row(
            children: [
              const CustomBackButton(),
              SizedBox(
                width: SizeConfig.getProperHorizontalSpace(2.3),
              ),
              const CustomText(
                isCenter: true,
                text: "uploading_suggestions",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.getProperVerticalSpace(3),
              height: SizeConfig.getProperVerticalSpace(3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 3),
                shape: BoxShape.rectangle,
              ),
              child: storageProvider.pickedSuggestionsFile == null
                  ? IconButton(
                      onPressed: () =>
                          StorageProvider().pickFile("suggestions"),
                      icon: const Icon(Icons.file_upload))
                  : SizedBox(
                      width: SizeConfig.getProperVerticalSpace(3),
                      height: SizeConfig.getProperVerticalSpace(3),
                      child: Center(
                        child: Image.asset(Assets.excel),
                      )),
            ),
            if (storageProvider.pickedSuggestionsFile != null) ...[
              SizeConfig.customSizedBox(null, 20, null),
              Text(storageProvider.pickedSuggestionsFile!.names[0]!),
            ],
            SizeConfig.customSizedBox(null, 50, null),
            CustomButton(
                onTap: () async {
                  if (storageProvider.pickedSuggestionsFile != null) {
                    await StorageProvider().uploadFile(
                        storageProvider.pickedSuggestionsFile!, "suggestions");
                    featuresProvider.resetSuggestionValues(storageProvider);
                    FeaturesController().showSuccessDialog(
                        context, settingsProvider, 'file_uploaded');
                  }
                },
                text: "confirm",
                width: 100,
                height: 50)
          ],
        ),
      ),
    );
  }
}
