import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/utils/size_config.dart';
import '../../models/feature.dart';
import '../../providers/features_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/storage_provider.dart';
import '../food_screens/widgets/list_header.dart';
import '../widgets/custom_text.dart';
import 'add_feature_screen.dart';
import 'widgets/feature_tile.dart';

class ShowFeaturesScreen extends StatefulWidget {
  const ShowFeaturesScreen({super.key});

  @override
  State<ShowFeaturesScreen> createState() => _ShowFeaturesScreenState();
}

class _ShowFeaturesScreenState extends State<ShowFeaturesScreen> {
  @override
  Widget build(BuildContext context) {
    FeaturesProvider featuresProviderWatcher =
        context.watch<FeaturesProvider>();
    SettingsProvider settingsProvider = context.watch<SettingsProvider>();
    StorageProvider storageProvider = context.watch<StorageProvider>();

    return featuresProviderWatcher.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(SizeConfig.getProportionalHeight(100)),
              child: SafeArea(
                child: ListHeader(
                  text: "features",
                  onTap: () => Get.to(const AddFeatureScreen()),
                  spaceFactor: 3,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(10),
              ),
              child: featuresProviderWatcher.features.isEmpty
                  ? const Center(
                      child: CustomText(
                          isCenter: true,
                          text: "no_features",
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  : Consumer<FeaturesProvider>(
                      builder: (context, featuresProvider, child) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.getProportionalHeight(20)),
                          child: ListView.builder(
                              itemCount: featuresProvider.features.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (ctx, index) {
                                Feature feature =
                                    featuresProvider.features[index];
                                return FeatureTile(
                                  feature: feature,
                                  featuresProvider: featuresProvider,
                                  settingsProvider: settingsProvider,
                                  storageProvider: storageProvider,
                                  index: index,
                                  length: featuresProvider.features.length,
                                );
                              }),
                        );
                      },
                    ),
            ),
          );
  }
}
