import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quiz_app/screens/account/my_account.dart';
import 'package:quiz_app/screens/login/login.dart';
import 'package:quiz_app/screens/register/register.dart';
import 'package:quiz_app/screens/start/start.dart';
import 'package:quiz_app/screens/home/home.dart';
import 'package:quiz_app/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const QuizApp());
}
class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.routeName,
      routes: {
        StartScreen.routeName: (context) => const StartScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        AccountScreen.routeName: (context) => const AccountScreen(),
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
