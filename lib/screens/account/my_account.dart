import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
            floating: true,
            // leading: IconButton(
            //   color: Colors.black,
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   icon: const Icon(Icons.arrow_back),
            // ),
            title: Column(
              children: const [
                Text(
                  "MY ACCOUNT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [Colors.teal, Colors.indigo, Colors.red],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  )),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            sliver: SliverToBoxAdapter(
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
                        // ProfilePicture(press: uploadImage),
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
                                validator: (value) =>
                                    ((value?.length ?? 0) != 10
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
                                height: 40,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  final FormState? form = _formKey.currentState;
                                  if (form!.validate()) {
                                    try {
                                      if (emailCtrl.text != infoUser.email! ||
                                          nameCtrl.text != infoUser.name! ||
                                          phoneCtrl.text != infoUser.phone! ||
                                          addressCtrl.text !=
                                              infoUser.address!) {
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
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              )
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
        ],
      ),
    );
  }

  reloadImage() async {
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'image': imageUrl!,
    });
  }

  uploadImage() async {
    final imagePicker = ImagePicker();
    PickedFile? image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      image = await imagePicker.getImage(source: ImageSource.gallery);
      var file = File(image!.path);
      if (image != null) {
        var snapshot = await FirebaseStorage.instance
            .ref()
            .child('images/${image.path.split('/').last}')
            .putFile(file)
            .whenComplete(() => null);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
        reloadImage();
      } else {
        print('No image path received');
      }
    } else {
      print('Permission not granted. Try again with permission access');
    }
  }
}
