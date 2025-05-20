import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/feed_controller.dart';
import 'package:lume/controllers/swipes_controller.dart';
import 'package:lume/controllers/matches_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  RxBool isLoggedIn = false.obs;
  RxString userId = ''.obs;
  RxString userEmail = ''.obs;

  RxInt authScreenIndex = 0.obs;
  RxBool signupAnim = true.obs;
  RxBool loginAnim = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode emailFN = FocusNode();
  FocusNode passwordFN = FocusNode();
  FocusNode confirmPasswordFN = FocusNode();

  RxBool isButtonVisible = false.obs;
  RxBool isPasswordNotEmpty = false.obs;
  RxBool isConfirmPasswordNotEmpty = false.obs;

  @override
  void onInit() {
    super.onInit();

    passwordController.addListener(() {
      if (passwordController.text.length > 7 ||
          confirmPasswordController.text.length > 7) {
        isButtonVisible.value =
            passwordController.text == confirmPasswordController.text;
      } else {
        isButtonVisible.value = false;
      }

      if (passwordController.text.isNotEmpty) {
        isPasswordNotEmpty.value = true;
      } else {
        isPasswordNotEmpty.value = false;
      }
    });

    confirmPasswordController.addListener(() {
      if (passwordController.text.length > 7 ||
          confirmPasswordController.text.length > 7) {
        isButtonVisible.value =
            passwordController.text == confirmPasswordController.text;
      } else {
        isButtonVisible.value = false;
      }

      if (confirmPasswordController.text.isNotEmpty) {
        isConfirmPasswordNotEmpty.value = true;
      } else {
        isConfirmPasswordNotEmpty.value = false;
      }
    });

    // Clear inputs whenever authScrIndex changes
    ever(authScreenIndex, (_) {
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    emailFN.dispose();
    passwordFN.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }

  Future<void> initAuth() async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentSession?.user;
    isLoggedIn.value = user != null;

    // Once at startup
    //if (user != null) {
    //  userId.value = user.id;
    //  userEmail.value = user.email ?? '';

    // fetch at app start
    //  ProfileController.to.updateLocation();
    //  FeedController.to.fetchFeed();
    //  SwipesController.to.fetchLikes();
    //  SwipesController.to.fetchMatches();
    //} else {
    //  userId.value = '';
    //  userEmail.value = '';
    //  ProfileController.to.clearAllUserInfo();
    //}

    // Called everytime auth state changes
    supabase.auth.onAuthStateChange.listen((data) {
      isLoggedIn.value = data.session != null;

      final currentUser = data.session?.user;
      if (currentUser != null) {
        userId.value = currentUser.id;
        userEmail.value = currentUser.email ?? '';

        ProfileController.to.updateLocation();
        FeedController.to.fetchFeed();
        SwipesController.to.fetchLikes();
        MatchesController.to.fetchMatches();
      } else {
        userId.value = '';
        userEmail.value = '';
        ProfileController.to.clearAllUserInfo();
      }
    });
  }

  // Called on nav index changes
  Future<void> reloadAuthState() async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentSession?.user;
    isLoggedIn.value = user != null;

    // Once at startup
    if (user != null) {
      userId.value = user.id;
      userEmail.value = user.email ?? '';
      SwipesController.to.fetchLikes();
      MatchesController.to.fetchMatches();
    } else {
      userId.value = '';
      userEmail.value = '';
      ProfileController.to.clearAllUserInfo();
    }
  }
}
