import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/controllers/profile_setup_controller.dart';
import 'package:lume/screens/profile_setup/image_upload.dart';
import 'package:lume/screens/profile_setup/more_info_skippable.dart';
import 'package:lume/screens/profile_setup/rel_goals.dart';
import 'package:lume/screens/profile_setup/user_basics.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Avoid status bar
      appBar: PreferredSize(
        preferredSize: Size(0, 0),
        child: SizedBox(
          height: MediaQuery.of(context).viewPadding.top,
        ),
      ),
      body: Obx(
        () => Stack(
          children: [
            AnimatedOpacity(
              opacity: ProfileSetupController.to.isLoading.value ? 0 : 1,
              duration: Duration(milliseconds: 400),
              child: PageView(
                controller: ProfileSetupController.to.pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  UserBasics(),
                  MoreInfoSkippable(),
                  ImageUpload(),
                  RelGoals(),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: ProfileSetupController.to.isLoading.value ? 1 : 0,
              duration: Duration(milliseconds: 400),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ),
            Obx(() => Text(ProfileController.to.userBio.value.toString()))
          ],
        ),
      ),
    );
  }
}
