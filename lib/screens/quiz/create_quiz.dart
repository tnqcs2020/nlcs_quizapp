import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiz_app/widgets/gradient_button.dart';
import 'package:random_string/random_string.dart';
import '../../models/quiz_model.dart';
import 'add_question.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({Key? key}) : super(key: key);

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final categoriesCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  String? imageUrl;
  String? shuffle;
  late String quizId;
  final items = ['Question', 'Answer', 'Question And Answer', 'None'];

  createQuiz() async {
    quizId = randomAlphaNumeric(20);
    if (_formKey.currentState!.validate()) {
      final infoQuiz = InfoQuiz(
        quizId: quizId,
        title: titleCtrl.text,
        categories: categoriesCtrl.text,
        shuffle: (shuffle == null) ? 'None' : shuffle,
        imageUrl: (imageUrl == null) ? '' : imageUrl,
      );
      addQuizData(infoQuiz).then(
        (value) => {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddQuestionScreen(
                        quizId: infoQuiz.quizId!,
                        totalQuestion: '0',
                      ))),
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => {
                  Navigator.pop(context),
                  if (imageUrl != null)
                    {
                      FirebaseStorage.instance.refFromURL(imageUrl!).delete(),
                    },
                }),
        title: const Text(
          'New Quiz',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      imageUrl != null
                          ? Container(
                              height: 140,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl!),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              ),
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: uploadImage,
                                child: const CircleAvatar(
                                  child: Icon(Icons.camera_alt),
                                ),
                              ),
                            )
                          : Container(
                              height: 140,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 80,
                                width: 80,
                                child: GestureDetector(
                                  onTap: uploadImage,
                                  child: SvgPicture.asset(
                                    'assets/icons/image-slash.svg',
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Please enter your topic\'s test.',
                          labelText: 'Topic',
                          prefixIcon: Icon(Icons.menu_book),
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: categoriesCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Please enter your\'s category.',
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (value) => ((value?.length ?? 0) < 2
                            ? 'At least 4 characters.'
                            : null),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        'Shuffle',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    ]),
                    const SizedBox(height: 10),
                    Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 1)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: const Text(
                            'Select type of shuffle',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          value: shuffle,
                          isExpanded: true,
                          items: items.map(buildMainItem).toList(),
                          onChanged: (value) {
                            setState(() {
                              shuffle = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: GestureDetector(
                        onTap: createQuiz,
                        child: gradientButton(
                          context,
                          'Create Quiz',
                          MediaQuery.of(context).size.width - 48,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadImage() async {
    final imagePicker = ImagePicker();
    XFile? image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      image = await imagePicker.pickImage(source: ImageSource.gallery);
      var file = File(image!.path);
      if (image != null) {
        var snapshot = await FirebaseStorage.instance
            .ref()
            .child('images/quiz/${image.path.split('/').last}')
            .putFile(file)
            .whenComplete(() => print('success'));
        var downloadUrl = await snapshot.ref.getDownloadURL();
        if (imageUrl != null) {
          await FirebaseStorage.instance.refFromURL(imageUrl!).delete();
        }
        setState(() {
          imageUrl = downloadUrl;
        });
        await FirebaseFirestore.instance.collection('quiz').doc(quizId).update({
          'imageUrl': imageUrl!,
        });
      } else {
        print('No image path received');
      }
    } else {
      print('Permission not granted. Try again with permission access');
    }
  }

  DropdownMenuItem<String> buildMainItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(item, style: const TextStyle(fontSize: 18)),
    );
  }
}
