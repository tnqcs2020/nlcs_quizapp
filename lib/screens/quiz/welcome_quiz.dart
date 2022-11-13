import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_app/screens/quiz/quiz_play.dart';
import 'package:quiz_app/widgets/gradient_button.dart';

late int setTime;
late DocumentSnapshot snapshotInfoQuiz;

class WelcomeQuiz extends StatefulWidget {
  final DocumentSnapshot snapshotInfoQuiz;

  const WelcomeQuiz({Key? key, required this.snapshotInfoQuiz})
      : super(key: key);

  @override
  WelcomeQuizScreen createState() => WelcomeQuizScreen();
}

class WelcomeQuizScreen extends State<WelcomeQuiz> {
  @override
  Widget build(BuildContext context) {
    setTime = widget.snapshotInfoQuiz['time'];
    snapshotInfoQuiz = widget.snapshotInfoQuiz;
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "QUIZ APP",
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
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity - 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  snapshotInfoQuiz['imageUrl'] != ''
                      ? Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(snapshotInfoQuiz['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                          alignment: Alignment.bottomCenter,
                        )
                      : Container(
                          height: 140,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: SvgPicture.asset(
                              'assets/icons/image-slash.svg',
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                  // Container(
                  //   height: 150,
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //       image: NetworkImage(snapshotInfoQuiz['imageUrl']),
                  //       fit: BoxFit.cover,
                  //     ),
                  //     // color: Colors.grey,
                  //     borderRadius: const BorderRadius.all(Radius.circular(30)),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  lineInfoQuiz('Topic', snapshotInfoQuiz['title']),
                  lineInfoQuiz('Category', snapshotInfoQuiz['categories']),
                  lineInfoQuiz('Shuffle', snapshotInfoQuiz['shuffle']),
                  // snapshotInfoQuiz['time'] == 0
                  //     ? lineInfoQuiz('Time', 'Unlimited time')
                  //     : lineInfoQuiz('Time', '${snapshotInfoQuiz['time']} min'),
                ],
              ),
            ),
            const SizedBox(
              height: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const QuizPlay()));
                  },
                  child: gradientButton(context, 'Start', 170),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: gradientButton(context, 'Cancel', 170),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text lineInfoQuiz(String label, String data) {
    return Text.rich(
      TextSpan(
        text: '${label.toUpperCase()}: ',
        style: const TextStyle(
            fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
        children: <TextSpan>[
          TextSpan(
            text: data,
            style: const TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      overflow: TextOverflow.visible,
    );
  }
}
