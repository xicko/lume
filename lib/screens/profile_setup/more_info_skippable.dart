import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/profile_setup_controller.dart';

class MoreInfoSkippable extends StatefulWidget {
  const MoreInfoSkippable({super.key});

  @override
  State<MoreInfoSkippable> createState() => _MoreInfoSkippableState();
}

class _MoreInfoSkippableState extends State<MoreInfoSkippable> {
  final selectedPersonality = ProfileSetupController.to.selectedPersonality;
  final selectedSexOrientation =
      ProfileSetupController.to.selectedSexOrientation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            spacing: 0,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top dynamic padding
              Obx(
                () => AnimatedContainer(
                  height: BaseController.to.isKeyboardVisible.value
                      ? MediaQuery.of(context).size.height * 0.09
                      : MediaQuery.of(context).size.height * 0.18,
                  duration: Duration(milliseconds: 200),
                ),
              ),

              Text(
                'Let\'s get to\nknow you more!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 32),

              // Bio
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  controller: ProfileSetupController.to.bioController,
                  maxLength: 1200,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Bio',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                    counterStyle: TextStyle(fontSize: 0),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: const Color.fromRGBO(224, 224, 224, 1),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: const Color.fromRGBO(224, 224, 224, 1),
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: const Color.fromRGBO(224, 224, 224, 1),
                        width: 2,
                      ),
                    ),
                  ),
                  style: TextStyle(),
                ),
              ),

              Obx(
                () => AnimatedContainer(
                  height: BaseController.to.isKeyboardVisible.value ? 300 : 16,
                  duration: Duration(milliseconds: 180),
                  curve: Curves.easeInOut,
                ),
              ),

              Obx(
                () => AnimatedOpacity(
                  opacity: BaseController.to.isKeyboardVisible.value ? 0 : 1,
                  duration: Duration(milliseconds: 180),
                  child: Text('Select Personality'),
                ),
              ),

              // Personality picker
              Stack(
                children: [
                  Obx(
                    () => AnimatedOpacity(
                      opacity:
                          BaseController.to.isKeyboardVisible.value ? 0 : 1,
                      duration: Duration(milliseconds: 180),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 16,
                          itemBuilder: (context, index) {
                            bool isFirst = index == 0;
                            bool isLast = index == 16 - 1;

                            String personality() {
                              switch (index) {
                                case 0:
                                  return 'ISTJ';
                                case 1:
                                  return 'ISTP';
                                case 2:
                                  return 'ISFJ';
                                case 3:
                                  return 'ISFP';
                                case 4:
                                  return 'INTJ';
                                case 5:
                                  return 'INTP';
                                case 6:
                                  return 'INFJ';
                                case 7:
                                  return 'INFP';
                                case 8:
                                  return 'ESTJ';
                                case 9:
                                  return 'ESTP';
                                case 10:
                                  return 'ESFJ';
                                case 11:
                                  return 'ESFP';
                                case 12:
                                  return 'ENTJ';
                                case 13:
                                  return 'ENTP';
                                case 14:
                                  return 'ENFJ';
                                case 15:
                                  return 'ENFP';
                                default:
                                  return '';
                              }
                            }

                            return Padding(
                              padding: EdgeInsets.only(
                                left: isFirst ? 36 : 4,
                                right: isLast ? 36 : 4,
                                top: 8,
                                bottom: 8,
                              ),
                              child: Obx(
                                () => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    backgroundColor:
                                        selectedPersonality.value ==
                                                personality()
                                            ? Colors.blue[700]
                                            : Colors.grey[100],
                                    foregroundColor:
                                        selectedPersonality.value ==
                                                personality()
                                            ? Colors.white
                                            : Colors.black,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical: 0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (selectedPersonality.value !=
                                        personality()) {
                                      // Deselect
                                      selectedPersonality.value = personality();
                                    } else {
                                      // Select
                                      selectedPersonality.value = null;
                                    }
                                  },
                                  child: Text(personality()),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      width: 36,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Colors.white.withAlpha(0),
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Colors.white,
                            Colors.white.withAlpha(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Obx(
                () => AnimatedOpacity(
                  opacity: BaseController.to.isKeyboardVisible.value ? 0 : 1,
                  duration: Duration(milliseconds: 180),
                  child: Text('Sexual Orientation'),
                ),
              ),

              SizedBox(height: 6),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Obx(
                  () => AnimatedOpacity(
                    opacity: BaseController.to.isKeyboardVisible.value ? 0 : 1,
                    duration: Duration(milliseconds: 180),
                    child: Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              backgroundColor:
                                  selectedSexOrientation.value == 'straight'
                                      ? Colors.blue[700]
                                      : Colors.grey[100],
                              foregroundColor:
                                  selectedSexOrientation.value == 'straight'
                                      ? Colors.white
                                      : Colors.black,
                              padding: EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (selectedSexOrientation.value != 'straight') {
                                // Select
                                selectedSexOrientation.value = 'straight';
                              } else {
                                // Deselect
                                selectedSexOrientation.value = null;
                              }
                            },
                            child: Text('Straight'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              backgroundColor:
                                  selectedSexOrientation.value == 'gay'
                                      ? Colors.blue[700]
                                      : Colors.grey[100],
                              foregroundColor:
                                  selectedSexOrientation.value == 'gay'
                                      ? Colors.white
                                      : Colors.black,
                              padding: EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (selectedSexOrientation.value != 'gay') {
                                // Select
                                selectedSexOrientation.value = 'gay';
                              } else {
                                // Deselect
                                selectedSexOrientation.value = null;
                              }
                            },
                            child: Text('Gay'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              backgroundColor:
                                  selectedSexOrientation.value == 'lesbian'
                                      ? Colors.blue[700]
                                      : Colors.grey[100],
                              foregroundColor:
                                  selectedSexOrientation.value == 'lesbian'
                                      ? Colors.white
                                      : Colors.black,
                              padding: EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (selectedSexOrientation.value != 'lesbian') {
                                // Select
                                selectedSexOrientation.value = 'lesbian';
                              } else {
                                // Deselect
                                selectedSexOrientation.value = null;
                              }
                            },
                            child: Text('Lesbian'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom padding
              Obx(
                () => AnimatedContainer(
                  height: BaseController.to.isKeyboardVisible.value ? 220 : 80,
                  duration: Duration(milliseconds: 200),
                ),
              ),
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
                  ProfileSetupController.to.toPage(0);
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
                      backgroundColor:
                          ProfileSetupController.to.isBioNotEmpty.value ||
                                  selectedPersonality.value != null ||
                                  selectedSexOrientation.value != null
                              ? Colors.blue[900]
                              : Colors.grey[300],
                      foregroundColor:
                          ProfileSetupController.to.isBioNotEmpty.value ||
                                  selectedPersonality.value != null ||
                                  selectedSexOrientation.value != null
                              ? Colors.white
                              : Colors.grey[700],
                      elevation: 0,
                      overlayColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(99)),
                      ),
                    ),
                    onPressed: () {
                      ProfileSetupController.to.toPage(2);
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    },
                    child: Text(
                      ProfileSetupController.to.isBioNotEmpty.value ||
                              selectedPersonality.value != null ||
                              selectedSexOrientation.value != null
                          ? 'Next'
                          : 'Skip',
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
