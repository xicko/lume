// Handles Both Likes & Removes

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:lume/controllers/feed_controller.dart';
import 'package:lume/controllers/matches_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SwipesController extends GetxController {
  static SwipesController get to => Get.find();

  // Hold fetched likes
  RxList<Map<String, dynamic>> fetchedLikes = <Map<String, dynamic>>[].obs;

  // Store only fetched profiles
  RxList<Map<String, dynamic>> fetchedLikeProfiles =
      <Map<String, dynamic>>[].obs;

  // Store likers profile pictures saved filepaths
  var likerProfileImages = <String, String>{}.obs;

  // Track if likes are not empty
  RxBool isLikesNotEmpty = false.obs;

  Rx<String> debounceKey = Rx<String>('');

  // Track if likes are refreshing currently
  RxBool isLikesRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();

    ever(fetchedLikeProfiles, (state) {
      isLikesNotEmpty.value = fetchedLikeProfiles.isNotEmpty;
    });

    // Remove from likes if already matched
    debounceKey.listen((value) {
      final matchUserIds =
          MatchesController.to.fetchedMatches.map((m) => m['user2_id']).toSet();
      fetchedLikeProfiles
          .removeWhere((profile) => matchUserIds.contains(profile['user_id']));
      fetchedLikeProfiles.refresh();
    });
  }

  // Method to like profile in feed cards
  Future<void> likeProfile(String targetId) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('lume_likes').insert({
        'user_id': AuthController.to.userId.value,
        'target_id': targetId,
        'liked_at': DateTime.now().toUtc().toIso8601String().toString(),
      });

      MatchesController.to.checkForMatch(targetId);
      debugPrint('profile liked');
    } catch (e) {
      debugPrint('Likes insert error: $e');
    }
  }

  // Method to remove profile in feed cards
  Future<void> removeProfile(String targetId) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('lume_removes').insert({
        'user_id': AuthController.to.userId.value,
        'target_id': targetId,
        'removed_at': DateTime.now().toUtc().toIso8601String().toString(),
      });
      debugPrint('profile removed');
    } catch (e) {
      debugPrint('Remove insert error: $e');
    }
  }

  // Fetch likes that user received
  Future<void> fetchLikes() async {
    final supabase = Supabase.instance.client;

    try {
      isLikesRefreshing.value = true;

      final res = await supabase
          .from('lume_likes')
          .select()
          .eq('target_id', AuthController.to.userId.value)
          .order('liked_at', ascending: false);

      fetchedLikes.assignAll(res);

      // Store likers ids
      List<String> userIds =
          res.map<String>((like) => like['user_id'] as String).toSet().toList();

      try {
        // Fetch all likers profile data, excluding urself
        final likerData = await supabase
            .from('lume_user_info')
            .select()
            .inFilter('user_id', userIds)
            .neq('user_id', AuthController.to.userId.value);

        fetchedLikeProfiles.assignAll(likerData);
        debugPrint('fetched all likers profile data');

        // Store pfp (only image1)
        Map<String, String> likerImageData = {};
        for (int i = 0; i < likerData.length; i++) {
          String base64 = likerData[i]['image1'];
          String userId = likerData[i]['user_id'];

          // Save image and return the file path
          String imagePath = await FeedController.to.saveBase64Image(
            base64,
            userId,
            imgFileName: 'image1',
          );

          // Add userId and imagePath to the map, {'id': 'path'}
          likerImageData[userId] = imagePath;
        }
        // Assign pfp data
        likerProfileImages.assignAll(likerImageData);

        // Remove from likes if already matched, if it works dont touch :p
        final matchUserIds = MatchesController.to.fetchedMatches
            .expand((m) => [m['user1_id'], m['user2_id']])
            .toSet();
        fetchedLikeProfiles.removeWhere(
            (profile) => matchUserIds.contains(profile['user_id']));
        fetchedLikeProfiles.refresh();
      } catch (e) {
        debugPrint('fetch all likers profile data error: $e');
      } finally {
        isLikesRefreshing.value = false;
      }
    } catch (e) {
      debugPrint('fetch likes error: $e');
    } finally {
      isLikesRefreshing.value = false;
    }
  }
}
