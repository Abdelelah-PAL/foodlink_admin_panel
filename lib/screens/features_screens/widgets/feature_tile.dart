import 'package:flutter/material.dart';
import '../../../controllers/features_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/feature.dart';
import '../../../providers/features_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/storage_provider.dart';
import '../../widgets/custom_app_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.featuresProvider,
    required this.settingsProvider,
    required this.storageProvider,
    required this.feature,
    required this.index,
  });

  final FeaturesProvider featuresProvider;
  final StorageProvider storageProvider;
  final SettingsProvider settingsProvider;
  final Feature feature;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(15)),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.ltr,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppTextField(
                    width: 100,
                    height: 50,
                    icon: Assets.keyword,
                    controller: featuresProvider.featuresControllers[index],
                    maxLines: 1,
                    iconSizeFactor: 1,
                    settingsProvider: settingsProvider,
                    isCentered: true,
                    textAlign: TextAlign.left,
                  ),
                  SizeConfig.customSizedBox(null, 50, null),
                  Row(
                    children: [
                      Column(children: [
                        const CustomText(
                          isCenter: true,
                          text: "active",
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        SizeConfig.customSizedBox(null, 30, null),
                        const CustomText(
                          isCenter: true,
                          text: "premium",
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        SizeConfig.customSizedBox(null, 30, null),
                        const CustomText(
                          isCenter: true,
                          text: "user",
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        SizeConfig.customSizedBox(null, 30, null),
                        const CustomText(
                          isCenter: true,
                          text: "cooker",
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ]),
                      SizeConfig.customSizedBox(30, null, null),
                      Column(
                        children: [
                          Checkbox(
                            activeColor: AppColors.backgroundColor,
                            checkColor: AppColors.fontColor,
                            value: featuresProvider.statuses[index]
                                    ['active_feature'] ??
                                false,
                            onChanged: (bool? newValue) {
                              featuresProvider.toggleActiveFeature(index);
                            },
                            side: const BorderSide(
                              color: AppColors.textFieldBorderColor,
                            ),
                          ),
                          SizeConfig.customSizedBox(null, 30, null),
                          Checkbox(
                            activeColor: AppColors.backgroundColor,
                            checkColor: AppColors.fontColor,
                            value: featuresProvider.statuses[index]
                                    ['premium_feature'] ??
                                false,
                            onChanged: (bool? newValue) {
                              featuresProvider.togglePremiumFeature(index);
                            },
                            side: const BorderSide(
                              color: AppColors.textFieldBorderColor,
                            ),
                          ),
                          SizeConfig.customSizedBox(null, 30, null),
                          Checkbox(
                            activeColor: AppColors.backgroundColor,
                            checkColor: AppColors.fontColor,
                            value: featuresProvider.userTypesAppearance[index]
                                    ['user'] ??
                                false,
                            onChanged: (bool? newValue) {
                              featuresProvider.toggleUserAppearance(index);
                            },
                            side: const BorderSide(
                              color: AppColors.textFieldBorderColor,
                            ),
                          ),
                          SizeConfig.customSizedBox(null, 30, null),
                          Checkbox(
                            activeColor: AppColors.backgroundColor,
                            checkColor: AppColors.fontColor,
                            value: featuresProvider.userTypesAppearance[index]
                                    ['cooker'] ??
                                false,
                            onChanged: (bool? newValue) {
                              featuresProvider.toggleCookerAppearance(index);
                            },
                            side: const BorderSide(
                              color: AppColors.textFieldBorderColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizeConfig.customSizedBox(null, 20, null),
                  Row(
                    children: [
                      CustomButton(
                        onTap: () => {
                          FeaturesController().deleteFeature(
                              storageProvider, featuresProvider, feature),
                          FeaturesController().addFeature(
                              featuresProvider, storageProvider, index)
                        },
                        text: 'confirm',
                        width: 50,
                        height: 50,
                      ),
                      SizeConfig.customSizedBox(20, null, null),
                      CustomButton(
                        onTap: () => {
                          FeaturesController().deleteFeature(
                              storageProvider, featuresProvider, feature)
                        },
                        text: "delete",
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: SizeConfig.getProportionalWidth(200),
                        height: SizeConfig.getProportionalHeight(200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.widgetsColor,
                        ),
                        child:
                            Image.network(feature.arImageURL, fit: BoxFit.fill),
                      ),
                    ],
                  ),
                  SizeConfig.customSizedBox(null, 10, null),
                  IconButton(
                      onPressed: () => storageProvider.pickImage("ar_feature"),
                      icon: const Icon(Icons.camera_alt_outlined)),
                  SizeConfig.customSizedBox(null, 35, null),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: SizeConfig.getProportionalWidth(200),
                        height: SizeConfig.getProportionalHeight(200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.widgetsColor,
                        ),
                        child:
                            Image.network(feature.arImageURL, fit: BoxFit.fill),
                      ),
                    ],
                  ),
                  SizeConfig.customSizedBox(null, 10, null),
                  IconButton(
                      onPressed: () => storageProvider.pickImage("en_feature"),
                      icon: const Icon(Icons.camera_alt_outlined)),
                ],
              )
            ],
          ),
          const Divider()
        ]));
  }
}

