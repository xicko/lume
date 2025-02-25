import 'package:flutter/material.dart';

class EditLifestyle extends StatefulWidget {
  const EditLifestyle({super.key});

  @override
  State<EditLifestyle> createState() => _EditLifestyleState();
}

class _EditLifestyleState extends State<EditLifestyle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 0,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Basic',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        InkWell(
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
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Pets',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
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
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Drinking',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
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
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Smoking',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
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
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Workout',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
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
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Dietary Preference',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
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
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Social Media',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
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
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sleeping Habits',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
