import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_to_one_chat_app/common/utils/utils.dart';
import 'package:one_to_one_chat_app/common/widgets/box/horizontal_box.dart';
import 'package:one_to_one_chat_app/features/auth/controllers/auth_controller.dart';

import '../../../common/config/text_style.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';

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
      print(isLoad);
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else if (country == null) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${countrys.phoneCode}$phoneNumber');
    } else {
      showSnackBar(
          context: context, content: 'Please select your country code');
    }
    Future.delayed(const Duration(milliseconds: 2000), () {
      isLoad = false;
      setState(() {});
    });
    print("123$isLoad");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // showAlertDialog(context);
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
                    onTap: () {
                      // showAlertDialog(context);
                    },
                    child: const Icon(Icons.arrow_back_outlined)),
                Text(
                  "Enter your phone number",
                  style: authScreenheadingStyle(),
                ),
                // const VerticalBox(height: 12),
                // const VerticalBox(height: 24),
                Text(
                  "Phone number",
                  style: textFieldHeadingStyle(),
                ),
                // TextButton(
                //     onPressed: pickCountry, child: const Text("Pick country")),
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
                                "+${country!.phoneCode}",
                                // style: authScreensubTitleStyle(),
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
                        },
                        // style: authScreensubTitleStyle().copyWith(fontSize: 15),
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
                                color: Colors.green),
                            child: Center(
                                child: isLoad
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        'Continue',
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
                                  : const Text(
                                      'Continue',
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

//   showAlertDialog(BuildContext context) {
//     showAnimatedDialog(
//       context: context,
//       barrierDismissible: true,

//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: const SizedBox.shrink(),
//           content: const Padding(
//             padding: EdgeInsets.only(left: 12, right: 12),
//             child: Text(
//               "Do you want to Exit app?",
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//           actions: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Container(
//                 height: getProportionateScreenHeight(44),
//                 width: getProportionateScreenWidth(120),
//                 decoration: BoxDecoration(
//                     boxShadow: const [
//                       BoxShadow(
//                           color: Color.fromARGB(255, 187, 179, 179),
//                           // offset: Offset(
//                           //   20,
//                           //   20,
//                           // ),
//                           blurRadius: 25),
//                     ],
//                     borderRadius: BorderRadius.circular(12),
//                     color: const Color.fromRGBO(255, 255, 255, 1)),
//                 child: const Center(child: Text("Cancel")),
//               ),
//             ),
//             GestureDetector(
//               onTap: () async {
//                 SystemNavigator.pop();
//               },
//               child: Container(
//                 height: getProportionateScreenHeight(44),
//                 width: getProportionateScreenWidth(120),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: const Color.fromRGBO(254, 86, 49, 1)),
//                 child: const Center(
//                     child: Text(
//                   "Confirm",
//                   style: TextStyle(color: Colors.white),
//                 )),
//               ),
//             ),
//             SizedBox(
//               width: getProportionateScreenWidth(5),
//             )
//           ],
//         );
//       },

//       animationType: DialogTransitionType.size,

//       curve: Curves.fastOutSlowIn,

// // duration: const Duration(seconds: 1),
//     );
//   }
}
