import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_to_one_chat_app/common/config/text_style.dart';
import 'package:one_to_one_chat_app/features/chat/controllers/chat_controller.dart';
import 'package:one_to_one_chat_app/features/chat/models/chat_contact.dart';
import 'package:one_to_one_chat_app/features/chat/models/message_model.dart';
import 'package:one_to_one_chat_app/features/chat/screens/mobile_chat_screen.dart';

class ContactsList extends ConsumerStatefulWidget {
  const ContactsList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactsListState();
}

class _ContactsListState extends ConsumerState<ContactsList> {
  FirebaseFirestore? firestore;
  Message? _message;
  String? time;
  String? changeTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<List<ChatContact>>(
                    stream: ref.watch(chatControllerProvider).chatContact(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data == null) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.4),
                          child: const Center(child: Text("No Messages here")),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var chatContactData = snapshot.data![index];

                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MobileChatScreen(
                                                  isGroupChat: false,
                                                  name: chatContactData.name,
                                                  uid:
                                                      chatContactData.contactId,
                                                  profileImage: chatContactData
                                                      .profilePic)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ListTile(
                                    title: Text(
                                      chatContactData.name,
                                      style: authScreenheadingStyle()
                                          .copyWith(fontSize: 15),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection("chats")
                                            .doc(chatContactData.contactId)
                                            .collection("messages")
                                            .orderBy('timeSent',
                                                descending: true)
                                            .limit(1)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var messageData =
                                                snapshot.data!.docs;

                                            final List<Message> messages =
                                                messageData
                                                    .map((e) => Message.fromMap(
                                                        e.data()))
                                                    .toList();

                                            if (messages.isNotEmpty) {
                                              _message = messages[0];
                                            }

                                            if (FirebaseAuth.instance
                                                    .currentUser!.uid ==
                                                _message?.senderId) {
                                              return Text(
                                                chatContactData.lastMessage,
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 15,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            } else if (_message == null) {
                                              return const Text(
                                                  "No Message yet....");
                                            } else if (_message!.isSeen) {
                                              return Text(
                                                chatContactData.lastMessage,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            } else {
                                              return Text(
                                                chatContactData.lastMessage,
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 15,
                                                  color: Color.fromRGBO(
                                                      237, 84, 60, 1),
                                                ),
                                              );
                                            }
                                          } else {
                                            return Text(
                                              chatContactData.lastMessage,
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    leading: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              chatContactData.profilePic),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    trailing: StreamBuilder<
                                        QuerySnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection("chats")
                                          .doc(chatContactData.contactId)
                                          .collection("messages")
                                          .orderBy('timeSent', descending: true)
                                          .limit(1)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var messageData = snapshot.data!.docs;

                                          final List<Message> messages =
                                              messageData
                                                  .map((e) =>
                                                      Message.fromMap(e.data()))
                                                  .toList();

                                          DateTime timeSent =
                                              messages[0].timeSent;
                                          DateTime currentDate = DateTime.now();
                                          DateTime yesterdayDate =
                                              currentDate.subtract(
                                                  const Duration(days: 1));

                                          if (timeSent.year ==
                                                  currentDate.year &&
                                              timeSent.month ==
                                                  currentDate.month &&
                                              timeSent.day == currentDate.day) {
                                            changeTime = DateFormat('h:mm a')
                                                .format(timeSent);
                                          } else if (timeSent.year ==
                                                  yesterdayDate.year &&
                                              timeSent.month ==
                                                  yesterdayDate.month &&
                                              timeSent.day ==
                                                  yesterdayDate.day) {
                                            changeTime = 'Yesterday';
                                          } else {
                                            changeTime =
                                                DateFormat('MMM d, h:mm a')
                                                    .format(timeSent);
                                          }

                                          if (messages.isNotEmpty) {
                                            _message = messages[0];
                                          }

                                          if (FirebaseAuth
                                                  .instance.currentUser!.uid ==
                                              _message?.senderId) {
                                            return Text(
                                              changeTime!,
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            );
                                          } else if (_message == null) {
                                            return const SizedBox.shrink();
                                          } else if (_message!.isSeen) {
                                            return Text(
                                              changeTime!,
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            );
                                          } else {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  changeTime!,
                                                  style: const TextStyle(
                                                      color: Colors.red),
                                                ),
                                                StreamBuilder<
                                                        QuerySnapshot<
                                                            Map<String,
                                                                dynamic>>>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection("users")
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .collection("chats")
                                                        .doc(chatContactData
                                                            .contactId)
                                                        .collection("messages")
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        int trueMessagesCount =
                                                            0;
                                                        final messages =
                                                            snapshot.data!.docs;
                                                        for (final message
                                                            in messages) {
                                                          final isSeen = message
                                                              .data()['isSeen'];
                                                          if (isSeen == false) {
                                                            trueMessagesCount++;
                                                          }
                                                        }
                                                        return CircleAvatar(
                                                          radius: 10,
                                                          backgroundColor:
                                                              const Color
                                                                      .fromRGBO(
                                                                  237,
                                                                  84,
                                                                  60,
                                                                  1),
                                                          child: Text(
                                                            trueMessagesCount
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        );
                                                      } else {
                                                        return const CircularProgressIndicator();
                                                      }
                                                    }),
                                              ],
                                            );
                                          }
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(color: Colors.grey, indent: 85),
                            ],
                          );
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
