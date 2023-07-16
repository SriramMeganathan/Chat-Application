import 'package:flutter/material.dart';
import 'package:one_to_one_chat_app/common/config/size_config.dart';

class HorizontalBox extends StatelessWidget {
  const HorizontalBox({
    Key? key,
    required this.width,
  }) : super(key: key);
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(width),
    );
  }
}
