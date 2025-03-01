import 'package:flutter/material.dart';

class RefreshButton extends StatefulWidget {
  final VoidCallback onPressed;

  const RefreshButton({super.key, required this.onPressed});

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: widget.onPressed,
      child: Text('Refresh'),
    );
  }
}
