import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/bottom_nav_bar.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/controllers/profile_setup_controller.dart';
import 'package:lume/screens/auth_screen.dart';
import 'package:lume/screens/chats.dart';
import 'package:lume/screens/discover.dart';
import 'package:lume/screens/feed.dart';
import 'package:lume/screens/likes.dart';
import 'package:lume/screens/profile.dart';
import 'package:lume/screens/sub_screens/profile_setup.dart';
import 'package:lume/widgets/simple_appbar.dart';
import 'package:rive/rive.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  // Matched anim
  late RiveAnimationController matchAnimController;

  /// Tracks if the animation is playing by whether controller is running
  RxBool isMatchAnimPlaying = false.obs;

  // Toggles anim
  void triggerMatchAnimPlay() async {
    isMatchAnimPlaying.value = true;

    setState(() {
      matchAnimController.isActive = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      matchAnimController.isActive = false;
    });

    isMatchAnimPlaying.value = false;
  }

  @override
  void initState() {
    super.initState();

    // Initialize auth listener
    AuthController.to.initAuth();

    // Consider profile set if userName is not empty
    ever((ProfileController.to.userName), (state) {
      ProfileSetupController.to.isProfileSet.value =
          ProfileController.to.userName.value.isNotEmpty;
    });

    matchAnimController = OneShotAnimation(
      'match',
      autoplay: false,
      onStop: () => setState(() => matchAnimController.isActive = false),
      onStart: () => setState(() => matchAnimController.isActive = true),
    );
  }

  @override
  void dispose() {
    super.dispose();
    matchAnimController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AuthController.to.isLoggedIn.value
          ? ProfileSetupController.to.isProfileSet.value
              ? Scaffold(
                  // Avoid status bar
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    title: SimpleAppbar(),
                  ),
                  body: Stack(
                    children: [
                      PageView(
                        controller: BaseController.to.pageController,
                        physics: BaseController.to.currentNavIndex.value == 0
                            ? NeverScrollableScrollPhysics()
                            : AlwaysScrollableScrollPhysics(),
                        onPageChanged: (index) =>
                            BaseController.to..currentNavIndex.value = index,
                        children: [
                          // Index 0
                          Stack(
                            children: [
                              Feed(),

                              // Match Anim
                              Obx(
                                () => Visibility(
                                  visible: isMatchAnimPlaying.value,
                                  child: IgnorePointer(
                                    child: RiveAnimation.asset(
                                      'assets/anim/match.riv',
                                      controllers: [matchAnimController],
                                      animations: ['match'],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Index 1
                          Discover(),

                          // Index 2
                          Likes(),

                          // Index 3
                          Chats(),

                          // Index 4
                          Profile(),
                        ],
                      ),

                      // Text(BaseController.to.showMe.value),
                    ],
                  ),
                  bottomNavigationBar: BottomNavBar(),
                )
              : ProfileSetup()
          : AuthScreen(),
    );
  }
}
