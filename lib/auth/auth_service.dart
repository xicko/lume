import 'package:flutter/material.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/profile_setup_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<AuthResponse> signIn() async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: AuthController.to.emailController.text,
        password: AuthController.to.passwordController.text,
      );

      BaseController.to.getSnackbar('Logged in', '', hideMessage: true);
      AuthController.to.emailController.clear();
      AuthController.to.passwordController.clear();

      return res;
    } on AuthException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<AuthResponse> signUp() async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: AuthController.to.emailController.text,
        password: AuthController.to.passwordController.text,
      );

      BaseController.to
          .getSnackbar('Sign up successful', '', hideMessage: true);
      AuthController.to.emailController.clear();
      AuthController.to.passwordController.clear();

      return res;
    } on AuthException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  String getCurrentUserId() {
    final user = supabase.auth.currentSession?.user.id;
    return user ?? '';
  }

  String getCurrentUserEmail() {
    final user = supabase.auth.currentSession?.user.email;
    return user ?? '';
  }

  void signOut() {
    supabase.auth.signOut();
    BaseController.to.getSnackbar('Logged out', '', hideMessage: true);

    // Reset navindex to 0
    BaseController.to.changeNavIndex(0);

    ProfileSetupController.to.isProfileSet.value = false;

    // To login screen
    AuthController.to.authScreenIndex.value = 1;
    AuthController.to.loginAnim.value = true;
  }
}
