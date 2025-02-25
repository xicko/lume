import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lume/controllers/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessagesController extends GetxController {
  static MessagesController get to => Get.find();

  RxList<Map<String, dynamic>> fetchedMessages = <Map<String, dynamic>>[].obs;

  RxString currentChatTargetId = ''.obs;

  final ScrollController scrollController = ScrollController();

  Future<void> sendMessage(String message) async {
    final supabase = Supabase.instance.client;
    final userId = AuthController.to.userId.value;
    final targetId = currentChatTargetId.value;

    try {
      await supabase.from('lume_messages').insert({
        'sender_id': userId,
        'receiver_id': targetId,
        'sent_at': DateTime.now().toUtc().toIso8601String(),
        'message': message,
      });

      fetchMessages();
      fetchedMessages.refresh;
      debugPrint('message sent');
    } catch (e) {
      debugPrint('send message error: $e');
    }
  }

  Future<void> fetchMessages() async {
    final supabase = Supabase.instance.client;
    final userId = AuthController.to.userId.value;
    final targetId = currentChatTargetId.value;

    try {
      final res = await supabase
          .from('lume_messages')
          .select()
          .or('sender_id.eq.$userId,receiver_id.eq.$userId')
          .or('sender_id.eq.$targetId,receiver_id.eq.$targetId')
          .order('sent_at', ascending: false);

      fetchedMessages.assignAll(res);
      fetchedMessages.refresh;
    } catch (e) {
      debugPrint('fetch messages error: $e');
    }
  }

  void scrollToBottom() async {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  Future<void> deleteMessage(String messageId) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('lume_messages').delete().eq('id', messageId);
      fetchMessages();
      fetchedMessages.refresh;
      debugPrint('message deleted');
    } catch (e) {
      debugPrint('delete message error: $e');
    }
  }
}
