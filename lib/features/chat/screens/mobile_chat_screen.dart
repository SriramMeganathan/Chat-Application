import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_to_one_chat_app/common/config/text_style.dart';
import 'package:one_to_one_chat_app/common/models/user_model.dart';
import 'package:one_to_one_chat_app/common/widgets/box/horizontal_box.dart';
import 'package:one_to_one_chat_app/common/widgets/box/vertical_box.dart';
import 'package:one_to_one_chat_app/features/auth/controllers/auth_controller.dart';
import 'package:one_to_one_chat_app/features/chat/widgets/bottom_chat_field.dart';
import 'package:one_to_one_chat_app/features/chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profileImage;
  final String members;
  final int? memberId;
  final List? memberIdList;
  const MobileChatScreen({
    Key? key,
    this.memberIdList,
    this.members = "",
    this.memberId,
    required this.isGroupChat,
    required this.name,
    required this.uid,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        shadowColor: const Color.fromRGBO(5, 31, 50, 0.06),
        titleSpacing: 0,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(profileImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style:
                              authScreenheadingStyle().copyWith(fontSize: 20),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: snapshot.data!.isOnline
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const HorizontalBox(width: 5),
                            Text(
                              snapshot.data!.isOnline
                                  ? 'Online'
                                  : snapshot.data!.lastSeen,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromRGBO(118, 112, 109, 1)),
                            ),
                          ],
                        ),
                        const VerticalBox(height: 5),
                      ],
                    ),
                  ],
                ),
              );
            }),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(receiverUserid: uid, isGroupChat: isGroupChat),
          ),
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: BottomChatField(
                  recieverUserId: uid, isGroupChat: isGroupChat)),
        ],
      ),
    );
  }
}
