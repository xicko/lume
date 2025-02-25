import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/auth/auth_service.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/screens/sub_screens/account_settings.dart';

class AppSettingsBottomsheet extends StatelessWidget {
  const AppSettingsBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 6),

            Text(
              AuthController.to.userEmail.value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.blue[100],
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var tween = Tween(begin: Offset(-1, 0), end: Offset(0, 0))
                          .chain(CurveTween(curve: Curves.easeInOut));
                      var offsetAnim = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnim,
                        child: child,
                      );
                    },
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return AccountSettings();
                    },
                  ),
                );
              },
              child: Text('Account Settings'),
            ),

            SizedBox(height: 16),

            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 14, bottom: 6),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28),
                      child: Text('Show Me'),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                      child: Row(
                        spacing: 12,
                        children: [
                          // Everyone
                          InkWell(
                            onTap: () =>
                                BaseController.to.updateShowMe('everyone'),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color:
                                    BaseController.to.showMe.value == 'everyone'
                                        ? Colors.blue[100]
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 2,
                                  color: const Color.fromRGBO(187, 222, 251, 1),
                                ),
                              ),
                              child: Text(
                                'Everyone',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          // Men
                          InkWell(
                            onTap: () => BaseController.to.updateShowMe('male'),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: BaseController.to.showMe.value == 'male'
                                    ? Colors.blue[100]
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 2,
                                  color: const Color.fromRGBO(187, 222, 251, 1),
                                ),
                              ),
                              child: Text(
                                'Men',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          // Women
                          InkWell(
                            onTap: () =>
                                BaseController.to.updateShowMe('female'),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color:
                                    BaseController.to.showMe.value == 'female'
                                        ? Colors.blue[100]
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 2,
                                  color: const Color.fromRGBO(187, 222, 251, 1),
                                ),
                              ),
                              child: Text(
                                'Women',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Max Distance
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 14, bottom: 6),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28),
                      child: Text(
                          'Maximum Distance   ${BaseController.to.maxDistance.value.toString().split('.').first} km'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Slider(
                        min: 1,
                        max: 100,
                        divisions: 100,
                        value: BaseController.to.maxDistance.value.toDouble(),
                        onChanged: (double value) {
                          BaseController.to.updateMaxDistance(value.toInt());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Age Range
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 14, bottom: 6),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28),
                      child: Text(
                          'Age Range   ${BaseController.to.ageRange.value.start.toString().split('.').first} - ${BaseController.to.ageRange.value.end.toString().split('.').first}'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: RangeSlider(
                        min: 18,
                        max: 70,
                        divisions: 52,
                        labels: RangeLabels(
                          BaseController.to.ageRange.value.start
                              .toString()
                              .split('.')
                              .first,
                          BaseController.to.ageRange.value.end
                              .toString()
                              .split('.')
                              .first,
                        ),
                        values: BaseController.to.ageRange.value,
                        onChanged: (RangeValues value) {
                          BaseController.to.updateAgeRange(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Logout bttn
            Row(
              children: [
                SizedBox(height: 32),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 200));
                      AuthService().signOut();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 4,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.black,
                          size: 18,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 1),
                          child: Text(
                            'Log out',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
