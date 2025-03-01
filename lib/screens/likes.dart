import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/swipes_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/widgets/refresh_button.dart';

class Likes extends StatefulWidget {
  const Likes({super.key});

  @override
  State<Likes> createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  Future<void> onRefresh() async {
    SwipesController.to.fetchLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Stack(
          children: [
            AnimatedOpacity(
              opacity: SwipesController.to.isLikesRefreshing.value ? 0 : 1,
              duration: Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring:
                    SwipesController.to.isLikesRefreshing.value ? true : false,
                child: Container(
                  child: SwipesController.to.isLikesNotEmpty.value
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: RefreshIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.black,
                            onRefresh: onRefresh,
                            child: GridView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: SwipesController
                                  .to.fetchedLikeProfiles.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.8,
                              ),
                              itemBuilder: (context, index) {
                                String userId = SwipesController
                                    .to.likerProfileImages.keys
                                    .elementAt(index);
                                String? filePath = SwipesController
                                        .to.likerProfileImages[userId] ??
                                    '';

                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: AspectRatio(
                                        aspectRatio: 0.8,
                                        child: ImageFiltered(
                                          imageFilter: ImageFilter.blur(
                                            sigmaX: 16,
                                            sigmaY: 16,
                                          ),
                                          child: SwipesController
                                                  .to
                                                  .fetchedLikeProfiles
                                                  .isNotEmpty
                                              ? Image.file(
                                                  File(filePath),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.4,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  'assets/avatar.png',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.4,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 100,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color.fromRGBO(0, 0, 0, 0),
                                              Color.fromRGBO(0, 0, 0, 0.8),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      left: 16,
                                      child: Column(
                                        spacing: 4,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            spacing: 8,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 48,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                  color: Colors.white30,
                                                  borderRadius:
                                                      BorderRadius.circular(99),
                                                ),
                                              ),
                                              Text(
                                                ProfileController.to.showAge(
                                                    userRawDate: SwipesController
                                                            .to
                                                            .fetchedLikeProfiles[
                                                        index]['birthdate']),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            spacing: 4,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons.search,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                ProfileController.to.showGoal(
                                                    user: SwipesController.to
                                                            .fetchedLikeProfiles[
                                                        index]['goal']),
                                                softWrap: true,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      : AnimatedOpacity(
                          opacity: SwipesController.to.isLikesRefreshing.value
                              ? 0
                              : 1,
                          duration: Duration(milliseconds: 200),
                          child: Center(
                            child: Column(
                              spacing: 16,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('No likes yet, but you can change that!'),
                                RefreshButton(
                                  onPressed: () =>
                                      SwipesController.to.fetchLikes(),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),

            // Loading indicator
            AnimatedOpacity(
              opacity: SwipesController.to.isLikesRefreshing.value ? 1 : 0,
              duration: Duration(milliseconds: 200),
              child: IgnorePointer(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
