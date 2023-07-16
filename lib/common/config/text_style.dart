import 'package:flutter/material.dart';
import 'package:one_to_one_chat_app/common/config/size_config.dart';

// hindtext constant textstyle
TextStyle authScreenheadingStyle() => TextStyle(
    fontWeight: FontWeight.w700,
    color: const Color.fromRGBO(27, 16, 11, 1),
    fontSize: getProportionateScreenWidth(30));

// subtitle constant textstyle
TextStyle authScreensubTitleStyle() => TextStyle(
    fontWeight: FontWeight.w500,
    color: const Color.fromRGBO(5, 31, 50, 0.6),
    fontSize: getProportionateScreenWidth(14));

TextStyle textFieldHeadingStyle() => TextStyle(
    fontWeight: FontWeight.w400,
    color: const Color.fromRGBO(27, 16, 11, 0.6),
    fontSize: getProportionateScreenWidth(14));

// errorstyle constant textstyle
// TextStyle errorStyle() => TextStyle(
//     fontWeight: FontWeight.w500,
//     color: CustomColor.errorFieldColor,
//     fontSize: getProportionateScreenWidth(14));
// TextStyle headingTextStyle() => TextStyle(
//     fontWeight: FontWeight.w600, fontSize: getProportionateScreenWidth(36));

TextStyle pinStyle = TextStyle(
    fontSize: getProportionateScreenWidth(24), fontWeight: FontWeight.bold);

final otpTextFieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1)),
);
final otpInputDecoration = InputDecoration(
  fillColor: const Color.fromRGBO(242, 242, 242, 1),
  filled: true,
  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
  border: otpTextFieldBorder,
  focusedBorder: otpTextFieldBorder.copyWith(
    borderSide: const BorderSide(color: Color.fromRGBO(242, 242, 242, 1)),
  ),
  enabledBorder: otpTextFieldBorder,
);
