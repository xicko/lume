import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Convert to strings when inserting to db
enum Gender {
  everyone,
  male,
  female,
}

enum Goals {
  longterm,
  shortterm,
  opentoshort,
  opentolong,
  newfriends,
  figuringout,
}

class ProfileSetupController extends GetxController {
  static ProfileSetupController get to => Get.find();

  RxBool isProfileSet = false.obs;

  RxBool isLoading = true.obs;

  PageController pageController = PageController(viewportFraction: 1);

  // User Basics
  TextEditingController nameController = TextEditingController();
  RxBool isNameNotEmpty = false.obs;
  RxString selectedDate = ''.obs; // Birthday raw
  Rx<DateTime?> selectedDTDate = Rx<DateTime?>(null);
  Rx<Gender?> selectedGender = Rx<Gender?>(null);

  // More Info (Skippable)
  TextEditingController bioController = TextEditingController();
  RxBool isBioNotEmpty = false.obs;
  Rx<String?> selectedPersonality = Rx<String?>(null);
  Rx<String?> selectedSexOrientation = Rx<String?>(null);

  // Image upload
  RxString image1 = ''.obs;
  RxString image2 = ''.obs;

  // Relationship Goal
  Rx<Goals?> selectedGoal = Rx<Goals?>(null);

  @override
  void onInit() {
    super.onInit();

    nameController.addListener(() {
      isNameNotEmpty.value = nameController.text.isNotEmpty;
    });

    bioController.addListener(() {
      isBioNotEmpty.value = bioController.text.isNotEmpty;
    });
  }

  void toPage(int index) {
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  // On profile setup finish
  Future<void> finishSetup() async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('lume_user_info').upsert({
        'created_at': DateTime.now().toUtc().toIso8601String().toString(),
        'updated_at': DateTime.now().toUtc().toIso8601String().toString(),
        'name': nameController.text,
        'gender': selectedGender.value.toString().split('.').last,
        'birthdate': selectedDate.value,
        'bio': bioController.text,
        'personality': selectedPersonality.value,
        'sexorientation': selectedSexOrientation.value,
        'goal': selectedGoal.value.toString().split('.').last,
        'image1': image1.value,
        'image2': image2.value,
      });

      await Future.delayed(Duration(milliseconds: 20));

      ProfileController.to.fetchUserInfo();

      await Future.delayed(Duration(milliseconds: 20));

      // Clear all setup inputs and states after successful setup
      clearSetup();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> pickImgs() async {
    if (await Permission.photos.isGranted ||
        await Permission.storage.isGranted) {
      final pickedImg = await ImagePicker().pickMultiImage(limit: 2);

      if (pickedImg.isNotEmpty) {
        final croppedImg1 = await ImageCropper().cropImage(
          sourcePath: pickedImg[0].path,
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
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Crop Image',
            ),
          ],
        );

        if (croppedImg1 != null) {
          List<int> base64 = await croppedImg1.readAsBytes();
          image1.value = base64Encode(base64);
        }

        Future.delayed(Duration(milliseconds: 600));
        final croppedImg2 = await ImageCropper().cropImage(
          sourcePath: pickedImg[1].path,
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

        if (croppedImg2 != null) {
          List<int> base64 = await croppedImg2.readAsBytes();
          image2.value = base64Encode(base64);
        }
      }
    } else if (await Permission.photos.isDenied ||
        await Permission.storage.isDenied) {
      debugPrint('photos perm denied');
    }
  }

  void clearSetup() {
    // User Basics
    nameController.clear();
    selectedDate.value = '';
    selectedDTDate.value = null;
    selectedGender.value = null;

    // More Info (Skippable)
    bioController.clear();
    selectedPersonality.value = null;
    selectedSexOrientation.value = null;

    // Image upload
    image1.value = '';
    image2.value = '';

    // Relationship Goal
    selectedGoal.value = null;
  }
}
