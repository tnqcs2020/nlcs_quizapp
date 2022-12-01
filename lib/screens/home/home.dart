import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/screens/quiz/edit_quiz.dart';
import 'package:quiz_app/screens/quiz/welcome_quiz.dart';
import '../quiz/create_quiz.dart';
import '../../widgets/navigation_drawer_widget.dart';

const String administrator = 'admin@gmail.com';
bool admin = false;

class HomeScreen extends StatefulWidget {
  static const String routeName = 'homepage';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser?.email == administrator) {
      setState(() {
        admin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "QUIZ APP",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(85),
          child: Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: FutureBuilder<InfoUser?>(
              future: loadUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final infoUser = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        infoUser!.name!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.teal, Colors.indigo, Colors.red],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )),
        ),
        actions: const [
          Icon(Icons.search),
          SizedBox(
            width: 12,
          )
        ],
      ),
      body: Container(
        color: Colors.black12,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("quiz")
              .orderBy('title', descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return snapshot.hasData
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot dataSnapshot;
                        dataSnapshot = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WelcomeQuiz(
                                        snapshotInfoQuiz: dataSnapshot)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Container(
                              height: 150,
                              decoration: dataSnapshot['imageUrl'] != ''
                                  ? BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            dataSnapshot['imageUrl']),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30)),
                                    )
                                  : const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                              alignment: Alignment.center,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    admin
                                        ? Container(
                                            height: 60,
                                            width: double.infinity,
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditQuizScreen(
                                                                    quizId: dataSnapshot[
                                                                        'quizId'])));
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white70,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: const Icon(
                                                        FontAwesomeIcons
                                                            .penToSquare),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                              'Warning',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            titleTextStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        30,
                                                                    color: Colors
                                                                        .blue),
                                                            content: const Text(
                                                                'Do you want to delete a quiz?'),
                                                            actions: [
                                                              TextButton(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  textStyle: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelLarge,
                                                                ),
                                                                child:
                                                                    const Text(
                                                                        'Yes'),
                                                                onPressed:
                                                                    () async {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'quiz')
                                                                      .doc(dataSnapshot[
                                                                          'quizId'])
                                                                      .collection(
                                                                          'questions')
                                                                      .get()
                                                                      .then(
                                                                          (snapshot) {
                                                                    for (DocumentSnapshot doc
                                                                        in snapshot
                                                                            .docs) {
                                                                      doc.reference
                                                                          .delete();
                                                                    }
                                                                  });
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'quiz')
                                                                      .doc(dataSnapshot[
                                                                          'quizId'])
                                                                      .delete();
                                                                  if (dataSnapshot[
                                                                          'imageUrl'] !=
                                                                      '') {
                                                                    FirebaseStorage
                                                                        .instance
                                                                        .refFromURL(
                                                                            dataSnapshot['imageUrl'])
                                                                        .delete();
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              TextButton(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  textStyle: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelLarge,
                                                                ),
                                                                child:
                                                                    const Text(
                                                                        'No'),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white70,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child: const Icon(
                                                          FontAwesomeIcons
                                                              .trashCan)),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            dataSnapshot['title'],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                // color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            dataSnapshot['categories'],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                // color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.green,
                    ),
                  );
          },
        ),
      ),
      floatingActionButton: admin
          ? Padding(
              padding: const EdgeInsets.only(bottom: 50.0, right: 10),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CreateQuizScreen()));
                },
                child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.teal, Colors.indigo, Colors.red],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: const Icon(Icons.add)),
              ),
            )
          : const SizedBox(),
    );
  }
}