class EmptyFeatureTile extends StatelessWidget {
  const EmptyFeatureTile({
    super.key,
    required this.featuresProvider,
    required this.settingsProvider,
    required this.storageProvider,
    required this.index,
  });

  final FeaturesProvider featuresProvider;
  final SettingsProvider settingsProvider;
  final StorageProvider storageProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(15)),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.ltr,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppTextField(
                    width: 100,
                    height: 50,
                    icon: Assets.keyword,
                    controller: featuresProvider.featuresControllers[index],
                    maxLines: 1,
                    iconSizeFactor: 1,
                    settingsProvider: settingsProvider,
                    isCentered: true,
                    textAlign: TextAlign.left,
                  ),
                  SizeConfig.customSizedBox(null, 50, null),
                  Row(
                    children: [
                      Column(children: [
                        const CustomText(
                          isCenter: true,
                          text: "active",
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        SizeConfig.customSizedBox(null, 30, null),
                        const CustomText(
                          isCenter: true,
                          text: "premium",
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        SizeConfig.customSizedBox(null, 30, null),
                        const CustomText(
                          isCenter: true,
                          text: "user",
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        SizeConfig.customSizedBox(null, 30, null),
                        const CustomText(
                          isCenter: true,
                          text: "cooker",
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ]),
                      SizeConfig.customSizedBox(30, null, null),
                      Column(
                        children: [
                          Checkbox(
                            activeColor: AppColors.backgroundColor,
                            checkColor: AppColors.fontColor,
                            value: featuresProvider.statuses[index]
                                ['active_feature'],
                            onChanged: (bool? newValue) {
                              featuresProvider.toggleActiveFeature(index);
                            },
                            side: const BorderSide(
                              color: AppColors.textFieldBorderColor,
                            ),
                          ),
                          SizeConfig.customSizedBox(null, 30, null),
                          Checkbox(
                            activeColor: AppColors.backgroundColor,
                            checkColor: AppColors.fontColor,
                            value: featuresProvider.statuses[index]
                                ['premium_feature'],
                            onChanged: (bool? newValue) {
                              featuresProvider.togglePremiumFeature(index);
                            },
                            side: const BorderSide(
                              color: AppColors.textFieldBorderColor,
                            ),
                          ),
                          SizeConfig.customSizedBox(null, 30, null),
                          Checkbox(
                            activeColor: AppColors.backgroundColor,
                            checkColor: AppColors.fontColor,
                            value: featuresProvider.userTypesAppearance[index]
                                ['user'],
                            onChanged: (bool? newValue) {
                              featuresProvider.toggleUserAppearance(index);
                            },
                            side: const BorderSide(
                              color: AppColors.textFieldBorderColor,
                            ),
                          ),
                          SizeConfig.customSizedBox(null, 30, null),
                          Checkbox(
                            activeColor: AppColors.backgroundColor,
                            checkColor: AppColors.fontColor,
                            value: featuresProvider.userTypesAppearance[index]
                                ['cooker'],
                            onChanged: (bool? newValue) {
                              featuresProvider.toggleCookerAppearance(index);
                            },
                            side: const BorderSide(
                              color: AppColors.textFieldBorderColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizeConfig.customSizedBox(null, 20, null),
                  Align(
                    alignment: Alignment.center,
                    child: CustomButton(
                      onTap: () async {
                        await FeaturesController()
                            .addFeature(featuresProvider, storageProvider, index);
                      },
                      text: 'confirm',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: SizeConfig.getProportionalWidth(200),
                        height: SizeConfig.getProportionalHeight(200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.widgetsColor,
                        ),
                        child: storageProvider.arFeatureImageIsPicked == false
                            ? null
                            : Image.memory(
                                storageProvider
                                    .arPickedFeatureImage!.files.first.bytes!,
                                fit: BoxFit.fill),
                      ),
                    ],
                  ),
                  SizeConfig.customSizedBox(null, 10, null),
                  IconButton(
                      onPressed: () => storageProvider.pickImage("ar_feature"),
                      icon: const Icon(Icons.camera_alt_outlined)),
                  SizeConfig.customSizedBox(null, 35, null),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: SizeConfig.getProportionalWidth(200),
                        height: SizeConfig.getProportionalHeight(200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.widgetsColor,
                        ),
                        child: storageProvider.enFeatureImageIsPicked == false
                            ? null
                            : Image.memory(
                                storageProvider
                                    .enPickedFeatureImage!.files.first.bytes!,
                                fit: BoxFit.fill),
                      ),
                    ],
                  ),
                  SizeConfig.customSizedBox(null, 10, null),
                  IconButton(
                      onPressed: () => storageProvider.pickImage("en_feature"),
                      icon: const Icon(Icons.camera_alt_outlined)),
                ],
              )
            ],
          ),
        ]));
  }

