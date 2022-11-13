import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/quiz/welcome_quiz.dart';
import 'package:quiz_app/widgets/stopwatch_countdown.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import '../../models/question_bank.dart';
import '../../widgets/answer_option.dart';
import '../home/home.dart';

class QuizPlay extends StatefulWidget {
  const QuizPlay({Key? key}) : super(key: key);

  @override
  _QuizPlayState createState() => _QuizPlayState();
}

class _QuizPlayState extends State<QuizPlay> {
  final _auth = FirebaseAuth.instance;
  bool answerSelected = false;
  List<bool> answerSelectedTrue = [false, false, false, false];
  List<bool> answerSelectedFalse = [false, false, false, false];
  List<Question> listQuestion = [];
  int correctNumber = 0;
  int _questionNumber = 0;
  int? maxLength;

  void checkCorrectAnswer(String answer, String userPick, int location) {
    if (answer == userPick) {
      setState(() {
        correctNumber++;
      });
      answerSelectedTrue[location] = true;
    } else {
      answerSelectedFalse[location] = true;
    }
  }

  Color checkColor(int i) {
    if (!answerSelected) {
      return Colors.white70;
    } else if (answerSelectedTrue[i]) {
      return Colors.green;
    } else if (answerSelectedFalse[i]) {
      return Colors.red;
    }
    return Colors.white70;
  }

  void checkAnswerAndFinish(String answer, String userPick, int location) {
    // listQuestion.shuffle();
    setState(() {
      answerSelected = true;
      checkCorrectAnswer(answer, userPick, location);
      if (_questionNumber + 1 == maxLength) {
        Timer(const Duration(seconds: 1), () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Kết Quả'),
                  titleTextStyle:
                      const TextStyle(fontSize: 30, color: Colors.blue),
                  content: correctNumber == 0
                      ? const Text('Bạn không trả lời đúng câu nào!')
                      : Text('Bạn trả lời đúng $correctNumber câu!'),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Okay'),
                      onPressed: () async {
                        var historyId = randomAlphaNumeric(20);
                        DateTime now = DateTime.now();
                        String formattedDate = DateFormat('kk:mm:ss, d/M/yyyy').format(now);
                        await FirebaseFirestore.instance.collection('historyQuiz').doc(historyId).set({
                          'historyId': historyId,
                          'user': _auth.currentUser?.email,
                          'quizId': snapshotInfoQuiz['quizId'],
                          'title': snapshotInfoQuiz['title'],
                          'categories': snapshotInfoQuiz['categories'],
                          'time': formattedDate,
                          'score': correctNumber,
                        }).catchError((e) {
                          print(e);
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                      },
                    ),
                  ],
                );
              });
        });
      } else {
        Timer(const Duration(seconds: 1), () {
          setState(() {
            if (answerSelected) {
              _questionNumber++;
              answerSelected = false;
              answerSelectedTrue = [false, false, false, false];
              answerSelectedFalse = [false, false, false, false];
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        // title: Text(
        //   widget.dataSnapshot['title'],
        //   style: const TextStyle(fontSize: 25),
        // ),
        actions: [
          GestureDetector(
              child: const Center(
                  widthFactor: 2,
                  child: Text(
                    'Quit',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning'),
                        titleTextStyle:
                            const TextStyle(fontSize: 30, color: Colors.blue),
                        content: const Text('Do you want to exit?'),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Yes'),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              })
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Colors.teal, Colors.indigo, Colors.red],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("quiz")
              .doc(snapshotInfoQuiz['quizId'])
              .collection('questions')
              .orderBy('timestamp')
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              );
            }
            final questions = snapshot.data!.docs;
            if (snapshotInfoQuiz['shuffle'] == 'Question' ||
                snapshotInfoQuiz['shuffle'] == 'Question And Answer') {
              questions.shuffle();
            }
            for (var question in questions) {
              List<String> getOption = [];
              final getQuestion = question.get('question');
              getOption.add(question.get('option1'));
              getOption.add(question.get('option2'));
              getOption.add(question.get('option3'));
              getOption.add(question.get('option4'));
              final getAnswer = question.get('answer');
              final getQuestionId = question.get('questionId');
              if (snapshotInfoQuiz['shuffle'] == 'Answer' ||
                  snapshotInfoQuiz['shuffle'] == 'Question And Answer') {
                getOption.shuffle();
              }
              final getPositionAnswer = question.get('positionAnswer');
              final createQuestion = Question(getQuestion, getOption, getAnswer,
                  getQuestionId, getPositionAnswer);
              listQuestion.add(createQuestion);
            }
            maxLength = questions.length;
            return Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // snapshotInfoQuiz['time'] == 0
                  //     ? const SizedBox()
                  //     : const Countdown(),
                  // const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text.rich(
                      TextSpan(
                        text: 'Question ${_questionNumber + 1}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                        children: [
                          TextSpan(
                            text: '/${snapshot.data!.docs.length}',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(thickness: 2.5),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white70,
                      ),
                      child: !answerSelected
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  listQuestion[_questionNumber].question,
                                  style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w500),
                                ),
                                AnswerOption(
                                  no: 'A',
                                  option: listQuestion[_questionNumber]
                                      .listOption[0],
                                  press: () {
                                    checkAnswerAndFinish(
                                        listQuestion[_questionNumber].answer,
                                        listQuestion[_questionNumber]
                                            .listOption[0],
                                        0);
                                  },
                                  answerColor: checkColor(0),
                                ),
                                AnswerOption(
                                  no: 'B',
                                  option: listQuestion[_questionNumber]
                                      .listOption[1],
                                  press: () {
                                    checkAnswerAndFinish(
                                        listQuestion[_questionNumber].answer,
                                        listQuestion[_questionNumber]
                                            .listOption[1],
                                        1);
                                  },
                                  answerColor: checkColor(1),
                                ),
                                AnswerOption(
                                  no: 'C',
                                  option: listQuestion[_questionNumber]
                                      .listOption[2],
                                  press: () {
                                    checkAnswerAndFinish(
                                        listQuestion[_questionNumber].answer,
                                        listQuestion[_questionNumber]
                                            .listOption[2],
                                        2);
                                  },
                                  answerColor: checkColor(2),
                                ),
                                AnswerOption(
                                  no: 'D',
                                  option: listQuestion[_questionNumber]
                                      .listOption[3],
                                  press: () {
                                    checkAnswerAndFinish(
                                        listQuestion[_questionNumber].answer,
                                        listQuestion[_questionNumber]
                                            .listOption[3],
                                        3);
                                  },
                                  answerColor: checkColor(3),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  listQuestion[_questionNumber].question,
                                  style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w500),
                                ),
                                AnswerOption(
                                  no: 'A',
                                  option: listQuestion[_questionNumber]
                                      .listOption[0],
                                  answerColor: checkColor(0),
                                ),
                                AnswerOption(
                                  no: 'B',
                                  option: listQuestion[_questionNumber]
                                      .listOption[1],
                                  answerColor: checkColor(1),
                                ),
                                AnswerOption(
                                  no: 'C',
                                  option: listQuestion[_questionNumber]
                                      .listOption[2],
                                  answerColor: checkColor(2),
                                ),
                                AnswerOption(
                                  no: 'D',
                                  option: listQuestion[_questionNumber]
                                      .listOption[3],
                                  answerColor: checkColor(3),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
