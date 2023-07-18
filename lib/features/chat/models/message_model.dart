// import 'package:whatsapp_ui/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String recieverid;
  final String text;
  // final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  // final String repliedMessage;
  // final String repliedTo;
  // final MessageEnum repliedMessageType;

  Message({
    required this.senderId,
    required this.recieverid,
    required this.text,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverid': recieverid,
      'text': text,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      recieverid: map['recieverid'] ?? '',
      text: map['text'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
    );
  }
}
