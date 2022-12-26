import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../home/home.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _auth = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
        centerTitle: true,
        title: const Text(
          "Quiz's History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
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
      ),
      body: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        color: Colors.grey[100],
        child: StreamBuilder(
          stream: admin
              ? FirebaseFirestore.instance
                  .collection("historyQuiz")
                  .orderBy('timestamp', descending: true)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection("historyQuiz")
                  .where('user', isEqualTo: _auth!.email)
                  .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot dataSnapshot;
                dataSnapshot = snapshot.data.docs[index];
                String formattedDate = DateFormat('hh:mm:ss, d/M/y')
                    .format(dataSnapshot['timestamp'].toDate());
                return Padding(
                  padding: index != snapshot.data.docs.length
                      ? const EdgeInsets.fromLTRB(20, 20, 20, 0)
                      : const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 100,
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 230,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                  overflow: TextOverflow.visible,
                                  TextSpan(
                                    text: "Title: ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    children: [
                                      TextSpan(
                                        text: dataSnapshot['title'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15),
                                      ),
                                    ],
                                  )),
                              Text.rich(
                                  overflow: TextOverflow.visible,
                                  TextSpan(
                                    text: "Category: ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    children: [
                                      TextSpan(
                                        text: dataSnapshot['categories'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15),
                                      ),
                                    ],
                                  )),
                              Text.rich(
                                  overflow: TextOverflow.visible,
                                  TextSpan(
                                    text: "Date: ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    children: [
                                      TextSpan(
                                        text: formattedDate,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15),
                                      ),
                                    ],
                                  )),
                              Text.rich(
                                  overflow: TextOverflow.visible,
                                  TextSpan(
                                    text: "Username: ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    children: [
                                      TextSpan(
                                        text: dataSnapshot['username'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Score",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                dataSnapshot['score'].toString(),
                                style: const TextStyle(
                                    fontSize: 40, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        dataSnapshot['user'] == _auth?.email
                            ? SizedBox(
                                width: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Warning',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                titleTextStyle: const TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.blue),
                                                content: const Text(
                                                    'Do you want to delete a history?'),
                                                actions: [
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelLarge,
                                                    ),
                                                    child: const Text('Yes'),
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'historyQuiz')
                                                          .doc(dataSnapshot[
                                                              'historyId'])
                                                          .delete();
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelLarge,
                                                    ),
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: const CircleAvatar(
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          radius: 50,
                                          child: FaIcon(
                                            FontAwesomeIcons.trashCan,
                                            size: 23,
                                            color: Colors.black,
                                          )),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
