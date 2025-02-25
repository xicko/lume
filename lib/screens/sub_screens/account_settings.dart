import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/account_settings_controller.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:lume/controllers/base_controller.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final TextEditingController emailController =
      AccountSettingsController.to.emailController;
  final TextEditingController currentPasswordController =
      AccountSettingsController.to.currentPasswordController;
  final TextEditingController newPasswordController =
      AccountSettingsController.to.newPasswordController;
  final TextEditingController confirmPasswordController =
      AccountSettingsController.to.confirmPasswordController;

  final FocusNode currentPasswordFN = FocusNode();
  final FocusNode newPasswordFN = FocusNode();
  final FocusNode confirmPasswordFN = FocusNode();

  // Check for valid password input and update if conditions meet
  void _onPasswordUpdate() {
    if (currentPasswordController.text.isNotEmpty) {
      if (newPasswordController.text.length > 7) {
        if (confirmPasswordController.text.length > 7) {
          if (newPasswordController.text == confirmPasswordController.text) {
            AccountSettingsController.to.updatePassword();
          } else {
            BaseController.to
                .getSnackbar('Passwords do not match', '', hideMessage: true);
          }
        } else {
          BaseController.to.getSnackbar(
              'Password must be at least 8 characters', '',
              hideMessage: true);
        }
      } else {
        BaseController.to.getSnackbar(
            'Password must be at least 8 characters', '',
            hideMessage: true);
      }
    } else {
      BaseController.to.getSnackbar('Invalid email', '', hideMessage: true);
    }
  }

  @override
  void initState() {
    super.initState();

    // Prepopulate email at page mount
    setState(() {
      emailController.text = AuthController.to.userEmail.value;
    });
  }

  @override
  void dispose() {
    super.dispose();
    currentPasswordFN.dispose();
    newPasswordFN.dispose();
    confirmPasswordFN.dispose();

    emailController.clear();
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    AccountSettingsController.to.isEmailChangeSent.value = false;
    AccountSettingsController.to.isPasswordUpdated.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          'Account Settings',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Change Email
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Email'),
                        Text(
                          AccountSettingsController.to.isEmailChangeSent.value
                              ? 'Confirmation sent'
                              : '',
                          style: TextStyle(
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Email text input
                TextField(
                  controller: emailController,
                  maxLength: 100,
                  cursorColor: Colors.black,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    counterStyle: TextStyle(fontSize: 0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                ),

                // Change email button
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        backgroundColor: AccountSettingsController
                                .to.isEmailTextChanged.value
                            ? Colors.blue[200]
                            : Colors.white,
                        shape: RoundedRectangleBorder(),
                      ),
                      onPressed: () {
                        if (AccountSettingsController
                            .to.isEmailTextChanged.value) {
                          AccountSettingsController.to.updateEmail();
                        } else {
                          null;
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Change Email'),
                          if (AccountSettingsController
                              .to.isEmailTextChanged.value)
                            SizedBox(width: 4),
                          if (AccountSettingsController
                              .to.isEmailTextChanged.value)
                            Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),

            // Update password
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Password'),
                        Text(
                          AccountSettingsController.to.isPasswordUpdated.value
                              ? AccountSettingsController
                                  .to.passwordFeedbackMsg.value
                              : '',
                          style: TextStyle(
                            color: AccountSettingsController
                                    .to.passwordFeedbackMsg.value
                                    .contains('updated')
                                ? Color.fromRGBO(46, 125, 50, 1)
                                : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Current Password
                TextField(
                  controller: currentPasswordController,
                  focusNode: currentPasswordFN,
                  maxLength: 100,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(newPasswordFN),
                  cursorColor: Colors.black,
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Current password',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    counterStyle: TextStyle(fontSize: 0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                ),

                // New Password
                TextField(
                  controller: newPasswordController,
                  focusNode: newPasswordFN,
                  maxLength: 100,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(confirmPasswordFN),
                  cursorColor: Colors.black,
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'New password',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    counterStyle: TextStyle(fontSize: 0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                ),

                // Confirm New Password
                TextField(
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFN,
                  maxLength: 100,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  cursorColor: Colors.black,
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Confirm new password',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    counterStyle: TextStyle(fontSize: 0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                ),

                // Update Password Button
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        backgroundColor:
                            AccountSettingsController.to.isPasswordValid.value
                                ? Colors.blue[200]
                                : Colors.white,
                        shape: RoundedRectangleBorder(),
                      ),
                      onPressed: () => _onPasswordUpdate(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Update Password'),
                          if (AccountSettingsController
                              .to.isPasswordValid.value)
                            SizedBox(width: 4),
                          if (AccountSettingsController
                              .to.isPasswordValid.value)
                            Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom space
                SizedBox(height: 500),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
