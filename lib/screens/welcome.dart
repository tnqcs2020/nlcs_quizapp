import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/start/start.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/home.dart';

String? finalEmail;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String routeName = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;

  @override
  void initState() {
    getValidationData().whenComplete(() async {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushNamed(
              context,
              (finalEmail == null)
                  ? StartScreen.routeName
                  : HomeScreen.routeName));
    });
    controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    animation = ColorTween(begin: Colors.white70, end: Colors.white)
        .animate(controller!);
    controller!.forward();
    controller!.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = obtainedEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.indigo, Colors.red],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(90, 0, 0, 0),
                width: 240.0,
                child: DefaultTextStyle(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 80.0,
                    fontFamily: 'PermanentMarker',
                    color: Colors.white,
                  ),
                  child: AnimatedTextKit(
                      animatedTexts: [TypewriterAnimatedText('QUIZ')],
                      onTap: () {}),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
