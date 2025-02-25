import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/feed_controller.dart';
import 'package:lume/controllers/swipes_controller.dart';
import 'package:lume/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchesController extends GetxController {
  static MatchesController get to => Get.find();

  // Store Fetched Matches
  RxList<Map<String, dynamic>> fetchedMatches = <Map<String, dynamic>>[].obs;

  // Store Fetched Matches Profile Data
  RxList<Map<String, dynamic>> fetchedMatchProfiles =
      <Map<String, dynamic>>[].obs;

  // Store matches profile pictures saved filepaths
  var matchProfileImages = <String, String>{}.obs;

  // Track if matches are not empty
  RxBool isMatchesNotEmpty = false.obs;

  // Track if matches are refreshing currently
  RxBool isMatchesRefreshing = false.obs;

  Rx<String> debounceKey = Rx<String>('');

  @override
  void onInit() {
    super.onInit();

    ever(fetchedMatchProfiles, (state) {
      isMatchesNotEmpty.value = fetchedMatchProfiles.isNotEmpty;
    });

    // Debouncing logic
    ever(fetchedMatches, (_) {
      debounceKey.value = DateTime.now().toString(); // trigger debounce
    });
  }

  Future<void> fetchMatches() async {
    final supabase = Supabase.instance.client;
    final userId = AuthController.to.userId.value;

    try {
      isMatchesRefreshing.value = true;

      final res = await supabase
          .from('lume_matches')
          .select()
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .order('matched_at', ascending: false);

      fetchedMatches.assignAll(res);
      debugPrint('fetched matches');

      // Store matches userids in string array, adds from both id columns
      List<String> userIds = res
          .expand<String>((like) =>
              [like['user1_id'] as String, like['user2_id'] as String])
          .toSet()
          .toList();

      // Remove yourself from ids
      userIds.remove(userId);

      try {
        // fetch all matches profile data, excluding urself
        final response = await supabase
            .from('lume_user_info')
            .select()
            .inFilter('user_id', userIds)
            .neq('user_id', userId);

        // Store pfp (only image1)
        Map<String, String> matchImageData = {};
        for (int i = 0; i < response.length; i++) {
          String base64 = response[i]['image1'];
          String userId = response[i]['user_id'];

          // Save image and return the file path
          String imagePath = await FeedController.to.saveBase64Image(
            base64,
            userId,
            imgFileName: 'image$i',
          );

          // Add userId and imagePath to the map
          matchImageData[userId] = imagePath;
        }

        // Assign pfp data
        matchProfileImages.assignAll(matchImageData);

        if (response.isNotEmpty) {
          fetchedMatchProfiles.assignAll(response);
          fetchedMatchProfiles.refresh();
        } else {
          fetchedMatchProfiles.clear();
          fetchedMatchProfiles.refresh();
        }

        debugPrint('fetched all matches profile data');
      } catch (e) {
        debugPrint('fetch all matches profile data error: $e');
      } finally {
        isMatchesRefreshing.value = false;
      }
    } catch (e) {
      debugPrint('fetchmatch error: $e');
    } finally {
      isMatchesRefreshing.value = false;
    }
  }

  // One who likes back creates the row in matches table
  // Check for match after liking a profile
  Future<void> checkForMatch(String targetId) async {
    final supabase = Supabase.instance.client;
    final userId = AuthController.to.userId.value;

    try {
      final res = await supabase
          .from('lume_likes')
          .select()
          .eq('user_id', targetId)
          .eq('target_id', userId)
          .maybeSingle();

      debugPrint(res.toString());
      if (res != null) {
        try {
          await supabase.from('lume_matches').insert({
            'user1_id': userId,
            'user2_id': targetId,
          });
          SwipesController.to.fetchedLikeProfiles.refresh();

          // Play matched! anim
          baseScreenKey.currentState?.triggerMatchAnimPlay();

          BaseController.to.getSnackbar(
              'Matched!', 'Don\'t leave them hanging!, send a message',
              duration: Duration(seconds: 5));

          debugPrint('matched! added row to matches db');

          // Fetch matches and likes
          SwipesController.to.fetchLikes();
          fetchMatches();
        } catch (e) {
          debugPrint('match insert error: $e');
        }
      }

      debugPrint('checked for match');
    } catch (e) {
      debugPrint('checkformatch error: $e');
    }
  }

  Future<void> unmatchProfile(String targetId) async {
    final supabase = Supabase.instance.client;
    final userId = AuthController.to.userId.value;

    try {
      final res = await supabase
          .from('lume_matches')
          .delete()
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .or('user1_id.eq.$targetId,user2_id.eq.$targetId')
          .select();

      // Delete from likes from both sides
      final deleteOwn = await supabase
          .from('lume_likes')
          .delete()
          .eq('user_id', userId)
          .eq('target_id', targetId)
          .select();
      final deleteFromOther = await supabase
          .from('lume_likes')
          .delete()
          .eq('target_id', userId)
          .eq('user_id', targetId)
          .select();

      if (res.isEmpty && deleteOwn.isEmpty && deleteFromOther.isEmpty) {
        debugPrint('unmatch successful');
        fetchedMatchProfiles.clear;
        fetchMatches();
        fetchedMatchProfiles.refresh();
      }
    } catch (e) {
      debugPrint('unmatch error: $e');
    }
  }
}
