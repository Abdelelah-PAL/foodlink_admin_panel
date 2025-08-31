import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../controllers/features_controller.dart';
import '../../providers/features_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/storage_provider.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'show_features_screen.dart';
import 'widgets/feature_tile.dart';

class AddFeatureScreen extends StatefulWidget {
  const AddFeatureScreen({super.key});

  @override
  State<AddFeatureScreen> createState() => _AddFeatureScreenState();
}

class _AddFeatureScreenState extends State<AddFeatureScreen> {
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
                text: "adding_features",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.getProperVerticalSpace(10),
            horizontal: SizeConfig.getProperHorizontalSpace(20)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmptyFeatureTile(
                  featuresProvider: featuresProvider,
                  settingsProvider: settingsProvider,
                  storageProvider: storageProvider),
              SizeConfig.customSizedBox(null, 20, null),
              CustomButton(
                  onTap: () async {
                    await FeaturesController().addEmptyFeature(
                        featuresProvider, storageProvider, null);
                    await featuresProvider.getAllFeatures(storageProvider);
                    featuresProvider.resetFeatureValues;
                   Get.to(const ShowFeaturesScreen());
                  },
                  text: 'confirm',
                  width: 100,
                  height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
