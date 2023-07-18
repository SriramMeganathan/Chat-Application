import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_to_one_chat_app/common/config/text_style.dart';
import 'package:one_to_one_chat_app/common/constants/text.dart';
import 'package:one_to_one_chat_app/common/widgets/box/horizontal_box.dart';
import 'package:one_to_one_chat_app/features/auth/controllers/auth_controller.dart';
import 'package:one_to_one_chat_app/features/auth/screens/profile_screen.dart';
import 'package:one_to_one_chat_app/features/chat/widgets/contacts_list.dart';
import 'package:one_to_one_chat_app/features/contact/screens/select_contacts_screens.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    ref.read(authControllerProvider).setuserState(true);

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  updateLastSeen() {
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);
    String formattedTime = DateFormat.jm().format(now);
    String result = 'Last seen $formattedDate $formattedTime ';
    return result;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setuserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setuserState(false);
        ref.read(authControllerProvider).setLastSeenData(updateLastSeen());

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        title: Text(oneToOne, style: authScreenheadingStyle()),
        actions: [
          const HorizontalBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(onTap: () {}, child: const ProfilePic()),
          )
        ],
      ),
      body: const ContactsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SelectContactsScreen()));
        },
        backgroundColor: const Color.fromRGBO(237, 84, 60, 1),
        child: const Icon(
          Icons.message,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ProfilePic extends ConsumerWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = FirebaseAuth.instance;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }

          var data = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 3,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()));
                },
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(data['profilePic']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
