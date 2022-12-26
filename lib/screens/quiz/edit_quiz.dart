import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiz_app/screens/quiz/welcome_quiz.dart';
import 'package:quiz_app/widgets/gradient_button.dart';
import '../home/home.dart';
import 'edit_question.dart';

class EditQuizScreen extends StatefulWidget {
  final String quizId;

  const EditQuizScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final categoriesCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  List<String> tempChange = ["", ""];
  String? imageUrl;
  String? shuffle;
  final items = ['Question', 'Answer', 'Question And Answer', 'None'];

  editQuiz() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('quiz').doc(widget.quizId).update({
        'title': tempChange[0],
        'categories': tempChange[1],
        'shuffle': shuffle,
        'imageUrl': (imageUrl == null) ? '' : imageUrl,
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      EasyLoading.showError('Can\'t Edit Quiz!');
    }
    tempChange = ["", ""];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Quiz',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => WelcomeQuiz(
                          snapshotInfoQuiz: snapshotInfoQuiz,
                        )));
          },
        ),
        centerTitle: true,
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
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("quiz")
                  .doc(widget.quizId)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                final DocumentSnapshot dataSnapshot;
                dataSnapshot = snapshot.data!;
                titleCtrl.text =
                    tempChange[0] != "" ? tempChange[0] : dataSnapshot['title'];
                categoriesCtrl.text = tempChange[1] != ""
                    ? tempChange[1]
                    : dataSnapshot['categories'];
                tempChange[0] = titleCtrl.text;
                tempChange[1] = categoriesCtrl.text;
                imageUrl = dataSnapshot['imageUrl'];
                return Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          imageUrl != ""
                              ? Container(
                                  height: 140,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          dataSnapshot['imageUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                  ),
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: GestureDetector(
                                      onTap: uploadImage,
                                      child: CircleAvatar(
                                        child: SvgPicture.asset(
                                            'assets/icons/camera-rotate.svg',
                                            height: 30,
                                            color: Colors.white),
                                      ),
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
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: titleCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Please enter your title\'s quiz.',
                              labelText: 'Title',
                              prefixIcon: Icon(Icons.menu_book),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            validator: (value) => ((value?.length ?? 0) < 4
                                ? 'At least 4 characters.'
                                : null),
                            onChanged: (v) {
                              tempChange[0] = v;
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: categoriesCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Please enter your\'s category.',
                              labelText: 'Category',
                              prefixIcon: Icon(Icons.category),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            validator: (value) => ((value?.length ?? 0) < 2
                                ? 'At least 2 characters.'
                                : null),
                            onChanged: (v) {
                              tempChange[1] = v;
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(children: const [
                            Text(
                              'Shuffle',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ]),
                          const SizedBox(height: 20),
                          Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Text(
                                  dataSnapshot['shuffle'],
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
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
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: editQuiz,
                                  child: gradientButton(
                                    context,
                                    'Save Quiz',
                                    MediaQuery.of(context).size.width / 2 - 40,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    editQuiz;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditQuestionScreen(
                                                    quizId: widget.quizId)));
                                  },
                                  child: gradientButton(
                                    context,
                                    'Edit Question',
                                    MediaQuery.of(context).size.width / 2 - 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMainItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(item, style: const TextStyle(fontSize: 18)),
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
        setState(() {
          imageUrl = downloadUrl;
        });
        await FirebaseFirestore.instance
            .collection('quiz')
            .doc(widget.quizId)
            .update({
          'imageUrl': imageUrl!,
        });
      } else {
        print('No image path received');
      }
    } else {
      print('Permission not granted. Try again with permission access');
    }
  }
}
