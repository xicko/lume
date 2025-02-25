import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/screens/sub_screens/edit_profile.dart';
import 'package:lume/screens/sub_screens/extend_profile_details.dart';
import 'package:lume/widgets/profile/bio.dart';
import 'package:lume/widgets/profile/essentials.dart';
import 'package:lume/widgets/profile/goal.dart';
import 'package:lume/widgets/profile_detail_box.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> onRefresh() async {
    ProfileController.to.fetchUserInfo();
  }

  void _openEditProfile() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: Offset(0, 1), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeInOut));
          var offsetAnim = animation.drive(tween);

          return SlideTransition(
            position: offsetAnim,
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return EditProfile();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            AnimatedOpacity(
              opacity:
                  ProfileController.to.isProfileDetailVisible.value ? 0 : 1,
              duration: Duration(milliseconds: 400),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  backgroundColor: Colors.white,
                  color: Colors.black87,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          spacing: 8,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      ProfileController.to
                                          .toggleProfileDetail();
                                    },
                                    overlayColor: WidgetStatePropertyAll(
                                        Colors.transparent),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 96, 157, 237),
                                            width: 4),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 5),
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        child: Obx(
                                          () => ClipOval(
                                            child: ProfileController
                                                    .to.userImages[0].isNotEmpty
                                                ? Image.memory(
                                                    BaseController.to
                                                        .convertImage(
                                                            ProfileController.to
                                                                .userImages[0]),
                                                    width: 120,
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'assets/avatar.png',
                                                    width: 120,
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 3,
                                            spreadRadius: 3,
                                          )
                                        ],
                                      ),
                                      child: IconButton(
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          _openEditProfile();
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${ProfileController.to.userName.value}, ${ProfileController.to.showOwnAge()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 18),

                        // Goal
                        Goal(),

                        // Bio
                        Bio(),

                        // Essentials
                        Essentials(),

                        // Interests
                        ProfileDetailBox(
                          color: Colors.grey[200],
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

                        // Spacer
                        SizedBox(height: 200),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Profile Detail Modal
            Visibility(
              visible: ProfileController.to.isProfileDetailVisible.value,
              child: AnimatedPositioned(
                top: ProfileController.to.isProfileDetailAnimTriggered.value
                    ? 2
                    : MediaQuery.of(context).size.height,
                bottom: BaseController.to.currentNavIndex.value == 4 ? 6 : 28,
                left: 12,
                right: 12,
                curve: Curves.easeInOutQuad,
                duration: Duration(milliseconds: 300),
                child: AnimatedOpacity(
                  opacity:
                      ProfileController.to.isProfileDetailAnimTriggered.value
                          ? 1
                          : 0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutQuad,
                  child: ExtendProfileDetails(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
