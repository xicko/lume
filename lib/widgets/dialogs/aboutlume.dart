import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutLume extends StatelessWidget {
  const AboutLume({super.key});

  void openLink(String url) {
    launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        bottom: 160,
        left: 40,
        right: 40,
      ),
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'About Lume',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lume is an open-source online dating app made with Flutter and Supabase.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Made by Dashnyam Batbayar (XICKO)',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              Row(
                spacing: 8,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => openLink('https://github.com/xicko/lume'),
                    child: Text('GitHub Repo'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => openLink('https://www.dashnyam.com'),
                    child: Text('Creator Website'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
