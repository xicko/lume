import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/feed_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/widgets/profile/bio.dart';
import 'package:lume/widgets/profile/goal.dart';
import 'package:lume/widgets/profile_detail_box.dart';

class ExtendProfileDetails extends StatefulWidget {
  const ExtendProfileDetails({super.key});

  @override
  State<ExtendProfileDetails> createState() => _ExtendProfileDetailsState();
}

class _ExtendProfileDetailsState extends State<ExtendProfileDetails> {
  late String userId;
  late List<String> images;

  RxInt imgIndex = 0.obs;

  @override
  void initState() {
    super.initState();

    // Initialize userId
    userId = FeedController.to.profileImages.keys
        .elementAt(FeedController.to.currentCardIndex.value);

    // Initialize images
    images = FeedController.to.profileImages[userId] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            color: Colors.grey[300],
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      Container(
                        color: Colors.black,
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: 0.8,
                          child: BaseController.to.currentNavIndex.value == 4
                              ? Image.memory(
                                  BaseController.to.convertImage(
                                      ProfileController
                                          .to.userImages[imgIndex.value]),
                                  fit: BoxFit.cover,
                                )
                              : images.isNotEmpty
                                  ? Image.file(
                                      File(images[imgIndex.value]),
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Text(
                                        'No photo',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                        ),
                      ),

                      // Gradient to bottom
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: List.generate(
                                20,
                                (index) {
                                  return Color.fromRGBO(
                                      224, 224, 224, index < 19 ? 0 : 1);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Photos index indicator
                      Positioned(
                        top: 0,
                        left: 4,
                        right: 4,
                        child: Row(
                          spacing: 4,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            images.length,
                            (index) => Container(
                              width: 24,
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(99),
                                  bottomRight: Radius.circular(99),
                                ),
                                color: imgIndex.value == index
                                    ? Colors.white
                                    : Colors.black26,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // name and age
                      Positioned(
                        bottom: 28,
                        left: 16,
                        child: Row(
                          spacing: 8,
                          children: [
                            Text(
                              BaseController.to.currentNavIndex.value == 4
                                  ? ProfileController.to.userName.value
                                  : FeedController.to.feedProfiles[
                                          FeedController.to.currentCardIndex
                                              .value]?['name'] ??
                                      '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                            ),
                            Text(
                              BaseController.to.currentNavIndex.value == 4
                                  ? ProfileController.to.showOwnAge()
                                  : ProfileController.to.showAge(
                                      feedIndex: FeedController
                                          .to.currentCardIndex.value),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                shadows: [
                                  Shadow(
                                    color: Colors.black87,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Picture switch bttns
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                overlayColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                onTap: () {
                                  if (imgIndex.value > 0) {
                                    setState(() {
                                      imgIndex = imgIndex--;
                                    });
                                    debugPrint('prevpic');
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                overlayColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                onTap: () {
                                  if (imgIndex.value < images.length - 1) {
                                    setState(() {
                                      imgIndex = imgIndex++;
                                    });
                                    debugPrint('nextpic');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Goals
                  Goal(),

                  // About me
                  Bio(),

                  // Essentials // not reused with own profile details
                  ProfileDetailBox(
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
                              (FeedController.to.feedProfiles[FeedController
                                          .to
                                          .currentCardIndex
                                          .value]?['lat'] as num?)
                                      ?.toDouble() ??
                                  0.0,
                              (FeedController.to.feedProfiles[FeedController
                                          .to
                                          .currentCardIndex
                                          .value]?['lng'] as num?)
                                      ?.toDouble() ??
                                  0.0,
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
                            FeedController.to.feedProfiles[FeedController.to
                                        .currentCardIndex.value]?['gender'] ==
                                    'male'
                                ? Icons.male
                                : Icons.female,
                            size: 20,
                            color: Colors.black,
                          ),
                          Text(
                            BaseController.to.currentNavIndex.value == 4
                                ? ProfileController.to.showGender(
                                    user: ProfileController.to.userGender.value)
                                : ProfileController.to.showGender(),
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

                      // Sex orientation
                      Row(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 20,
                            color: Colors.black,
                          ),
                          Text(
                            BaseController.to.currentNavIndex.value == 4
                                ? ProfileController.to.showOrientation(
                                    user: ProfileController
                                        .to.userSexOrientation.value)
                                : ProfileController.to.showOrientation(),
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

                      // Personality type
                      Row(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.psychology_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                          Text(
                            BaseController.to.currentNavIndex.value == 4
                                ? ProfileController.to.userPersonality.value
                                    .toUpperCase()
                                : FeedController
                                        .to
                                        .feedProfiles[FeedController
                                            .to
                                            .currentCardIndex
                                            .value]?['personality']
                                        .toString()
                                        .toUpperCase() ??
                                    '',
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

                  // Interests
                  ProfileDetailBox(
                    children: [
                      Row(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.interests_rounded,
                            size: 18,
                            color: Colors.grey[800],
                          ),
                          Text(
                            'Interests',
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
                              'N/A',
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
                  ),

                  SizedBox(height: 200),
                ],
              ),
            ),
          ),

          // Close modal button
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              onPressed: () {
                if (BaseController.to.currentNavIndex.value == 4) {
                  ProfileController.to.toggleProfileDetail();
                } else {
                  FeedController.to.toggleProfileDetail();
                }
              },
              iconSize: 24,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black45,
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor: Colors.black54,
              ),
              icon: Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
