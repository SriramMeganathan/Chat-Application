import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_to_one_chat_app/common/constants/colors.dart';
import 'package:one_to_one_chat_app/common/constants/text.dart';
import 'package:one_to_one_chat_app/common/utils/utils.dart';
import 'package:one_to_one_chat_app/common/widgets/box/horizontal_box.dart';
import 'package:one_to_one_chat_app/common/widgets/box/vertical_box.dart';
import 'package:one_to_one_chat_app/features/auth/controllers/auth_controller.dart';

import '../../../common/config/text_style.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phonenumberController = TextEditingController();
  Country? country;
  bool isLoad = false;
  var countrys = Country(
    phoneCode: '+91',
    countryCode: 'IN',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'India',
    example: '9123456789',
    displayName: 'India (IN) [+91]',
    displayNameNoCountryCode: 'India (IN)',
    e164Key: '91-IN-0',
  );

  void defaultpickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country country) {
          setState(() {
            countrys = country;
          });
        });
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country country) {
          setState(() {
            country = country;
          });
        });
  }

  @override
  void initState() {
    super.initState();
    errortext = '';
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    phonenumberController.dispose();
  }

  bool isLoading = false;
  bool isButtonEnable = false;
  String errortext = '';

  void sendPhoneNumber() async {
    String phoneNumber = phonenumberController.text.trim();
    setState(() {
      isLoad = true;
    });
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '${country!.phoneCode}$phoneNumber');
    } else if (country == null) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '${countrys.phoneCode}$phoneNumber');
    } else {
      showSnackBar(
          context: context, content: 'Please select your country code');
    }
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        isLoad = false;
      });
    });
    print("123$isLoad");
  }

  mobileNumberOnChanged(String value) {
    if (value.isEmpty) {
      isButtonEnable = false;
      errortext = 'Enter your valid mobile number';
      setState(() {});
    } else if (value.length < 10) {
      isButtonEnable = false;
      errortext = 'Enter your valid mobile number';

      setState(() {});
    } else {
      errortext = '';

      isButtonEnable = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {}, child: const Icon(Icons.arrow_back_outlined)),
                Text(
                  "Enter your phone number",
                  style: authScreenheadingStyle(),
                ),
                const VerticalBox(height: 24),
                Text(
                  "Phone number",
                  style: textFieldHeadingStyle(),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color.fromRGBO(242, 242, 242, 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (country != null)
                              Text(
                                country!.phoneCode,
                              )
                            else
                              Text(countrys.phoneCode),
                            GestureDetector(
                                onTap: () {
                                  pickCountry();
                                },
                                child: const Icon(Icons.expand_more_rounded))
                          ],
                        ),
                      ),
                    ),
                    const HorizontalBox(width: 8),
                    SizedBox(
                      width: size.width * 0.7,
                      child: TextField(
                        controller: phonenumberController,
                        autofocus: true,
                        decoration: InputDecoration(
                            fillColor: const Color.fromRGBO(242, 242, 242, 1),
                            filled: true,
                            hintText: 'type here',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.transparent)),
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 12, 0, 0)),
                        cursorWidth: 1.2,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (value) {
                          mobileNumberOnChanged(value);
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  errortext,
                  style: const TextStyle(color: Colors.red),
                ),
                const Spacer(),
                isButtonEnable
                    ? InkWell(
                        onTap: () => sendPhoneNumber(),
                        child: Container(
                            height: 54,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(41),
                                color: greenColor),
                            child: Center(
                                child: isLoad
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        conTinue,
                                      ))),
                      )
                    : InkWell(
                        onTap: () {},
                        child: Container(
                          height: 54,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(41),
                              color: const Color.fromRGBO(237, 84, 60, 1)),
                          child: Center(
                              child: isLoad
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text(
                                      conTinue,
                                    )),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
