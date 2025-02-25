import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/profile_setup_controller.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final image1 = ProfileSetupController.to.image1;
  final image2 = ProfileSetupController.to.image2;

  RxBool isClicked = false.obs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            spacing: 0,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Add photos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '2 required, you can add\nmore once your profile is set.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),

              SizedBox(height: 32),

              // Add photos
              Obx(
                () => Row(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () => ProfileSetupController.to.pickImgs(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2.4,
                              height: MediaQuery.of(context).size.height / 2.8,
                              child: ProfileSetupController
                                      .to.image1.value.isNotEmpty
                                  ? Image.memory(
                                      BaseController.to.convertImage(
                                          ProfileSetupController
                                              .to.image1.value),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/null.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Visibility(
                            visible: ProfileSetupController
                                .to.image1.value.isNotEmpty,
                            child: IconButton(
                              padding: EdgeInsets.symmetric(),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white54,
                                foregroundColor: Colors.black,
                                iconSize: 24,
                                padding: EdgeInsets.symmetric(),
                              ),
                              onPressed: () {
                                ProfileSetupController.to.image1.value = '';
                              },
                              icon: Icon(
                                Icons.close_rounded,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible:
                          ProfileSetupController.to.image2.value.isNotEmpty,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () => ProfileSetupController.to.pickImgs(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2.4,
                                height:
                                    MediaQuery.of(context).size.height / 2.8,
                                child: Image.memory(
                                  BaseController.to.convertImage(
                                      ProfileSetupController.to.image2.value),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: IconButton(
                              padding: EdgeInsets.symmetric(),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white54,
                                foregroundColor: Colors.black,
                                iconSize: 24,
                                padding: EdgeInsets.symmetric(),
                              ),
                              onPressed: () {
                                ProfileSetupController.to.image2.value = '';
                              },
                              icon: Icon(
                                Icons.close_rounded,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            spacing: 16,
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  backgroundColor: Colors.blue[100],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  overlayColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  ProfileSetupController.to.toPage(1);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor:
                          image1.value.isNotEmpty && image2.value.isNotEmpty
                              ? Colors.blue[900]
                              : Colors.grey[300],
                      foregroundColor:
                          image1.value.isNotEmpty && image2.value.isNotEmpty
                              ? Colors.white
                              : Colors.grey[700],
                      elevation: 0,
                      overlayColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(99)),
                      ),
                    ),
                    onPressed: () async {
                      if (image1.value.isNotEmpty && image2.value.isNotEmpty) {
                        ProfileSetupController.to.toPage(3);
                      } else {
                        BaseController.to.getSnackbar(
                            'Please add photos of yourself', '',
                            hideMessage: true);
                      }
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
