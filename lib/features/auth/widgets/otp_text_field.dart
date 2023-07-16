import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_to_one_chat_app/common/config/text_style.dart';

class OTPFormField extends StatelessWidget {
  const OTPFormField({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.onChange,
  }) : super(key: key);
  final ValueSetter<String>? onChange;
  final FocusNode focusNode;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        autofocus: true,
        style: pinStyle,
        keyboardType: TextInputType.number,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        decoration: otpInputDecoration,
        cursorColor: Colors.black,
        cursorHeight: 30,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: onChange);
  }
}
