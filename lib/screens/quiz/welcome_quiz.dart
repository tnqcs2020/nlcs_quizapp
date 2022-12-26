import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_app/screens/home/home.dart';
import 'package:quiz_app/screens/quiz/edit_quiz.dart';
import 'package:quiz_app/screens/quiz/quiz_play.dart';
import 'package:quiz_app/widgets/gradient_button.dart';

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
    snapshotInfoQuiz = widget.snapshotInfoQuiz;
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
        centerTitle: true,
        title: const Text(
          "Quiz",
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
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        color: Colors.grey[100],
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
                  const SizedBox(height: 20),
                  lineInfoQuiz('Topic', snapshotInfoQuiz['title']),
                  const SizedBox(height: 10),
                  lineInfoQuiz('Category', snapshotInfoQuiz['categories']),
                  const SizedBox(height: 10),
                  lineInfoQuiz('Shuffle', snapshotInfoQuiz['shuffle']),
                ],
              ),
            ),
            const SizedBox(
              height: 150,
            ),
            admin
                ? Row(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditQuizScreen(
                                      quizId: snapshotInfoQuiz['quizId'])));
                        },
                        child: gradientButton(context, 'Edit', 170),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const QuizPlay()));
                    },
                    child: gradientButton(context, 'Start', 170),
                  ),
            const SizedBox(
              width: 10,
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