// @override
// Widget build(BuildContext context) {
//   return Padding(
//     padding: EdgeInsets.only(
//       bottom: SizeConfig.getProportionalHeight(15),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       textDirection: settingsProvider.language == "en"
//           ? TextDirection.ltr
//           : TextDirection.rtl,
//       children: [
//         Column(
//           children: [
//             Row(
//               textDirection: settingsProvider.language == "en"
//                   ? TextDirection.ltr
//                   : TextDirection.rtl,
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       width: SizeConfig.getProportionalWidth(200),
//                       height: SizeConfig.getProportionalHeight(200),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: AppColors.widgetsColor,
//                       ),
//                       child: storageProvider.arFeatureImageIsPicked == false
//                           ? null
//                           : Image.memory(
//                               storageProvider
//                                   .arPickedFeatureImage!.files.first.bytes!,
//                               fit: BoxFit.fill),
//                     ),
//                   ],
//                 ),
//                 SizeConfig.customSizedBox(10, null, null),
//                 const CustomText(
//                   isCenter: true,
//                   text: "active",
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                 ),
//                 SizeConfig.customSizedBox(10, null, null),
//                 Checkbox(
//                   activeColor: AppColors.backgroundColor,
//                   checkColor: AppColors.fontColor,
//                   value: featuresProvider.statuses[index]['active_feature'],
//                   onChanged: (bool? newValue) {
//                     featuresProvider.toggleActiveFeature(index);
//                   },
//                   side: const BorderSide(
//                     color: AppColors.textFieldBorderColor,
//                   ),
//                 ),
//                 CustomButton(
//                   onTap: () => storageProvider.pickImage("ar_feature"),
//                   icon: Icons.camera_alt_outlined,
//                   iconSize: 50,
//                   width: 50,
//                   height: 200,
//                 ),
//               ],
//             ),
//             SizeConfig.customSizedBox(null, 10, null),
//             CustomAppTextField(
//               width: 100,
//               height: 50,
//               icon: Assets.keyword,
//               controller: featuresProvider.featuresControllers[index],
//               maxLines: 1,
//               iconSizeFactor: 1,
//               settingsProvider: settingsProvider,
//               isCentered: true,
//               textAlign: TextAlign.left,
//             ),
//             SizeConfig.customSizedBox(null, 10, null),
//             Row(
//               textDirection: settingsProvider.language == "en"
//                   ? TextDirection.ltr
//                   : TextDirection.rtl,
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       width: SizeConfig.getProportionalWidth(200),
//                       height: SizeConfig.getProportionalHeight(200),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: AppColors.widgetsColor,
//                       ),
//                       child: storageProvider.enFeatureImageIsPicked == false
//                           ? null
//                           : Image.memory(
//                               storageProvider
//                                   .enPickedFeatureImage!.files.first.bytes!,
//                               fit: BoxFit.fill),
//                     ),
//                   ],
//                 ),
//                 SizeConfig.customSizedBox(10, null, null),
//                 const CustomText(
//                   isCenter: true,
//                   text: "premium",
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                 ),
//                 SizeConfig.customSizedBox(10, null, null),
//                 Checkbox(
//                   activeColor: AppColors.backgroundColor,
//                   checkColor: AppColors.fontColor,
//                   value: featuresProvider.statuses[index]['premium_feature'],
//                   onChanged: (bool? newValue) {
//                     featuresProvider.togglePremiumFeature(index);
//                   },
//                   side: const BorderSide(
//                     color: AppColors.textFieldBorderColor,
//                   ),
//                 ),
//                 SizeConfig.customSizedBox(10, null, null),
//                 CustomButton(
//                   onTap: () => storageProvider.pickImage("en_feature"),
//                   icon: Icons.camera_alt_outlined,
//                   iconSize: 50,
//                   width: 50,
//                   height: 200,
//                 ),
//               ],
//             ),
//           ],
//         ),
//         SizeConfig.customSizedBox(10, null, null),
//         Padding(
//           padding: EdgeInsets.symmetric(
//             vertical: SizeConfig.getProportionalHeight(215),
//           ),
//           child: CustomButton(
//             onTap: () async {
//               await FeaturesController()
//                   .addFeature(featuresProvider, storageProvider, index);
//             },
//             text: "confirm",
//             width: 50,
//             height: 50,
//           ),
//         ),
//       ],
//     ),
//   );
// }
}
