import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileController extends GetxController {
  static EditProfileController get to => Get.find();

  TextEditingController bioEditController = TextEditingController();

  RxString editName = ''.obs;
  RxString editBio = ''.obs;
  RxString editGender = ''.obs;
  RxString editBirthdate = ''.obs;
  RxString editPersonality = ''.obs;
  RxString editSexOrientation = ''.obs;
  RxString editGoal = ''.obs;
  RxDouble editLat = 0.0.obs;
  RxDouble editLng = 0.0.obs;

  List<RxString> images = List.generate(9, (_) => ''.obs);

  @override
  void onClose() {
    bioEditController.dispose();

    super.onClose();
  }

  Future<void> updateProfileInfo() async {
    final supabase = Supabase.instance.client;

    // Reword images upload cuz this shit aint working and is horrible code
    try {
      for (int i = 0; i <= 8; i++) {
        if (images[i].value.isNotEmpty) {
          await supabase.from('lume_user_info').upsert({
            'bio': bioEditController.text,
            'gender': editGender.value,
            'goal': editGoal.value,
            'image${i + 1}': images[i].value,
          });
        }
      }

      debugPrint('Profile info updated');

      await Future.delayed(Duration(milliseconds: 10));
      ProfileController.to.fetchUserInfo();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Set current profile data for displaying in edit profile screen
  void setEditProfileDetails() {
    bioEditController.text = ProfileController.to.userBio.value;

    editName.value = ProfileController.to.userName.value;
    editBio.value = ProfileController.to.userBio.value;
    editGender.value = ProfileController.to.userGender.value;
    editBirthdate.value = ProfileController.to.userBirthdate.value;
    editSexOrientation.value = ProfileController.to.userSexOrientation.value;
    editPersonality.value = ProfileController.to.userPersonality.value;
    editGoal.value = ProfileController.to.userGoal.value;
    editLat.value = ProfileController.to.userLat.value;
    editLng.value = ProfileController.to.userLng.value;

    for (int i = 0; i <= 8; i++) {
      if (i < ProfileController.to.userImages.length) {
        images[i].value = ProfileController.to.userImages[i];
      } else {
        images[i].value = '';
      }
    }
  }

  Future<void> pickImg({int? index}) async {
    // final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    final androidInfo = await DeviceInfoPlugin().androidInfo;

    final ImagePicker picker = ImagePicker();

    if (await Permission.photos.isGranted ||
        await Permission.storage.isGranted) {
      final XFile? pickedImg =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedImg != null) {
        CroppedFile? croppedImg = await ImageCropper().cropImage(
          sourcePath: pickedImg.path,
          maxHeight: 1280,
          maxWidth: 1280,
          compressQuality: 90,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: CropAspectRatioPreset.original,
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.square,
              ],
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.black,
              statusBarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: Color.fromARGB(255, 69, 128, 167),
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: 'Crop Image',
            ),
          ],
        );

        if (croppedImg != null) {
          List<int> imageBytes = await croppedImg.readAsBytes();
          String base64 = base64Encode(imageBytes);

          for (int i = 1; i <= 9; i++) {
            if (index == i) {
              images[i - 1].value = base64;
            }
          }
        }
      }
    } else if (await Permission.photos.isDenied ||
        await Permission.storage.isDenied) {
      if (androidInfo.version.sdkInt >= 33) {
        await Permission.photos.request();
        final XFile? pickedImg =
            await picker.pickImage(source: ImageSource.gallery);

        if (pickedImg != null) {
          CroppedFile? croppedImg = await ImageCropper().cropImage(
            sourcePath: pickedImg.path,
            maxHeight: 1280,
            maxWidth: 1280,
            compressQuality: 90,
            uiSettings: [
              AndroidUiSettings(
                initAspectRatio: CropAspectRatioPreset.square,
                aspectRatioPresets: [
                  CropAspectRatioPreset.ratio16x9,
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.square,
                ],
                toolbarTitle: 'Crop Image',
                toolbarColor: Colors.black,
                statusBarColor: Colors.black,
                toolbarWidgetColor: Colors.white,
                activeControlsWidgetColor: Color.fromARGB(255, 69, 128, 167),
                lockAspectRatio: false,
              ),
              IOSUiSettings(
                title: 'Crop Image',
              ),
            ],
          );

          if (croppedImg != null) {
            List<int> imageBytes = await croppedImg.readAsBytes();
            String base64 = base64Encode(imageBytes);

            for (int i = 1; i <= 9; i++) {
              if (index == i) {
                images[i - 1].value = base64;
              }
            }
          }
        }
      } else if (androidInfo.version.sdkInt <= 32) {
        await Permission.storage.request();
        final XFile? pickedImg =
            await picker.pickImage(source: ImageSource.gallery);

        if (pickedImg != null) {
          CroppedFile? croppedImg = await ImageCropper().cropImage(
            sourcePath: pickedImg.path,
            maxHeight: 1280,
            maxWidth: 1280,
            compressQuality: 90,
            uiSettings: [
              AndroidUiSettings(
                initAspectRatio: CropAspectRatioPreset.square,
                aspectRatioPresets: [
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.square,
                ],
                toolbarTitle: 'Crop Image',
                toolbarColor: Colors.black,
                statusBarColor: Colors.black,
                toolbarWidgetColor: Colors.white,
                activeControlsWidgetColor: Color.fromARGB(255, 69, 128, 167),
                lockAspectRatio: true,
              ),
              IOSUiSettings(
                title: 'Crop Image',
              ),
            ],
          );

          if (croppedImg != null) {
            List<int> imageBytes = await croppedImg.readAsBytes();
            String base64 = base64Encode(imageBytes);

            for (int i = 1; i <= 9; i++) {
              if (index == i) {
                images[i - 1].value = base64;
              }
            }
          }
        }
      }
    }
  }
}
