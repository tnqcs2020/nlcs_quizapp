import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quiz_app/screens/home/home.dart';
import 'package:quiz_app/widgets/gradient_button.dart';
import '../../models/user_model.dart';
import '../login/login.dart';
import '../start/start.dart';

late UserCredential newUser;

class RegisterScreen extends StatefulWidget {
  static String routeName = 'register';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? imageUrl;

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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.teal, Colors.indigo, Colors.red],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )),
        ),
        title: Column(
          children: const [
            Text(
              "Register",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
            child: const Text(
              ' Login',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
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
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
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
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: rePasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Please enter your\'s password.',
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (value) =>
                            ((value ?? 0) != passwordController.text
                                ? 'Password does not match.'
                                : null),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Please enter your name.',
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (value) => ((value?.length ?? 0) < 10
                            ? 'At least 10 characters.'
                            : null),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: 'Please enter your phone number.',
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (value) => ((value?.length ?? 0) != 10
                            ? 'Includes 10 numbers'
                            : null),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          hintText: 'Please enter your address.',
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.home),
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
                padding: const EdgeInsets.fromLTRB(130, 40, 130, 20),
                child: GestureDetector(
                  onTap: () async {
                    final FormState? form = _formKey.currentState;
                    if (form!.validate()) {
                      try {
                        newUser = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                        if (newUser != null) {
                          final infoUser = InfoUser(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            address: addressController.text,
                            id: newUser.user!.uid,
                          );
                          createUser(infoUser);
                          EasyLoading.showSuccess('Register Successful!');
                          Navigator.pushNamed(context, HomeScreen.routeName);
                        } else {
                          EasyLoading.showError('Can\'t Register Account!');
                        }
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      EasyLoading.showError('Can\'t Register Account!');
                    }
                  },
                  child: gradientButton(context, 'Register', 150),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
