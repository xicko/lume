import 'package:flutter/material.dart';
import 'package:lume/controllers/messages_controller.dart';

class DeleteMessageConfirmation extends StatelessWidget {
  final bool isMyMessage;
  final int index;

  const DeleteMessageConfirmation(
      {super.key, required this.isMyMessage, required this.index});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Confirm delete',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this message?',
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

            // Delete btn
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  if (isMyMessage) {
                    await MessagesController.to.deleteMessage(
                        MessagesController.to.fetchedMessages[index]['id']);
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
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
                  'Delete',
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
