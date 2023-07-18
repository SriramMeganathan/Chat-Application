import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_to_one_chat_app/features/chat/controllers/chat_controller.dart';
import 'package:one_to_one_chat_app/features/chat/widgets/attachment_components.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const BottomChatField({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  bool isShowEmojiContainer = false;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isContainerVisible = false;

  void isShownContainer() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyBoard() => focusNode.requestFocus();
  void hideKeyBoard() => focusNode.unfocus();

  void toggleEmojiKeyBoardContainer() {
    if (isShowEmojiContainer) {
      showKeyBoard();
      hideEmojiContainer();
    } else {
      hideKeyBoard();
      showEmojiContainer();
    }
  }

  @override
  void initState() {
    super.initState();

    sentTextMessage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  void sentTextMessage() {
    if (mounted) {
      if (isShowSendButton) {
        ref.read(chatControllerProvider).sentTextMessage(
            context,
            _messageController.text.trim(),
            widget.recieverUserId,
            widget.isGroupChat);

        setState(() {
          _messageController.text = '';
          isShowSendButton = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          isContainerVisible
              ? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(27, 16, 11, 0.08),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 40),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const AttachmentWidgets(
                                icons: Icons.browse_gallery,
                                color: Color.fromRGBO(229, 217, 243, 1),
                                title: 'Image'),
                          ),
                          InkWell(
                            onTap: () {},
                            child: const AttachmentWidgets(
                                icons: Icons.video_file,
                                color: Color.fromRGBO(183, 199, 242, 1),
                                title: 'Video'),
                          ),
                          InkWell(
                            onTap: () {},
                            child: const AttachmentWidgets(
                                icons: Icons.edit_document,
                                color: Color.fromRGBO(253, 233, 209, 1),
                                title: 'Document'),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(
            height: 16,
          ),
          Container(
            height: 60,
            width: double.maxFinite,
            decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(237, 236, 235, 1),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromRGBO(255, 255, 255, 1)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => isShownContainer(),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
                      child: Icon(
                        isContainerVisible ? Icons.close : Icons.add,
                        color: const Color.fromRGBO(118, 112, 109, 1),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      onChanged: (val) {
                        if (val.isEmpty) {
                          setState(() {
                            isShowSendButton = false;
                          });
                        } else {
                          setState(() {
                            isShowSendButton = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(255, 255, 255, 1),
                        hintText: 'Type a message',
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(27, 16, 11, 0.6),
                            fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: sentTextMessage,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color.fromRGBO(237, 84, 60, 1),
                      child: Icon(
                        Icons.send,
                        color: isShowSendButton
                            ? Colors.white
                            : const Color.fromARGB(255, 215, 214, 214),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
