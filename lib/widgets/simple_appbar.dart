import 'package:flutter/material.dart';
import 'package:lume/controllers/feed_controller.dart';
import 'package:lume/widgets/dialogs/aboutlume.dart';
import 'package:lume/widgets/dialogs/app_settings_bottomsheet.dart';

class SimpleAppbar extends StatelessWidget {
  const SimpleAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          onTap: () => showModalBottomSheet(
            context: context,
            showDragHandle: true,
            backgroundColor: Colors.white,
            builder: (context) {
              return AboutLume();
            },
          ),
          child: Row(
            spacing: 4,
            children: [
              Image.asset(
                'assets/lumetransparent.png',
                width: 28,
                height: 28,
              ),
              Text(
                'Lume',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              backgroundColor: Colors.grey[100],
              builder: (context) {
                return AppSettingsBottomsheet();
              },
            );

            await Future.delayed(Duration(milliseconds: 200));
            FeedController.to.fetchFeed();
          },
          icon: Icon(
            Icons.tune,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
