import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lume/auth/auth_service.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedController extends GetxController {
  static FeedController get to => Get.find();

  // Store all fetched userdatas for feed cards
  RxList<Map<String, dynamic>?> feedProfiles =
      <Map<String, dynamic>?>[(null)].obs;

  // Holds images, Key: userId, Value: list of image paths
  var profileImages = <String, List<String>>{}.obs;

  // Track if cards are loading
  RxBool areCardsLoading = true.obs;

  RxBool isProfileDetailVisible = false.obs;
  RxBool isProfileDetailAnimTriggered = false.obs;
  RxInt currentCardIndex = 0.obs;

  // Currently fetches all users with no filtering (matches, removed, liked, age range, distance)
  Future<void> fetchFeed() async {
    final supabase = Supabase.instance.client;

    try {
      areCardsLoading.value = true;

      // Fetch feed with conditional filtering
      var query = supabase.from('lume_user_info').select();

      // Filter by gender settings if "men" or "women" is selected
      if (BaseController.to.showMe.value != 'everyone') {
        query = query.eq('gender', BaseController.to.showMe.value);
      }

      // Exclude urself and then fetch
      final res = await query.neq(
          'user_id', AuthService().getCurrentUserId().toString());

      if (res.isNotEmpty) {
        // Remove invalid profiles from response
        res.removeWhere((profile) =>
            profile['name'] == null ||
            profile['birthdate'] == null ||
            profile['lat'] == null ||
            profile['lng'] == null ||
            profile['image1'] == null ||
            profile['image2'] == null);

        // Calculate distance between user and the other person then add to list as int
        final resWithDistance = res.map((item) {
          if (item.isNotEmpty) {
            item['distance'] =
                calculateDistance(item['lat'], item['lng'], asInt: true);
          }
          return item;
        }).toList();

        // Store response to state
        feedProfiles.value = resWithDistance;
        debugPrint(feedProfiles.length.toString());

        // Decode and store images
        Map<String, List<String>> tempProfileImages = {};

        for (var profile in res) {
          String userId = profile['user_id'];
          List<String> images = [];

          for (int i = 1; i <= 9; i++) {
            String? base64Image = profile['image$i'];

            if (base64Image != null && base64Image.isNotEmpty) {
              String imagePath = await saveBase64Image(base64Image, userId,
                  index: i.toString());
              images.add(imagePath);
            }
          }

          // Store only non-empty images for this user
          tempProfileImages[userId] = images;
        }
        // Assign images to state
        profileImages.assignAll(tempProfileImages);
      }
      areCardsLoading.value = false;
    } catch (e) {
      debugPrint('Fetch error: $e');
    }
  }

  // Method to save base64 images to local app data and return the saved location as string
  Future<String> saveBase64Image(String base64String, String subDirectory,
      {String? index, String? imgFileName}) async {
    Uint8List bytes = base64Decode(base64String);

    // Get the temporary directory
    Directory tempDir = await getTemporaryDirectory();

    // Create a directory for the user if it doesn't exist
    Directory userDir = Directory('${tempDir.path}/$subDirectory');
    if (!await userDir.exists()) {
      await userDir.create(recursive: true); // Create the directory recursively
    }

    String filePath;

    // Define the file path for multiple images
    if (index != null) {
      // For multiple images
      filePath = '${userDir.path}/temp_image$index.png';
    } else {
      // For singular image
      filePath = '${userDir.path}/$imgFileName.png';
    }

    File file = File(filePath);

    // Write the bytes to the file
    await file.writeAsBytes(bytes);

    return filePath;
  }

  String calculateDistance(double targetLat, double targetLng, {bool? asInt}) {
    double userLatitude = ProfileController.to.userLat.value;
    double userLongitude = ProfileController.to.userLng.value;

    // Ensure the target lat/lng and user lat/lng are valid
    if (targetLat == 0.0 ||
        targetLng == 0.0 ||
        userLatitude == 0.0 ||
        userLongitude == 0.0) {
      debugPrint("Invalid coordinates");
      return 'Invalid Coordinates';
    }

    // Calculate the distance
    double distanceInMeters = Geolocator.distanceBetween(
      userLatitude,
      userLongitude,
      targetLat,
      targetLng,
    );

    double distanceInKm = distanceInMeters / 1000;

    if (distanceInKm < 1) {
      return 'Less than a kilometer away';
    }

    // debugPrint('a');

    if (asInt == true) {
      distanceInKm.toInt();
    }

    return '${distanceInKm.toString().split('.').first} km away';
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
