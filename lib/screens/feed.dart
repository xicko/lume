import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/feed_controller.dart';
import 'package:lume/controllers/swipes_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/screens/sub_screens/extend_profile_details.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final CardSwiperController swiperController = CardSwiperController();

  RxInt imgIndex = 0.obs;

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );

    if (direction == CardSwiperDirection.left ||
        direction == CardSwiperDirection.bottom) {
      // Remove
      debugPrint('remove');
    } else if (direction == CardSwiperDirection.right ||
        direction == CardSwiperDirection.top) {
      // Like
      SwipesController.to.likeProfile(
          FeedController.to.feedProfiles[previousIndex]?['user_id']);
      debugPrint('like $previousIndex');
    }

    imgIndex.value = 0;

    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if (FeedController.to.feedProfiles.isEmpty ||
              FeedController.to.feedProfiles == []) {
            return Center(
              child: Text('No people found in your area'),
            );
          } else {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: SizedBox.expand(
                    child: Visibility(
                      visible: FeedController.to.areCardsLoading.value
                          ? false
                          : true,
                      child: CardSwiper(
                        controller: swiperController,
                        onSwipe: _onSwipe,
                        onEnd: () {
                          debugPrint('bro is done for');
                          FeedController.to.fetchFeed();
                        },
                        isLoop: false,
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 4,
                          bottom: 28,
                        ),
                        cardsCount: FeedController.to.feedProfiles.length,
                        cardBuilder: (context, index, percentThresholdX,
                            percentThresholdY) {
                          String userId = FeedController.to.profileImages.keys
                              .elementAt(index);
                          List<String> images =
                              FeedController.to.profileImages[userId] ?? [];

                          // Target user location
                          // double targetLat = (FeedController.to.feedProfiles[index]?['lat'] as num?)?.toDouble() ?? 0.0;
                          // double targetLng = (FeedController.to.feedProfiles[index]?['lng'] as num?)?.toDouble() ?? 0.0;

                          String distance = FeedController
                              .to.feedProfiles[index]?['distance'];

                          return Stack(
                            children: [
                              // Images
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                      offset: Offset(0, 4),
                                      color: Colors.black12,
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox.expand(
                                    child: images.isNotEmpty
                                        ? Obx(
                                            () => Image.file(
                                              File(images[imgIndex.value]),
                                              fit: BoxFit.cover,
                                            ),
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
                              ),

                              // Gradient overlay
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withAlpha(0),
                                      Colors.black.withAlpha(30),
                                      Colors.black.withAlpha(90),
                                      Colors.black.withAlpha(240),
                                    ],
                                  ),
                                ),
                              ),

                              // Texts
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 54),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name and Age
                                    Row(
                                      spacing: 8,
                                      children: [
                                        Text(
                                          FeedController.to.feedProfiles[index]
                                                  ?['name'] ??
                                              '',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          ProfileController.to
                                              .showAge(feedIndex: index),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Distance
                                    Row(
                                      spacing: 3,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        Text(
                                          distance,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Bio
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            FeedController
                                                        .to.feedProfiles[index]
                                                    ?['bio'] ??
                                                '',
                                            maxLines: 3,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),

                                        // Space to avoid button
                                        SizedBox(width: 48),
                                      ],
                                    ),
                                  ],
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

                              // Picture switch bttns
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        overlayColor: WidgetStateProperty.all(
                                            Colors.transparent),
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
                                        overlayColor: WidgetStateProperty.all(
                                            Colors.transparent),
                                        onTap: () {
                                          if (imgIndex.value <
                                              images.length - 1) {
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

                              // Open Profile Detail Button
                              Positioned(
                                bottom: 64,
                                right: 24,
                                child: IconButton(
                                  onPressed: () => FeedController.to
                                      .toggleProfileDetail(index: index),
                                  iconSize: 28,
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.black38,
                                    foregroundColor: Colors.white,
                                    elevation: 3,
                                    shadowColor: Colors.black54,
                                  ),
                                  icon: Icon(Icons.keyboard_arrow_up_rounded),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (FeedController.to.areCardsLoading.value)
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),

                // Hide background cards
                AnimatedPositioned(
                  top: FeedController.to.isProfileDetailAnimTriggered.value
                      ? MediaQuery.of(context).size.height / 1.4
                      : MediaQuery.of(context).size.height,
                  bottom: 0,
                  left: 12,
                  right: 12,
                  duration: Duration(milliseconds: 300),
                  child: Container(color: Colors.white),
                ),

                // Profile Detail Modal
                Visibility(
                  visible: FeedController.to.isProfileDetailVisible.value,
                  child: AnimatedPositioned(
                    top: FeedController.to.isProfileDetailAnimTriggered.value
                        ? 2
                        : MediaQuery.of(context).size.height,
                    bottom: 28,
                    left: 12,
                    right: 12,
                    curve: Curves.easeInOutQuad,
                    duration: Duration(milliseconds: 300),
                    child: AnimatedOpacity(
                      opacity:
                          FeedController.to.isProfileDetailAnimTriggered.value
                              ? 1
                              : 0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOutQuad,
                      child: ExtendProfileDetails(),
                    ),
                  ),
                ),

                // Bottom card buttons
                Positioned(
                  bottom: 4,
                  left: 54,
                  right: 54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () async {
                          // Delayed remove if profile detail modal is visible
                          if (FeedController.to.isProfileDetailVisible.value) {
                            FeedController.to.toggleProfileDetail();
                            await Future.delayed(Duration(milliseconds: 500));
                          }
                          swiperController.swipe(CardSwiperDirection.left);
                        },
                        iconSize: 36,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: Colors.black54,
                        ),
                        icon: SizedBox(
                          width: 36,
                          height: 36,
                          child: Image.asset('assets/remove.png'),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          BaseController.to.getSnackbar('Not implemented', '',
                              hideMessage: true);
                        },
                        iconSize: 24,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: Colors.black54,
                        ),
                        icon: Icon(Icons.refresh_rounded),
                      ),
                      IconButton(
                        onPressed: () async {
                          // Delayed like if profile detail modal is visible
                          if (FeedController.to.isProfileDetailVisible.value) {
                            FeedController.to.toggleProfileDetail();
                            await Future.delayed(Duration(milliseconds: 500));
                          }
                          swiperController.swipe(CardSwiperDirection.right);
                        },
                        iconSize: 36,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: Colors.black54,
                        ),
                        icon: SizedBox(
                          width: 36,
                          height: 36,
                          child: Image.asset('assets/lumetransparent.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
