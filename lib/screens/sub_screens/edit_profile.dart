import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/edit_profile_controller.dart';
import 'package:lume/controllers/profile_controller.dart';
import 'package:lume/widgets/dialogs/edit_profile/pick_gender.dart';
import 'package:lume/widgets/dialogs/edit_profile/pick_goal.dart';
import 'package:lume/widgets/edit_profile/edit_basics.dart';
import 'package:lume/widgets/edit_profile/edit_lifestyle.dart';
import 'package:lume/widgets/edit_profile/profile_info_single.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    EditProfileController.to.setEditProfileDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black45,
        elevation: 3,
        title: Row(
          children: [
            Text(
              'Edit profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              EditProfileController.to.updateProfileInfo();
              BaseController.to
                  .getSnackbar('Profile updated', '', hideMessage: true);
              Navigator.pop(context);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          child: Column(
            children: [
              SizedBox(height: 0),

              Container(
                width: MediaQuery.of(context).size.width,
                child: Obx(
                  () => Column(
                    spacing: 10,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: InkWell(
                                onTap: () =>
                                    EditProfileController.to.pickImg(index: 1),
                                child: AspectRatio(
                                  aspectRatio: 0.8,
                                  child: EditProfileController
                                          .to.images[0].value.isNotEmpty
                                      ? Image.memory(
                                          BaseController.to.convertImage(
                                              EditProfileController
                                                  .to.images[0].value),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/avatar.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: InkWell(
                                onTap: () =>
                                    EditProfileController.to.pickImg(index: 2),
                                child: AspectRatio(
                                  aspectRatio: 0.8,
                                  child: EditProfileController
                                          .to.images[1].value.isNotEmpty
                                      ? Image.memory(
                                          BaseController.to.convertImage(
                                              EditProfileController
                                                  .to.images[1].value),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/avatar.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: InkWell(
                                onTap: () =>
                                    EditProfileController.to.pickImg(index: 3),
                                child: AspectRatio(
                                  aspectRatio: 0.8,
                                  child: EditProfileController
                                          .to.images[2].value.isNotEmpty
                                      ? Image.memory(
                                          BaseController.to.convertImage(
                                              EditProfileController
                                                  .to.images[2].value),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/avatar.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: InkWell(
                                onTap: () =>
                                    EditProfileController.to.pickImg(index: 4),
                                child: AspectRatio(
                                  aspectRatio: 0.8,
                                  child: EditProfileController
                                          .to.images[3].value.isNotEmpty
                                      ? Image.memory(
                                          BaseController.to.convertImage(
                                              EditProfileController
                                                  .to.images[3].value),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/avatar.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: InkWell(
                                onTap: () =>
                                    EditProfileController.to.pickImg(index: 5),
                                child: AspectRatio(
                                  aspectRatio: 0.8,
                                  child: EditProfileController
                                          .to.images[4].value.isNotEmpty
                                      ? Image.memory(
                                          BaseController.to.convertImage(
                                              EditProfileController
                                                  .to.images[4].value),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/avatar.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: InkWell(
                                onTap: () =>
                                    EditProfileController.to.pickImg(index: 6),
                                child: AspectRatio(
                                  aspectRatio: 0.8,
                                  child: EditProfileController
                                          .to.images[5].value.isNotEmpty
                                      ? Image.memory(
                                          BaseController.to.convertImage(
                                              EditProfileController
                                                  .to.images[5].value),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/avatar.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: InkWell(
                                onTap: () =>
                                    EditProfileController.to.pickImg(index: 7),
                                child: AspectRatio(
                                  aspectRatio: 0.8,
                                  child: EditProfileController
                                          .to.images[6].value.isNotEmpty
                                      ? Image.memory(
                                          BaseController.to.convertImage(
                                              EditProfileController
                                                  .to.images[6].value),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/avatar.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: InkWell(
                                onTap: () =>
                                    EditProfileController.to.pickImg(index: 8),
                                child: AspectRatio(
                                  aspectRatio: 0.8,
                                  child: EditProfileController
                                          .to.images[7].value.isNotEmpty
                                      ? Image.memory(
                                          BaseController.to.convertImage(
                                              EditProfileController
                                                  .to.images[7].value),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/avatar.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: InkWell(
                                onTap: () =>
                                    EditProfileController.to.pickImg(index: 9),
                                child: AspectRatio(
                                  aspectRatio: 0.8,
                                  child: EditProfileController
                                          .to.images[8].value.isNotEmpty
                                      ? Image.memory(
                                          BaseController.to.convertImage(
                                              EditProfileController
                                                  .to.images[8].value),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/avatar.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 22),

              // About Me / Bio input
              Column(
                spacing: 12,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'About me',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.lightBlueAccent,
                          ),
                          child: Text(
                            'IMPORTANT',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: EditProfileController.to.bioEditController,
                    maxLength: 500,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'About me',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Interests
              ProfileInfoSingle(
                label: 'Interests',
                buttonText: 'Add interests',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text('data'),
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 22),

              // Interests
              Obx(
                () => ProfileInfoSingle(
                  label: 'Relationship goals',
                  buttonText:
                      'Looking for: ${ProfileController.to.showGoal(user: EditProfileController.to.editGoal.value)}',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.grey[200],
                      showDragHandle: true,
                      builder: (context) {
                        return PickGoal();
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: 22),

              // Height
              ProfileInfoSingle(
                label: 'Height',
                buttonText: 'Add height',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text('data'),
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 22),

              // Languages I Know
              ProfileInfoSingle(
                label: 'Languages I Know',
                buttonText: 'Add languages',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text('data'),
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 22),

              // Basics
              EditBasics(),

              SizedBox(height: 22),

              // Lifestyle
              EditLifestyle(),

              SizedBox(height: 22),

              // Gender
              Obx(
                () => ProfileInfoSingle(
                  label: 'Gender',
                  buttonText: ProfileController.to.showGender(
                      user: EditProfileController.to.editGender.value),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      backgroundColor: Colors.grey[200],
                      builder: (context) {
                        return PickGender();
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: 38),
            ],
          ),
        ),
      ),
    );
  }
}
