import 'package:flutter/material.dart';

class ProfileInfoSingle extends StatefulWidget {
  final String label;
  final String buttonText;
  final Function onTap;

  const ProfileInfoSingle({
    super.key,
    required this.label,
    required this.buttonText,
    required this.onTap,
  });

  @override
  State<ProfileInfoSingle> createState() => _ProfileInfoSingleState();
}

class _ProfileInfoSingleState extends State<ProfileInfoSingle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => widget.onTap(),
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
                  Expanded(
                    child: Text(
                      widget.buttonText,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
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
