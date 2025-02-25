import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/auth/auth_service.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:lume/controllers/base_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool passwordReveal = false;
  bool confirmPasswordReveal = false;

  bool showPassword() {
    if (passwordReveal) {
      return false;
    } else {
      return true;
    }
  }

  bool showConfirmPassword() {
    if (confirmPasswordReveal) {
      return false;
    } else {
      return true;
    }
  }

  void onSignup() async {
    if (AuthController.to.passwordController.text ==
        AuthController.to.confirmPasswordController.text) {
      if (AuthController.to.emailController.text.isNotEmpty) {
        AuthService().signUp();
      } else {
        BaseController.to
            .getSnackbar('Please fill all fields', '', hideMessage: true);
      }
    } else {
      BaseController.to
          .getSnackbar('Passwords do not match', '', hideMessage: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 0,
      children: [
        AnimatedOpacity(
          opacity: BaseController.to.isKeyboardVisible.value ? 0 : 1,
          duration: Duration(milliseconds: 350),
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                textAlign: TextAlign.justify,
                'By tapping \'Sign in\' you agree to our Terms. Learn how we process your data in our Privacy Policy and Cookies Policy.',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: AuthController.to.emailController,
          focusNode: AuthController.to.emailFN,
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(AuthController.to.passwordFN),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Email',
            contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            prefixIcon: Padding(
              padding: EdgeInsetsDirectional.only(start: 20, end: 8),
              child: Icon(
                Icons.email_outlined,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(1231231),
              borderSide: BorderSide(
                width: 0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(1231231),
              borderSide: BorderSide(
                width: 0,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(1231231),
              borderSide: BorderSide(
                width: 0,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Obx(
          () => TextField(
            controller: AuthController.to.passwordController,
            focusNode: AuthController.to.passwordFN,
            onSubmitted: (_) => FocusScope.of(context)
                .requestFocus(AuthController.to.confirmPasswordFN),
            obscureText: showPassword(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Password',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              prefixIcon: Padding(
                padding: EdgeInsetsDirectional.only(start: 20, end: 8),
                child: Icon(
                  Icons.key_outlined,
                ),
              ),
              suffixIcon: AuthController.to.isPasswordNotEmpty.value
                  ? Padding(
                      padding: EdgeInsetsDirectional.only(start: 8, end: 20),
                      child: InkWell(
                        onTap: () {
                          if (passwordReveal) {
                            setState(() {
                              passwordReveal = false;
                            });
                          } else {
                            setState(() {
                              passwordReveal = true;
                            });
                          }
                        },
                        child: Icon(
                          showPassword()
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1231231),
                borderSide: BorderSide(
                  width: 0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1231231),
                borderSide: BorderSide(
                  width: 0,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1231231),
                borderSide: BorderSide(
                  width: 0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Obx(
          () => Visibility(
            visible: !AuthController.to.isButtonVisible.value,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: TextField(
                controller: AuthController.to.confirmPasswordController,
                focusNode: AuthController.to.confirmPasswordFN,
                obscureText: showConfirmPassword(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Confirm password',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  prefixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(start: 20, end: 8),
                    child: Icon(
                      Icons.key_outlined,
                    ),
                  ),
                  suffixIcon: AuthController.to.isConfirmPasswordNotEmpty.value
                      ? Padding(
                          padding:
                              EdgeInsetsDirectional.only(start: 8, end: 20),
                          child: InkWell(
                            onTap: () {
                              if (confirmPasswordReveal) {
                                setState(() {
                                  confirmPasswordReveal = false;
                                });
                              } else {
                                setState(() {
                                  confirmPasswordReveal = true;
                                });
                              }
                            },
                            child: Icon(
                              showConfirmPassword()
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1231231),
                    borderSide: BorderSide(
                      width: 0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1231231),
                    borderSide: BorderSide(
                      width: 0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1231231),
                    borderSide: BorderSide(
                      width: 0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => Visibility(
            visible: AuthController.to.isButtonVisible.value,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => onSignup(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: Row(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 4),
                    Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
