import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/size_config.dart';
import '../../models/feature.dart';
import '../../providers/features_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/storage_provider.dart';
import '../widgets/custom_text.dart';
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
              child: const SafeArea(
                  child: CustomText(
                      isCenter: true,
                      text: "features",
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(10),
              ),
              child: featuresProviderWatcher.features.isEmpty
                  ? EmptyFeatureTile(
                      featuresProvider: featuresProviderWatcher,
                      settingsProvider: settingsProvider,
                      storageProvider: storageProvider,
                      index: 0,
                    )
                  : Consumer<FeaturesProvider>(
                      builder: (context, featuresProvider, child) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.getProportionalHeight(20)),
                          child: ListView.builder(
                              itemCount: featuresProvider.features.length + 1,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (ctx, index) {
                                if (index >= featuresProvider.features.length) {
                                  return EmptyFeatureTile(
                                    featuresProvider: featuresProvider,
                                    settingsProvider: settingsProvider,
                                    storageProvider: storageProvider,
                                    index: index,
                                  );
                                }

                                Feature feature = featuresProvider.features[index];
                                return FeatureTile(
                                  feature: feature,
                                  featuresProvider: featuresProvider,
                                  settingsProvider: settingsProvider,
                                  storageProvider: storageProvider,
                                  index: index,
                                );
                              }
                          ),
                        );
                      },
                    ),
            ),
          );
  }
}
