import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quiz_app/widgets/gradient_button.dart';
import '../../models/user_model.dart';
import '../../widgets/navigation_drawer_widget.dart';

late User loggedInUser;

class AccountScreen extends StatefulWidget {
  static const String routeName = 'account_screen';

  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  String? imageUrl;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              "My Account",
              style: TextStyle(
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
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
          child: FutureBuilder<InfoUser?>(
            future: loadUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final infoUser = snapshot.data;
                emailCtrl.text = infoUser!.email!;
                nameCtrl.text = infoUser.name!;
                phoneCtrl.text = infoUser.phone!;
                addressCtrl.text = infoUser.address!;
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailCtrl,
                            autofocus: false,
                            decoration: const InputDecoration(
                              hintText: 'Please enter your email.',
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            validator: (value) => ((value?.length ?? 0) == 0
                                ? 'Do not empty.'
                                : null),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              setState(() {
                                emailCtrl.text = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: nameCtrl,
                            autofocus: false,
                            decoration: const InputDecoration(
                              hintText: 'Please enter your name.',
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            validator: (value) => ((value?.length ?? 0) < 10
                                ? 'At least 10 characters.'
                                : null),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onSaved: (value) {
                              setState(() {
                                nameCtrl.text = value!;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: phoneCtrl,
                            autofocus: false,
                            decoration: const InputDecoration(
                              hintText: 'Please enter your phone number.',
                              labelText: 'Phone',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            validator: (value) => ((value?.length ?? 0) != 10
                                ? 'Includes 10 numbers'
                                : null),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onSaved: (value) {
                              setState(() {
                                phoneCtrl.text = value!;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: addressCtrl,
                            autofocus: false,
                            decoration: const InputDecoration(
                              hintText: 'Please enter your address.',
                              labelText: 'Address',
                              prefixIcon: Icon(Icons.home),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            validator: (value) => ((value?.length ?? 0) < 6
                                ? 'At least 6 characters.'
                                : null),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            onSaved: (value) {
                              setState(() {
                                addressCtrl.text = value!;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                              onTap: () async {
                                final FormState? form = _formKey.currentState;
                                if (form!.validate()) {
                                  try {
                                    if (emailCtrl.text != infoUser.email! ||
                                        nameCtrl.text != infoUser.name! ||
                                        phoneCtrl.text != infoUser.phone! ||
                                        addressCtrl.text != infoUser.address!) {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(infoUser.id!)
                                          .update(
                                        {
                                          'email': emailCtrl.text,
                                          'name': nameCtrl.text,
                                          'phone': phoneCtrl.text,
                                          'address': addressCtrl.text,
                                        },
                                      );
                                      EasyLoading.showSuccess(
                                          'Update Successful!');
                                      Navigator.pushNamed(
                                          context, AccountScreen.routeName);
                                    } else {
                                      EasyLoading.showError(
                                          'Can\'t Update Information!');
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                              child: gradientButton(context, 'Save', 150))
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
