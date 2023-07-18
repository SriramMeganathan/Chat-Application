// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
// import 'package:whatsapp_ui/common/enums/message_enum.dart';
// import 'package:whatsapp_ui/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  const DisplayTextImageGIF({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(fontSize: 16),
    );
  }
}
