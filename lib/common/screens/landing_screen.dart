import 'package:flutter/material.dart';
import 'package:one_to_one_chat_app/common/constants/colors.dart';
import 'package:one_to_one_chat_app/common/constants/text.dart';
import 'package:one_to_one_chat_app/features/auth/screens/login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appName,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 20),
              ),
              Image.asset(
                landingImageUrl,
                width: size.width * 1,
              ),
              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), color: redColor),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      clickAndContinue,
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
