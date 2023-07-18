import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_to_one_chat_app/common/models/user_model.dart';
import 'package:one_to_one_chat_app/common/utils/utils.dart';
import 'package:one_to_one_chat_app/features/chat/models/chat_contact.dart';
import 'package:one_to_one_chat_app/features/chat/models/message_model.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getContacts() {
    return firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection("users")
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      print(contacts[0].name);

      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(receiverUserId)
        .collection("messages")
        .orderBy("timeSent")
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Stream<List<Message>> getgroupStream(String groupId) {
    return firestore
        .collection("groups")
        .doc(groupId)
        .collection("chats")
        .orderBy("timeSent")
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactSubCollection(
      UserModel senderuserData,
      UserModel? receiverUserData,
      String text,
      DateTime timeSent,
      String receiveruserId,
      bool isGroupChat) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(receiveruserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch
      });
    } else {
      var receiverChatContact = ChatContact(
          name: senderuserData.name,
          profilePic: senderuserData.profilePic,
          contactId: senderuserData.uid,
          timeSent: timeSent,
          lastMessage: text);
      await firestore
          .collection("users")
          .doc(receiveruserId)
          .collection("chats")
          .doc(auth.currentUser!.uid)
          .set(receiverChatContact.toMap());

      var senderChatContact = ChatContact(
          name: receiverUserData!.name,
          profilePic: receiverUserData.profilePic,
          contactId: receiverUserData.uid,
          timeSent: timeSent,
          lastMessage: text);
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("chats")
          .doc(receiveruserId)
          .set(senderChatContact.toMap());
    }
  }

  void _saveMessagetoMessageSubCollection(
      {required String receiverUserId,
      required String text,
      required DateTime timeSent,
      required String messageId,
      required String username,
      required String? receiverUserName,
      required bool isGroupChat}) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: receiverUserId,
      text: text,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );
    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(receiverUserId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
    } else {
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("chats")
          .doc(receiverUserId)
          .collection("messages")
          .doc(messageId)
          .set(message.toMap());

      await firestore
          .collection("users")
          .doc(receiverUserId)
          .collection("chats")
          .doc(auth.currentUser!.uid)
          .collection("messages")
          .doc(messageId)
          .set(message.toMap());
    }
  }

  sentTextMessage(
      {required BuildContext context,
      required String text,
      required String receiverUserId,
      required UserModel sendUser,
      required bool isGroupChat}) async {
    try {
      print("oii");

      var timesent = DateTime.now();
      UserModel? receiverdata;
      if (!isGroupChat) {
        var userdatamap =
            await firestore.collection("users").doc(receiverUserId).get();
        receiverdata = UserModel.fromMap(userdatamap.data()!);
      }

      var messageId = const Uuid().v4();
      _saveDataToContactSubCollection(
          sendUser, receiverdata, text, timesent, receiverUserId, isGroupChat);
      _saveMessagetoMessageSubCollection(
          isGroupChat: isGroupChat,
          receiverUserId: receiverUserId,
          text: text,
          timeSent: timesent,
          messageId: messageId,
          receiverUserName: receiverdata?.name,
          username: sendUser.name);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setMessageSeen(
      BuildContext context, String receiverUserId, String messageId) async {
    try {
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("chats")
          .doc(receiverUserId)
          .collection("messages")
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection("users")
          .doc(receiverUserId)
          .collection("chats")
          .doc(auth.currentUser!.uid)
          .collection("messages")
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<Message>> getlastMessage(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent', descending: true)
        .limit(1)
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }
}
