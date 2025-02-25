import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/controllers/profile_setup_controller.dart';

class RelGoals extends StatefulWidget {
  const RelGoals({super.key});

  @override
  State<RelGoals> createState() => _RelGoalsState();
}

class _RelGoalsState extends State<RelGoals> {
  final selectedGoal = ProfileSetupController.to.selectedGoal;

  RxBool isClicked = false.obs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            spacing: 32,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'What\'s your\nrelationship goal?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Rel Goals
              LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth / 2 - 10,
                            height: 100,
                            child: button(
                                'Long-term', selectedGoal, Goals.longterm),
                          ),
                          SizedBox(
                            width: constraints.maxWidth / 2 - 10,
                            height: 100,
                            child: button('Long-term,\nopen to short',
                                selectedGoal, Goals.opentoshort),
                          ),
                          SizedBox(
                            width: constraints.maxWidth / 2 - 10,
                            height: 100,
                            child: button(
                                'New friends', selectedGoal, Goals.newfriends),
                          ),
                        ],
                      ),
                      Column(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth / 2 - 10,
                            height: 100,
                            child: button(
                                'Short-term', selectedGoal, Goals.shortterm),
                          ),
                          SizedBox(
                            width: constraints.maxWidth / 2 - 10,
                            height: 100,
                            child: button('Short-term,\nopen to long',
                                selectedGoal, Goals.opentolong),
                          ),
                          SizedBox(
                            width: constraints.maxWidth / 2 - 10,
                            height: 100,
                            child: button('Still figuring out', selectedGoal,
                                Goals.figuringout),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 28),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            spacing: 16,
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  backgroundColor: Colors.blue[100],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  overlayColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  ProfileSetupController.to.toPage(1);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: selectedGoal.value != null
                          ? Colors.blue[900]
                          : Colors.grey[300],
                      foregroundColor: selectedGoal.value != null
                          ? Colors.white
                          : Colors.grey[700],
                      elevation: 0,
                      overlayColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(99)),
                      ),
                    ),
                    onPressed: () async {
                      if (selectedGoal.value != null) {
                        await ProfileSetupController.to.finishSetup();
                        // Update location
                        await ProfileController.to.updateLocation();
                      } else {
                        BaseController.to.getSnackbar(
                            'Please select your goal', '',
                            hideMessage: true);
                      }
                    },
                    child: Text(
                      'Finish profile',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget button(String text, Rx<Goals?> isClicked, Goals pickedGoal) {
  return Obx(
    () => ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        backgroundColor:
            isClicked.value == pickedGoal ? Colors.blue[200] : Colors.grey[200],
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        if (ProfileSetupController.to.selectedGoal.value != pickedGoal) {
          ProfileSetupController.to.selectedGoal.value = pickedGoal;
        } else {
          ProfileSetupController.to.selectedGoal.value = null;
        }
      },
      child: Column(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.public,
            size: 30,
            color: Colors.black,
          ),
          Text(
            text,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}
