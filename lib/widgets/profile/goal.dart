import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/feed_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/widgets/profile_detail_box.dart';

class Goal extends StatelessWidget {
  const Goal({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ProfileDetailBox(
        color: ProfileController.to.isProfileDetailVisible.value ||
                FeedController.to.isProfileDetailVisible.value
            ? Colors.white
            : const Color.fromRGBO(238, 238, 238, 1),
        children: [
          Row(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 18,
                color: Colors.grey[800],
              ),
              Text(
                'Looking for',
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
              Icon(
                Icons.celebration,
                size: 20,
                color: Colors.black,
              ),
              Text(
                BaseController.to.currentNavIndex.value == 4
                    ? ProfileController.to
                        .showGoal(user: ProfileController.to.userGoal.value)
                    : ProfileController.to.showGoal(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
