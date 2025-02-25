import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/base_controller.dart';
import 'package:lume/controllers/matches_controller.dart';
import 'package:lume/controllers/messages_controller.dart';
import 'package:lume/screens/sub_screens/chat_messages.dart';
import 'package:lume/widgets/dialogs/unmatch_confirmation.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  Future<void> onRefresh() async {
    MatchesController.to.fetchMatches();
  }

  void onUnmatch(String id) async {
    await MatchesController.to.unmatchProfile(id);
    Future.delayed(Duration(milliseconds: 20));
    onRefresh();
    BaseController.to.getSnackbar('Unmatched', '', hideMessage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          AnimatedOpacity(
            opacity: MatchesController.to.isMatchesRefreshing.value ? 0 : 1,
            duration: Duration(milliseconds: 200),
            child: IgnorePointer(
              // Not clickable during refresh
              ignoring:
                  MatchesController.to.isMatchesRefreshing.value ? true : false,
              child: RefreshIndicator(
                backgroundColor: Colors.white,
                color: Colors.black,
                onRefresh: onRefresh,
                child: MatchesController.to.isMatchesNotEmpty.value
                    ? ListView.builder(
                        itemCount:
                            MatchesController.to.fetchedMatchProfiles.length,
                        itemBuilder: (context, index) {
                          final String image = MatchesController
                              .to.fetchedMatchProfiles[index]['image1'];

                          final String id = MatchesController
                              .to.fetchedMatchProfiles[index]['user_id'];

                          final String name = MatchesController
                                  .to.fetchedMatchProfiles[index]['name'] ??
                              '';

                          String userId = MatchesController
                              .to.matchProfileImages.keys
                              .elementAt(index);
                          String? filePath =
                              MatchesController.to.matchProfileImages[userId] ??
                                  '';

                          return Slidable(
                            startActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: const ScrollMotion(),
                              children: [
                                CustomSlidableAction(
                                  onPressed: (_) => showDialog(
                                    context: context,
                                    builder: (context) {
                                      return UnmatchConfirmation(id: id);
                                    },
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 250, 95, 93),
                                  foregroundColor: Colors.black,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.delete_rounded,
                                          size: 22,
                                        ),
                                        Text(
                                          'Unmatch',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () async {
                                MessagesController
                                        .to.currentChatTargetId.value =
                                    MatchesController.to
                                        .fetchedMatchProfiles[index]['user_id'];

                                await MessagesController.to.fetchMessages();

                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      final tween = Tween(
                                              begin: Offset(0, 1),
                                              end: Offset(0, 0))
                                          .chain(CurveTween(
                                              curve: Curves.easeInOut));
                                      final offsetAnim = animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnim,
                                        child: child,
                                      );
                                    },
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return ChatMessages(
                                          pfp: image, name: name);
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                child: Row(
                                  spacing: 16,
                                  children: [
                                    ClipOval(
                                      child: image.isNotEmpty
                                          ? Image.file(
                                              File(filePath),
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/avatar.png',
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Tap to chat',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : AnimatedOpacity(
                        opacity: MatchesController.to.isMatchesRefreshing.value
                            ? 0
                            : 1,
                        duration: Duration(milliseconds: 200),
                        child: Center(
                          child: Column(
                            spacing: 16,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('No matches yet, but you can change that!'),
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
                                onPressed: () =>
                                    MatchesController.to.fetchMatches(),
                                child: Text('Refresh'),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),

          // Loading indicator
          AnimatedOpacity(
            opacity: MatchesController.to.isMatchesRefreshing.value ? 1 : 0,
            duration: Duration(milliseconds: 200),
            child: IgnorePointer(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
