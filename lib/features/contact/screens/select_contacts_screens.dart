import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_to_one_chat_app/common/config/text_style.dart';
import 'package:one_to_one_chat_app/features/contact/controller/select_contact_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Select Contacts"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactsList) {
              if (contactsList.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.4),
                  child: const Center(child: Text("No Messages here")),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: contactsList.length,
                itemBuilder: (context, index) {
                  final contact = contactsList[index];
                  return InkWell(
                    onTap: () {
                      print(contact.displayName);
                      selectContact(ref, contact, context);
                    },
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: authScreenheadingStyle().copyWith(fontSize: 18),
                      ),
                      leading: SizedBox(
                        height: 50,
                        width: 50,
                        child:
                            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasData) {
                              final messages = snapshot.data!.docs;
                              var profilePic =
                                  'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png';
                              final phoneNumber = contact.phones.isNotEmpty
                                  ? contact.phones[0].number.replaceAll(' ', '')
                                  : '';

                              for (final message in messages) {
                                final messageData = message.data();
                                if (messageData['phoneNumber'] == phoneNumber) {
                                  profilePic = messageData['profilePic'];
                                  break;
                                }
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(profilePic),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                        'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, trace) => Text(error.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
