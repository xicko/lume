import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountSettingsController extends GetxController {
  static AccountSettingsController get to => Get.find();

  TextEditingController emailController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool isEmailTextChanged = false.obs;
  RxBool isEmailChangeSent = false.obs;

  RxBool isPasswordUpdated = false.obs;
  RxBool isPasswordValid = false.obs;
  RxString passwordFeedbackMsg = ''.obs;

  @override
  void onInit() {
    super.onInit();

    emailController.addListener(() {
      isEmailTextChanged.value =
          emailController.text != AuthController.to.userEmail.value;
    });

    void validatePassword() {
      isPasswordValid.value =
          newPasswordController.text == confirmPasswordController.text &&
              currentPasswordController.text.isNotEmpty &&
              newPasswordController.text.length > 7 &&
              confirmPasswordController.text.length > 7;
    }

    newPasswordController.addListener(validatePassword);
    confirmPasswordController.addListener(validatePassword);
    currentPasswordController.addListener(validatePassword);
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
  }

  Future<void> updateEmail() async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.auth
          .updateUser(UserAttributes(
        email: emailController.text.trim(),
      ))
          .whenComplete(() {
        isEmailChangeSent.value = true;
      });
    } catch (e) {
      debugPrint('Error updating user email: $e');
    }
  }

  Future<void> updatePassword() async {
    final supabase = Supabase.instance.client;

    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: AuthController.to.userEmail.value,
        password: currentPasswordController.text,
      );

      if (res.user != null) {
        await supabase.auth
            .updateUser(
          UserAttributes(password: newPasswordController.text.trim()),
        )
            .whenComplete(() {
          isPasswordUpdated.value = true;
          passwordFeedbackMsg.value = 'Password updated';
        }).whenComplete(() {
          currentPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
        });
      }
    } on AuthException catch (e) {
      passwordFeedbackMsg.value = 'Please try again';
      debugPrint('AuthException error: $e');
    } catch (e) {
      passwordFeedbackMsg.value = 'Please try again';
      debugPrint('Update password error: $e');
    }
  }
}
