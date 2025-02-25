import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lume/auth/auth_service.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/profile_setup_controller.dart';

class UserBasics extends StatefulWidget {
  const UserBasics({super.key});

  @override
  State<UserBasics> createState() => _UserBasicsState();
}

class _UserBasicsState extends State<UserBasics> {
  final selectedGender = ProfileSetupController.to.selectedGender;
  final selectedDTDate = ProfileSetupController.to.selectedDTDate;

  double leftPos(BoxConstraints constraints) {
    if (selectedGender.value == Gender.male) {
      return 0.0;
    } else if (selectedGender.value == Gender.female) {
      return constraints.maxWidth / 2;
    }
    return constraints.maxWidth / 3;
  }

  // Calculate current legal age
  DateTime legalAge() {
    DateTime now = DateTime.now();
    final yearsAgo = DateTime(now.year - 18, now.month, now.day);

    return yearsAgo;
  }

  // Display picked date in human readable format
  String showPickedDate() {
    final format = DateFormat.yMd();
    final date = format.format(selectedDTDate.value ?? DateTime(1));

    return date;
  }

  // Calculate years since picked date year to show age
  String calculateYears() {
    if (selectedDTDate.value != null) {
      final now = DateTime.now();
      final subtracted = DateTime(
          now.year - selectedDTDate.value!.year,
          now.month - selectedDTDate.value!.month,
          now.day - selectedDTDate.value!.day);

      final formatted = DateFormat.y().format(subtracted);

      return formatted;
    }

    return '';
  }

  // When date pick button is pressed
  void onDatePicked() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1920),
        lastDate: legalAge());
    await Future.delayed(Duration(milliseconds: 400));
    if (pickedDate != null) {
      // Set raw string
      ProfileSetupController.to.selectedDate.value =
          pickedDate.toIso8601String();

      // Set DateTime format state
      selectedDTDate.value = pickedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // setup
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            spacing: 24,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                spacing: 12,
                children: [
                  Image.asset(
                    'assets/lumetransparent.png',
                    width: 44,
                    height: 44,
                  ),
                  Text(
                    'Let\'s Get Started',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Display name
              TextField(
                controller: ProfileSetupController.to.nameController,
                maxLength: 24,
                decoration: InputDecoration(
                  hintText: 'Your name',
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

              // Gender
              LayoutBuilder(
                builder: (context, constraints) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      color: Colors.grey[100],
                      child: Stack(
                        children: [
                          // Btn Anim
                          Obx(
                            () => AnimatedPositioned(
                              left: leftPos(constraints),
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              child: AnimatedOpacity(
                                opacity: selectedGender.value != null ? 1 : 0,
                                duration: Duration(milliseconds: 200),
                                child: Container(
                                  width: constraints.maxWidth / 2,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[700],
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Buttons
                          Obx(
                            () => SizedBox(
                              height: 36,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        ProfileSetupController.to.selectedGender
                                            .value = Gender.male;
                                      },
                                      overlayColor: WidgetStateProperty.all(
                                          Colors.transparent),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7),
                                        child: AnimatedDefaultTextStyle(
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w500,
                                            color: selectedGender.value ==
                                                    Gender.male
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          duration: Duration(milliseconds: 150),
                                          child: Text(
                                            'Male',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        selectedGender.value = Gender.female;
                                      },
                                      overlayColor: WidgetStateProperty.all(
                                          Colors.transparent),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7),
                                        child: AnimatedDefaultTextStyle(
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w500,
                                            color: selectedGender.value ==
                                                    Gender.female
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          duration: Duration(milliseconds: 150),
                                          child: Text(
                                            'Female',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Age / Birthday picker
              LayoutBuilder(
                builder: (context, constraints) {
                  return Obx(
                    () => Stack(
                      children: [
                        // Base Size
                        AnimatedOpacity(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 900),
                          opacity: selectedDTDate.value != null ? 1 : 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      overlayColor: Colors.transparent,
                                      backgroundColor: Colors.grey[100],
                                      foregroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 24, horizontal: 24),
                                    ),
                                    onPressed: () async {},
                                    child: Text(''),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Date / Age Text
                        AnimatedPositioned(
                          top: 0,
                          bottom: 0,
                          left: selectedDTDate.value != null
                              ? constraints.maxWidth / 1.72
                              : constraints.maxWidth / 4,
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 600),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${calculateYears()} years old',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(selectedDTDate.value != null
                                  ? showPickedDate()
                                  : ''),
                            ],
                          ),
                        ),

                        // Select Button
                        AnimatedPositioned(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 600),
                          top: 0,
                          bottom: 0,
                          left: selectedDTDate.value != null
                              ? 0
                              : constraints.maxWidth / 4,
                          right: selectedDTDate.value == null
                              ? constraints.maxWidth / 4
                              : constraints.maxWidth / 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: selectedDTDate.value != null
                                  ? Colors.grey[200]
                                  : Colors.grey[100],
                              foregroundColor: Colors.black,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () => onDatePicked(),
                            child: Text(
                              'Select Birthdate',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),

              // Bottom spacer
              SizedBox(height: 36),
            ],
          ),
        ),

        // next button
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                backgroundColor:
                    ProfileSetupController.to.isNameNotEmpty.value &&
                            selectedGender.value != null &&
                            selectedDTDate.value != null
                        ? Colors.blue[900]
                        : Colors.grey[300],
                foregroundColor:
                    ProfileSetupController.to.isNameNotEmpty.value &&
                            selectedGender.value != null &&
                            selectedDTDate.value != null
                        ? Colors.white
                        : Colors.grey[700],
                elevation: 0,
                overlayColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: () {
                if (ProfileSetupController.to.isNameNotEmpty.value) {
                  if (selectedGender.value != null) {
                    if (selectedDTDate.value != null) {
                      ProfileSetupController.to.toPage(1);
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    } else {
                      BaseController.to.getSnackbar(
                          'Please select your birth date', '',
                          hideMessage: true);
                    }
                  } else {
                    BaseController.to.getSnackbar(
                        'Please select your gender', '',
                        hideMessage: true);
                  }
                } else {
                  BaseController.to.getSnackbar('Please fill your name', '',
                      hideMessage: true);
                }
              },
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            onPressed: () => AuthService().signOut(),
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
