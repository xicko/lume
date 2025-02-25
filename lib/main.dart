import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lume/auth/auth_gate.dart';
import 'package:lume/auth/auth_key.dart';
import 'package:lume/base_screen.dart';
import 'package:lume/controllers/account_settings_controller.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/edit_profile_controller.dart';
import 'package:lume/controllers/feed_controller.dart';
import 'package:lume/controllers/swipes_controller.dart';
import 'package:lume/controllers/matches_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/controllers/profile_setup_controller.dart';
import 'package:lume/controllers/messages_controller.dart';
import 'package:lume/theme/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
    url: AuthKey.supabaseUrl,
    anonKey: AuthKey.supabaseAnonKey,
  );
  await GetStorage.init();

  Get.put<BaseController>(BaseController());
  Get.put<AuthController>(AuthController());
  Get.put<ProfileSetupController>(ProfileSetupController());
  Get.put<ProfileController>(ProfileController());
  Get.put<FeedController>(FeedController());
  Get.put<EditProfileController>(EditProfileController());
  Get.put<AccountSettingsController>(AccountSettingsController());
  Get.put<SwipesController>(SwipesController());
  Get.put<MatchesController>(MatchesController());
  Get.put<MessagesController>(MessagesController());

  runApp(const MainApp());
}

final GlobalKey<BaseScreenState> baseScreenKey = GlobalKey<BaseScreenState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: lightTheme,
      home: AuthGate(
        child: KeyboardDismissOnTap(
          child: BaseScreen(key: baseScreenKey),
        ),
      ),
    );
  }
}
