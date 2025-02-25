import 'package:flutter/material.dart';

class ProfileDetailBox extends StatelessWidget {
  final List<Widget> children;

  final Color? color;

  final EdgeInsetsGeometry? outerPadding;

  final EdgeInsetsGeometry? innerPadding;

  const ProfileDetailBox({
    super.key,
    required this.children,
    this.color,
    this.outerPadding,
    this.innerPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          outerPadding ?? EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        padding:
            innerPadding ?? EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          // default white bg unless given
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
