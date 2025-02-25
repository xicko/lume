import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/feed_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/widgets/profile_detail_box.dart';

class Bio extends StatelessWidget {
  const Bio({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ProfileController.to.userBio.value.isNotEmpty
          ? ProfileDetailBox(
              color: ProfileController.to.isProfileDetailVisible.value ||
                      FeedController.to.isProfileDetailVisible.value
                  ? Colors.white
                  : const Color.fromARGB(255, 238, 238, 238),
              children: [
                Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      size: 18,
                      color: Colors.grey[800],
                    ),
                    Text(
                      'About Me',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        BaseController.to.currentNavIndex.value == 4
                            ? ProfileController.to.userBio.value
                            : FeedController.to.feedProfiles[FeedController
                                    .to.currentCardIndex.value]?['bio'] ??
                                '',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : SizedBox.shrink(),
    );
  }
}
