import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/messages_controller.dart';
import 'package:lume/widgets/dialogs/delete_message_confirmation.dart';
import 'package:lume/widgets/dialogs/unmatch_confirmation.dart';

class ChatMessages extends StatefulWidget {
  final String pfp;
  final String name;

  const ChatMessages({super.key, required this.pfp, required this.name});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  Timer? timer;
  final TextEditingController messageController = TextEditingController();

  void _onSend() async {
    if (messageController.text.isNotEmpty) {
      await MessagesController.to.sendMessage(messageController.text);

      messageController.clear();

      MessagesController.to.scrollToBottom();
    }
  }

  void _scrolltoBottomOnStart() async {
    await Future.delayed(Duration(milliseconds: 500));
    MessagesController.to.scrollToBottom();
  }

  @override
  void initState() {
    super.initState();

    _scrolltoBottomOnStart();

    timer = Timer.periodic(
      Duration(seconds: 5),
      (Timer t) => MessagesController.to.fetchMessages(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: InkWell(
          onTap: () {},
          child: Row(
            spacing: 8,
            children: [
              ClipOval(
                child: Image.memory(
                  width: 32,
                  height: 32,
                  BaseController.to.convertImage(widget.pfp),
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Row(
              spacing: 8,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.report_outlined),
                ),
                IconButton(
                  onPressed: () async {
                    bool? result = await showDialog(
                      context: context,
                      builder: (context) {
                        return UnmatchConfirmation(
                            id: MessagesController
                                .to.currentChatTargetId.value);
                      },
                    );

                    // Close messages screen after unmatch if dialog results was true
                    if (result == true) {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  icon: Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            Container(
              child: ListView.builder(
                reverse: true,
                controller: MessagesController.to.scrollController,
                physics: BouncingScrollPhysics(),
                itemCount: MessagesController.to.fetchedMessages.length,
                itemBuilder: (context, index) {
                  bool isMyMessage = MessagesController
                          .to.fetchedMessages[index]['sender_id'] ==
                      AuthController.to.userId.value;

                  bool isFirst = index == 0;
                  // bool isLast = index == MessagesController.to.fetchedMessages.length - 1;

                  return InkWell(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteMessageConfirmation(
                            isMyMessage: isMyMessage,
                            index: index,
                          );
                        },
                      );
                    },
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 4,
                          bottom: isFirst ? 84 : 4),
                      child: Row(
                        mainAxisAlignment: isMyMessage
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              // alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isMyMessage
                                    ? Colors.blue[300]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                MessagesController.to.fetchedMessages[index]
                                        ['message'] ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withAlpha(0),
                        Colors.white,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Input bg blur
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              ),
            ),

            // Message send input
            Positioned(
              bottom: 4,
              left: 4,
              right: 4,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 74,
                  maxHeight: 74,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: 74,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 24, right: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(98, 200, 200, 200),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            maxLength: 1000,
                            onTap: () async {
                              await Future.delayed(Duration(milliseconds: 500));
                              MessagesController.to.scrollToBottom();
                            },
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            maxLines: null,
                            expands: true,
                            textInputAction: TextInputAction.newline,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              filled: false,
                              hintText: 'Message...',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                              counterStyle: TextStyle(fontSize: 0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _onSend(),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          icon: Icon(
                            Icons.send_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
