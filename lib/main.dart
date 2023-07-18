import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_to_one_chat_app/common/config/size_config.dart';
import 'package:one_to_one_chat_app/common/config/theme.dart';
import 'package:one_to_one_chat_app/common/screens/landing_screen.dart';
import 'package:one_to_one_chat_app/common/screens/mobile_layout_screen.dart';
import 'package:one_to_one_chat_app/features/auth/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: Themes().lightTheme(context),
      home: ref.watch(userdataProvider).when(
          data: (user) {
            if (user == null) {
              return const LandingScreen();
            } else {
              return const MobileLayoutScreen();
            }
          },
          error: (error, trace) {
            return ErrorWidget(error.toString());
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator()))),
    );
  }
}
