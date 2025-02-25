import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/swipes_controller.dart';
import 'package:lume/controllers/matches_controller.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NavigationBar(
        backgroundColor: Colors.white,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        indicatorColor: Colors.blue[100],
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Adjust roundness
        ),
        selectedIndex: BaseController.to.currentNavIndex.value,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        height: 48,
        onDestinationSelected: (value) =>
            BaseController.to.changeNavIndex(value),
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.view_carousel_rounded,
              color: Colors.black87,
            ),
            label: 'Feed',
          ),
          IgnorePointer(
            child: NavigationDestination(
              icon: Icon(
                Icons.public,
                color: Colors.black87,
              ),
              label: 'Discover',
            ),
          ),
          Stack(
            children: [
              NavigationDestination(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.black87,
                ),
                label: 'Likes',
              ),
              if (SwipesController.to.fetchedLikeProfiles.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 16,
                  child: IgnorePointer(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red[700],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          SwipesController.to.fetchedLikeProfiles.length
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            children: [
              NavigationDestination(
                icon: Icon(
                  Icons.message,
                  color: Colors.black87,
                ),
                label: 'Chats',
              ),
              if (MatchesController.to.fetchedMatchProfiles.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 16,
                  child: IgnorePointer(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red[700],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          MatchesController.to.fetchedMatchProfiles.length
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person,
              color: Colors.black87,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
