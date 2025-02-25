import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/feed_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/widgets/profile_detail_box.dart';

class Essentials extends StatelessWidget {
  const Essentials({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ProfileDetailBox(
        color: const Color.fromRGBO(238, 238, 238, 1),
        children: [
          Row(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 18,
                color: Colors.grey[800],
              ),
              Text(
                'Essentials',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          // Distance
          Row(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Colors.black,
              ),
              Text(
                FeedController.to.calculateDistance(
                  ProfileController.to.userLat.value,
                  ProfileController.to.userLng.value,
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
          ),

          // Gender
          Row(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                ProfileController.to.userGender.value == 'male'
                    ? Icons.male
                    : Icons.female,
                size: 20,
                color: Colors.black,
              ),
              Text(
                ProfileController.to
                    .showGender(user: ProfileController.to.userGender.value),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          ProfileController.to.userSexOrientation.value.isNotEmpty
              ? Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                )
              : SizedBox.shrink(),

          // Sex orientation
          ProfileController.to.userSexOrientation.value.isNotEmpty
              ? Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 20,
                      color: Colors.black,
                    ),
                    Text(
                      ProfileController.to.showOrientation(
                          user: ProfileController.to.userSexOrientation.value),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),

          ProfileController.to.userPersonality.value.isNotEmpty
              ? Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                )
              : SizedBox.shrink(),

          // Personality type
          ProfileController.to.userPersonality.value.isNotEmpty
              ? Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.psychology_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                    Text(
                      ProfileController.to.userPersonality.value.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
