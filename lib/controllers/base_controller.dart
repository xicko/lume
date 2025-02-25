import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:lume/controllers/feed_controller.dart';

class BaseController extends GetxController with WidgetsBindingObserver {
  static BaseController get to => Get.find();
  final GetStorage settingsStorage = GetStorage();

  // Track keyboard state
  RxBool isKeyboardVisible = false.obs;

  // Feed settings
  final Rx<RangeValues> ageRange = RangeValues(18, 25).obs;
  final RxInt maxDistance = 10.obs;
  final RxString showMe = 'everyone'.obs;

  // Nav
  RxInt currentNavIndex = 0.obs;
  PageController pageController = PageController();
  void changeNavIndex(int index) {
    currentNavIndex.value = index;
    // AuthController.to.reloadAuthState();
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);

    FeedController.to.isProfileDetailAnimTriggered.value = false;
    FeedController.to.isProfileDetailVisible.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    loadSettings();
  }

  @override
  void onClose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;

    isKeyboardVisible.value = bottomInset > 0;
  }

  void loadSettings() {
    maxDistance.value = settingsStorage.read('maxDistance') ?? 10;

    showMe.value = settingsStorage.read('showMe') ?? 'everyone';

    double start = settingsStorage.read('rangeStart') ?? 18.0;
    double end = settingsStorage.read('rangeEnd') ?? 25.0;
    ageRange.value = RangeValues(start, end);

    debugPrint('App settings loaded');
  }

  void updateMaxDistance(int value) {
    maxDistance.value = value;
    settingsStorage.write('maxDistance', value);
  }

  void updateAgeRange(RangeValues values) {
    ageRange.value = values;
    settingsStorage.write('rangeStart', values.start);
    settingsStorage.write('rangeEnd', values.end);
  }

  void updateShowMe(String value) {
    showMe.value = value;
    settingsStorage.write('showMe', value);
  }

  // Getx Snackbar
  void getSnackbar(String title, String message,
      {SnackPosition snackposition = SnackPosition.BOTTOM,
      bool dismissible = true,
      bool shadows = true,
      DismissDirection dismissDirection = DismissDirection.horizontal,
      EdgeInsets margin =
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      Duration duration = const Duration(seconds: 3),
      Duration animationDuration = const Duration(milliseconds: 600),
      Curve forward = Curves.easeInOut,
      Curve reverse = Curves.easeInOut,
      bool hideMessage = false}) {
    Get.snackbar(
      title,
      message,
      messageText: hideMessage ? SizedBox.shrink() : null,

      borderColor: Colors.transparent,
      borderWidth: 0,
      backgroundColor: Colors.black54,
      colorText: Colors.white,

      // Top by default
      snackPosition: snackposition,

      // Dismissible by default
      isDismissible: dismissible,

      // black12 by default
      boxShadows: [
        BoxShadow(
          offset: Offset(0, 4),
          color: shadows ? Colors.black26 : Colors.transparent,
          blurRadius: 12,
          spreadRadius: 4,
        )
      ],

      borderRadius: 6,

      // Horizontal by default
      dismissDirection: dismissDirection,

      margin: margin,

      duration: duration,
      animationDuration: animationDuration,

      forwardAnimationCurve: forward,
      reverseAnimationCurve: reverse,
    );
  }

  // Convert string base64 to Uint8List
  Uint8List convertImage(String base64) {
    if (base64.isNotEmpty) {
      final decoded = base64Decode(base64);
      return decoded;
    }
    // Return an empty list if newBase64 is empty
    return Uint8List(0);
  }
}
