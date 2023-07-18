import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_to_one_chat_app/common/models/user_model.dart';
import 'package:one_to_one_chat_app/features/chat/models/chat_contact.dart';
import 'package:one_to_one_chat_app/features/chat/models/message_model.dart';
import 'package:one_to_one_chat_app/features/chat/repo/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});
  Stream<List<ChatContact>> chatContact() {
    return chatRepository.getContacts();
  }

  Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  Stream<List<Message>> groupChatStream(String groupId) {
    return chatRepository.getgroupStream(groupId);
  }

  Future<void> sentTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
    bool isGroupChat,
  ) async {
    UserModel? user;
    Future<UserModel?> getCurrentUserData() async {
      var userdata = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (userdata.data() != null) {
        try {
          user = UserModel.fromMap(userdata.data()!);
        } catch (e) {
          print(e.toString());
        }
      }
      return user;
    }

    user = await getCurrentUserData();
    if (user != null) {
      try {
        await chatRepository.sentTextMessage(
          isGroupChat: isGroupChat,
          context: context,
          text: text,
          receiverUserId: receiverUserId,
          sendUser: user!,
        );
        print('Text message sent successfully');
      } catch (e) {
        print('Error sending text message: $e');
      }
    } else {
      print('User data is null');
    }
  }
  // void sentTextMessage(BuildContext context, String text, String receiverUserId,
  //     bool isGroupChat) async {
  //   print("123456789");
  //   print(text);

  //   ref.read(userdataProvider).whenData((value) =>
  //       chatRepository.sentTextMessage(
  //           isGroupChat: isGroupChat,
  //           context: context,
  //           text: text,
  //           receiverUserId: receiverUserId,
  //           sendUser: value!));
  //   print(text);
  // }

  void setChatMessageSeen(
      BuildContext context, String receiverUserid, String messageId) {
    chatRepository.setMessageSeen(context, receiverUserid, messageId);
  }

  Stream<List<Message>> getLastMessage(String receiverUserid) {
    return chatRepository.getlastMessage(receiverUserid);
  }
}
