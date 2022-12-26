import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/home/home.dart';
import 'package:quiz_app/widgets/gradient_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../register/register.dart';
import '../start/start.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, StartScreen.routeName);
          },
          icon: const Icon(Icons.home),
        ),
        title: Column(
          children: const [
            Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.teal, Colors.indigo, Colors.red],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )),
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 130,
                      ),
                      TextFormField(
                        controller: loginEmailController,
                        decoration: const InputDecoration(
                          hintText: 'Please enter your email.',
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (value) => ((value?.length ?? 0) == 0
                            ? 'Do not empty.'
                            : null),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: loginPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Please enter your\'s password.',
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (value) => ((value?.length ?? 0) < 6
                            ? 'At least 6 characters.'
                            : null),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 250),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(130, 50, 130, 20),
                child: GestureDetector(
                    onTap: () async {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: loginEmailController.text,
                          password: loginPasswordController.text);
                      if (user != null) {
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString(
                            'email', loginEmailController.text);
                        Navigator.pushNamed(context, HomeScreen.routeName);
                      }
                    },
                    child: gradientButton(context, 'Login', 150)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 30, 100, 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreen.routeName);
                  },
                  child: const Text(
                    'Create New Account',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
