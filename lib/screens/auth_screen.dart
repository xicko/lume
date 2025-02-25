import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/screens/auth_screens/login.dart';
import 'package:lume/screens/auth_screens/signup.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void changeAuthInd() async {
    if (AuthController.to.authScreenIndex.value == 0) {
      AuthController.to.signupAnim.value = false;

      await Future.delayed(Duration(milliseconds: 180));

      AuthController.to.loginAnim.value = true;

      AuthController.to.authScreenIndex.value = 1;
    } else if (AuthController.to.authScreenIndex.value == 1) {
      AuthController.to.loginAnim.value = false;

      await Future.delayed(Duration(milliseconds: 180));

      AuthController.to.signupAnim.value = true;

      AuthController.to.authScreenIndex.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 0),
        child: SizedBox(),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
          // Avoid status bar
          top: MediaQuery.of(context).viewPadding.top,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF2C3E50), // #2c3e50 (Dark Blue-Gray)
              Color(0xFF2980B9), // #2980b9 (Bright Blue)
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Logo and title
            Column(
              children: [
                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/lumew.png'),
                      width: 54,
                      height: 54,
                    ),
                    Text(
                      'lume',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 6),
                  ],
                ),
                Text(
                  'Let your love shine.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            // Dynamic Space
            Obx(
              () => AnimatedContainer(
                duration: Duration(milliseconds: 220),
                height: BaseController.to.isKeyboardVisible.value ? 16 : 260,
                child: SizedBox(),
              ),
            ),

            // Login/Signup component
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                // Signup
                child: AuthController.to.authScreenIndex.value == 0
                    ? AnimatedOpacity(
                        opacity: AuthController.to.signupAnim.value ? 1 : 0,
                        duration: Duration(milliseconds: 180),
                        child: SignUp(),
                      )
                    : AnimatedOpacity(
                        opacity: AuthController.to.loginAnim.value ? 1 : 0,
                        duration: Duration(milliseconds: 180),
                        child: Login(),
                      ),
              ),
            ),

            SizedBox(height: 16),

            Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Text(
                    'Trouble signing in?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: 1,
                  height: 24,
                ),
                InkWell(
                  onTap: () => changeAuthInd(),
                  child: Obx(
                    () => Text(
                      AuthController.to.authScreenIndex.value == 0
                          ? 'Log in'
                          : 'Sign up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
