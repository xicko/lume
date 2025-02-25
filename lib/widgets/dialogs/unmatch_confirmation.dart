import 'package:flutter/material.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/matches_controller.dart';

class UnmatchConfirmation extends StatelessWidget {
  final String id;

  const UnmatchConfirmation({super.key, required this.id});

  void onUnmatch(String id) async {
    await MatchesController.to.unmatchProfile(id);
    Future.delayed(Duration(milliseconds: 20));
    MatchesController.to.fetchMatches();
    BaseController.to.getSnackbar('Unmatched', '', hideMessage: true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Confirm unmatch',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      content: Text(
        'Are you sure you want to unmatch?',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 0,
      ),
      actions: [
        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel btn
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  FocusScope.of(context).unfocus();
                },
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                      ),
                    ),
                    elevation: 0,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[800]
                            : Colors.grey[300],
                    foregroundColor: Colors.black),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Unmatch btn
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  onUnmatch(id);

                  if (context.mounted) {
                    Navigator.pop(context, true);
                    FocusScope.of(context).unfocus();
                  }
                },
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 255, 101, 101),
                    foregroundColor: Colors.black),
                child: Text(
                  'Unmatch',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
