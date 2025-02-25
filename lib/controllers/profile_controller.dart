import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:lume/controllers/feed_controller.dart';
import 'package:lume/controllers/profile_setup_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  // Current user info
  RxString userName = ''.obs;
  RxString userBio = ''.obs;
  RxString userGender = ''.obs;
  RxString userBirthdate = ''.obs;
  RxString userPersonality = ''.obs;
  RxString userSexOrientation = ''.obs;
  RxString userGoal = ''.obs;
  RxDouble userLat = 0.0.obs;
  RxDouble userLng = 0.0.obs;
  RxList<String> userImages = <String>[].obs;

  // Profile Details Modal
  RxBool isProfileDetailVisible = false.obs;
  RxBool isProfileDetailAnimTriggered = false.obs;

  @override
  void onInit() async {
    super.onInit();

    await Future.delayed(Duration(milliseconds: 30));
    await fetchUserInfo();
  }

  void clearAllUserInfo() {
    userName.value = '';
    userBio.value = '';
    userGender.value = '';
    userBirthdate.value = '';
    userSexOrientation.value = '';
    userPersonality.value = '';
    userGoal.value = '';
    userLat.value = 0.0;
    userLng.value = 0.0;
  }

  Future<void> fetchUserInfo() async {
    final supabase = Supabase.instance.client;

    try {
      ProfileSetupController.to.isLoading.value = true;

      final res = await supabase
          .from('lume_user_info')
          .select()
          .eq('user_id', AuthController.to.userId.value)
          .maybeSingle();

      await Future.delayed(Duration(milliseconds: 20));

      List<String> tempProfileImages = [];

      if (res != null) {
        userName.value = res['name'] ?? '';
        userBio.value = res['bio'] ?? '';
        userGender.value = res['gender'] ?? '';
        userBirthdate.value = res['birthdate'] ?? '';
        userSexOrientation.value = res['sexorientation'] ?? '';
        userPersonality.value = res['personality'] ?? '';
        userGoal.value = res['goal'] ?? '';
        userLat.value = res['lat'] ?? 0.0;
        userLng.value = res['lng'] ?? 0.0;

        for (int i = 1; i <= 9; i++) {
          String? base64 = res['image$i'];

          if (base64 != null && base64.isNotEmpty) {
            tempProfileImages.add(base64);
          }
        }

        userImages.assignAll(tempProfileImages);

        debugPrint('fetched own user info');
      } else {
        clearAllUserInfo();
      }

      debugPrint('Profile info fetched');

      await Future.delayed(Duration(milliseconds: 20));

      ProfileSetupController.to.isLoading.value = false;
    } catch (e) {
      debugPrint('Fetch user info error: $e');
    } finally {
      ProfileSetupController.to.isLoading.value = false;
    }
  }

  Future<void> updateLocation() async {
    if (await Permission.location.isGranted) {
      final supabase = Supabase.instance.client;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      try {
        await supabase.from('lume_user_info').upsert({
          'lat': position.latitude,
          'lng': position.longitude,
        }).eq('user_id', AuthController.to.userId.value);
        debugPrint('Location updated');
      } catch (e) {
        debugPrint('$e');
      }
    } else if (await Permission.location.isDenied) {
      await Permission.location.request();
    } else if (await Permission.location.isPermanentlyDenied) {
      debugPrint('location pernamently denied');
    }
  }

  String showOrientation({String? user}) {
    final userOrientation = user ??
        FeedController.to.feedProfiles[FeedController.to.currentCardIndex.value]
            ?['sexorientation'];

    if (userOrientation == 'straight') {
      return 'Straight';
    } else if (userOrientation == 'gay') {
      return 'Gay';
    } else if (userOrientation == 'lesbian') {
      return 'Lesbian';
    }

    return '';
  }

  String showGender({String? user}) {
    final userGender = user ??
        FeedController.to.feedProfiles[FeedController.to.currentCardIndex.value]
            ?['gender'];

    if (userGender == 'male') {
      return 'Male';
    } else if (userGender == 'female') {
      return 'Female';
    }
    return '';
  }

  String showGoal({String? user}) {
    final userGoal = user ??
        FeedController.to.feedProfiles[FeedController.to.currentCardIndex.value]
            ?['goal'];

    if (userGoal == 'longterm') {
      return 'Long-term partner';
    } else if (userGoal == 'shortterm') {
      return 'Short-term fun';
    } else if (userGoal == 'opentoshort') {
      return 'Long-term, open to short';
    } else if (userGoal == 'opentolong') {
      return 'Short-term, open to long';
    } else if (userGoal == 'newfriends') {
      return 'New Friends';
    } else if (userGoal == 'figuringout') {
      return 'Still figuring out';
    }

    return '';
  }

  // Display user age
  String showAge({int? feedIndex, String? userRawDate}) {
    // If feedindex is given (for using in lists)
    if (feedIndex != null) {
      final String rawDate =
          FeedController.to.feedProfiles[feedIndex]?['birthdate'];

      final DateTime converted = DateTime.parse(rawDate).toLocal();
      if (FeedController.to.feedProfiles[feedIndex]?['birthdate'] != null) {
        final now = DateTime.now();
        final subtracted = DateTime(now.year - converted.year,
            now.month - converted.month, now.day - converted.day);

        final formatted = DateFormat.y().format(subtracted);

        return formatted;
      }
    }

    // If custom rawdate string is given
    if (userRawDate != null) {
      final String rawDate = userRawDate;

      final DateTime converted = DateTime.parse(rawDate).toLocal();

      final now = DateTime.now();
      final subtracted = DateTime(now.year - converted.year,
          now.month - converted.month, now.day - converted.day);

      final formatted = DateFormat.y().format(subtracted);

      return formatted;
    }

    return '';
  }

  // Display own age
  String showOwnAge() {
    final String rawDate = ProfileController.to.userBirthdate.value;
    final DateTime converted = DateTime.parse(rawDate).toLocal();

    if (rawDate.isNotEmpty) {
      final now = DateTime.now();
      final subtracted = DateTime(now.year - converted.year,
          now.month - converted.month, now.day - converted.day);

      final formatted = DateFormat.y().format(subtracted);

      return formatted;
    }

    return '';
  }

  void toggleProfileDetail({int? index}) async {
    if (index != null) {
      FeedController.to.currentCardIndex.value = index;
    }
    await Future.delayed(Duration(milliseconds: 20));
    if (!isProfileDetailVisible.value) {
      // Open
      isProfileDetailVisible.value = true;
      await Future.delayed(Duration(milliseconds: 150));
      isProfileDetailAnimTriggered.value = true;
    } else {
      // Close
      isProfileDetailAnimTriggered.value = false;
      await Future.delayed(Duration(milliseconds: 300));
      isProfileDetailVisible.value = false;
    }
  }
}
