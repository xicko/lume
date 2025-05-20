import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lume/controllers/feed_controller.dart';
import 'package:http/http.dart' as http;
import 'package:lume/controllers/matches_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/controllers/swipes_controller.dart';

class BaseController extends GetxController with WidgetsBindingObserver {
  static BaseController get to => Get.find();
  final GetStorage settingsStorage = GetStorage();

  // Network status
  RxBool hasNetwork = true.obs;
  RxList<ConnectivityResult> connectionStatus = [ConnectivityResult.none].obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

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
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);

    FeedController.to.isProfileDetailAnimTriggered.value = false;
    FeedController.to.isProfileDetailVisible.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    // Network check
    initConnectivity();

    // Network listener
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result != connectionStatus) {
        updateConnectionStatus(result);
      }
    });

    // Load app settings
    loadSettings();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
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

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> res;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      res = await _connectivity.checkConnectivity();
      debugPrint('checked connectivity status');
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status $e');
      return;
    }

    connectionStatus.value = res;
  }

  Future<void> updateConnectionStatus(List<ConnectivityResult> result) async {
    connectionStatus.value = result;

    currentNavIndex.value = 0;

    if (connectionStatus.contains(ConnectivityResult.wifi) ||
        connectionStatus.contains(ConnectivityResult.mobile) ||
        connectionStatus.contains(ConnectivityResult.ethernet) ||
        connectionStatus.contains(ConnectivityResult.vpn)) {
      // Check internet with http request
      hasNetwork.value = await checkInternet();
    } else {
      hasNetwork.value = false;
    }

    debugPrint('Connectivity changed: $connectionStatus');
  }

  // HTTP Request to check actual internet connectivity
  Future<bool> checkInternet() async {
    try {
      final res = await http
          .get(Uri.parse('http://www.google.com'))
          .timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        debugPrint("Internet check: Success");

        // Manually fetch everything when network comes
        // These are usually auto fetched at app startup
        manualFetchAll();
        // TODO
        // Causing double fetch if user already had connection upon opening app, will fix later

        return true;
      } else {
        debugPrint("Internet check: Failed - Status Code: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Internet check: Error - $e");
      return false;
    }
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

  void manualFetchAll() async {
    await ProfileController.to.fetchUserInfo();
    FeedController.to.fetchFeed();
    SwipesController.to.fetchLikes();
    MatchesController.to.fetchMatches();
    ProfileController.to.updateLocation();
  }
}
