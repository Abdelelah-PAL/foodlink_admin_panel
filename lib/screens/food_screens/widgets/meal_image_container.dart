import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/meals_provider.dart';
import '../../../services/translation_services.dart';
import "dart:html" as html;

class MealImageContainer extends StatefulWidget {
  const MealImageContainer({super.key});

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
            height: SizeConfig.getProperVerticalSpace(3),
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
          Positioned.fill(
            child: Center(
              child: GestureDetector(
                onTap: () async {
                    await mealsProvider.pickImage("meal");
                    if (mounted) setState(() {});
                   _openPicker();
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
              height: SizeConfig.getProperVerticalSpace(3),
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
                child: Image.memory(
                  mealsProvider.pickedFile!.files.first.bytes!,
                  fit: BoxFit.fill,
                )

            ),
        ],
      ),
    );
  }
  Future<void> uploadImage() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*'; // Allow only images
    input.click(); // Trigger file selection

    input.onChange.listen((event) async {
      if (input.files!.isNotEmpty) {
        final html.File file = input.files!.first;
        final String fileName = file.name;

        setState(() {
          isUploading = true;
        });

        try {
          // Create a Firebase Storage reference
          final storageRef = FirebaseStorage.instance
              .ref('planned_meals_images/$fileName'); // Specify your storage path
          print('meow');
          // Upload the file
          final uploadTask = storageRef.putBlob(file);
          print('meow2');
          // Wait for upload to complete
          final snapshot = await uploadTask.whenComplete(() {});
          print('meow3');

          // Get download URL
          final downloadUrl = await snapshot.ref.getDownloadURL();
          print('meow4');

          setState(() {
            isUploading = false;
            uploadedImageUrl = downloadUrl;
          });
          print('meow5');

        } catch (error) {
          setState(() {
            isUploading = false;
          });
          print('Upload failed: $error');
        }
      }
    });
  }

  void _openPicker() async {
    FilePickerResult? result;
     result = await FilePicker.platform.pickFiles(
      type: FileType.image
    );
    if(result != null) {
      Uint8List uploadFile = result.files.single.bytes!;
      String fileName = result.files.single.name;

      Reference reference = FirebaseStorage.instance
          .ref()
          .child("/planned_meals_images/$fileName");
      print('dasdsasdasd');

      final UploadTask uploadTask = reference.putData(uploadFile);
      await uploadTask;

      uploadTask.whenComplete(() => print('meow'));

      print('dasdsasdasd2');

    }
  }


}
