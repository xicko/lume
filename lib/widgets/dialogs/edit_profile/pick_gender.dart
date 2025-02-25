import 'package:flutter/material.dart';
import 'package:lume/controllers/edit_profile_controller.dart';

class PickGender extends StatefulWidget {
  const PickGender({super.key});

  @override
  State<PickGender> createState() => _PickGenderState();
}

class _PickGenderState extends State<PickGender> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              EditProfileController.to.editGender.value = 'male';
              await Future.delayed(Duration(milliseconds: 40));
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    child: Text('Male'),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              EditProfileController.to.editGender.value = 'female';
              await Future.delayed(Duration(milliseconds: 40));
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    child: Text('Female'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 64),
        ],
      ),
    );
  }
}
