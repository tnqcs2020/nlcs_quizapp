import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../models/question_bank.dart';
import '../../models/quiz_model.dart';
import '../../widgets/circle_widget.dart';
import 'add_question.dart';
import 'edit_quiz.dart';

class EditQuestionScreen extends StatefulWidget {
  final String quizId;

  const EditQuestionScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  _EditQuestionScreenState createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final questionCtrl = TextEditingController();
  final option1Ctrl = TextEditingController();
  final option2Ctrl = TextEditingController();
  final option3Ctrl = TextEditingController();
  final option4Ctrl = TextEditingController();
  int numOfQuestion = 0;
  int? totalQuestion;
  List<Question> listQuestion = [];
  final items = ['1', '2', '3', '4'];
  String answer = "";
  late List<bool> selectedQuestion = [];
  List<String> tempAnswer = ["", "", "", "", ""];
  String? selectOption;

  resetData() {
    setState(() {
      listQuestion = [];
      tempAnswer = ["", "", "", "", ""];
      StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("quiz")
              .doc(widget.quizId)
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
            for (var question in questions) {
              List<String> getOption = [];
              final getQuestion = question.get('question');
              getOption.add(question.get('option1'));
              getOption.add(question.get('option2'));
              getOption.add(question.get('option3'));
              getOption.add(question.get('option4'));
              final getAnswer = question.get('answer');
              final getQuestionId = question.get('questionId');
              final getPositionAnswer = question.get('positionAnswer');
              final createQuestion = Question(getQuestion, getOption, getAnswer,
                  getQuestionId, getPositionAnswer);
              listQuestion.add(createQuestion);
            }
            questionCtrl.text = listQuestion[numOfQuestion].question;
            option1Ctrl.text = listQuestion[numOfQuestion].listOption[0];
            option2Ctrl.text = listQuestion[numOfQuestion].listOption[1];
            option3Ctrl.text = listQuestion[numOfQuestion].listOption[2];
            option4Ctrl.text = listQuestion[numOfQuestion].listOption[3];
            return const SizedBox();
          });
    });
  }

  updateQuestion() {
    if (selectOption == null) {
      answer = listQuestion[numOfQuestion].answer;
      selectOption = listQuestion[numOfQuestion].positionAnswer;
    } else if (selectOption == '1') {
      answer = option1Ctrl.text;
    } else if (selectOption == '2') {
      answer = option2Ctrl.text;
    } else if (selectOption == '3') {
      answer = option3Ctrl.text;
    } else if (selectOption == '4') {
      answer = option4Ctrl.text;
    }
    if (_formKey.currentState!.validate()) {
      Map<String, String> questionMap = {
        "question": tempAnswer[0],
        "option1": tempAnswer[1],
        "option2": tempAnswer[2],
        "option3": tempAnswer[3],
        "option4": tempAnswer[4],
        "answer": answer,
        "questionId": listQuestion[numOfQuestion].questionId,
        "positionAnswer": selectOption!,
      };
      updateQuestionData(questionMap, widget.quizId).then((value) {
        tempAnswer = ["", "", "", "", ""];
        resetData();
      }).catchError((e) {
        print(e);
      });
    }
  }

  deleteQuestion() {
    if (_formKey.currentState!.validate()) {
      Map<String, String> deleteQues = {
        "quizId": widget.quizId,
        "questionId": listQuestion[numOfQuestion].questionId,
        "totalQuestion": totalQuestion.toString(),
      };
      listQuestion.removeAt(numOfQuestion);
      deleteQuestionData(deleteQues).then((value) {
        resetData();
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditQuizScreen(quizId: widget.quizId)));
          },
          color: Colors.black54,
        ),
        title: const Text(
          'Edit Question',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("quiz")
                    .doc(widget.quizId)
                    .collection('questions')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  final questions = snapshot.data!.docs;
                  for (var question in questions) {
                    List<String> getOption = [];
                    final getQuestion = question.get('question');
                    getOption.add(question.get('option1'));
                    getOption.add(question.get('option2'));
                    getOption.add(question.get('option3'));
                    getOption.add(question.get('option4'));
                    final getAnswer = question.get('answer');
                    final getQuestionId = question.get('questionId');
                    final getPositionAnswer = question.get('positionAnswer');
                    final createQuestion = Question(getQuestion, getOption,
                        getAnswer, getQuestionId, getPositionAnswer);
                    listQuestion.add(createQuestion);
                  }
                  questionCtrl.text = tempAnswer[0] != ""
                      ? tempAnswer[0]
                      : listQuestion[numOfQuestion].question;
                  option1Ctrl.text = tempAnswer[1] != ""
                      ? tempAnswer[1]
                      : listQuestion[numOfQuestion].listOption[0];
                  option2Ctrl.text = tempAnswer[2] != ""
                      ? tempAnswer[2]
                      : listQuestion[numOfQuestion].listOption[1];
                  option3Ctrl.text = tempAnswer[3] != ""
                      ? tempAnswer[3]
                      : listQuestion[numOfQuestion].listOption[2];
                  option4Ctrl.text = tempAnswer[4] != ""
                      ? tempAnswer[4]
                      : listQuestion[numOfQuestion].listOption[3];
                  tempAnswer[0] = questionCtrl.text;
                  tempAnswer[1] = option1Ctrl.text;
                  tempAnswer[2] = option2Ctrl.text;
                  tempAnswer[3] = option3Ctrl.text;
                  tempAnswer[4] = option4Ctrl.text;
                  selectedQuestion.add(true);
                  for (int i = 1; i <= listQuestion.length - 1; i++) {
                    selectedQuestion.add(false);
                  }
                  return Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: questionCtrl,
                                validator: (val) =>
                                    val!.isEmpty ? "Not be empty" : null,
                                decoration:
                                    const InputDecoration(hintText: "Question"),
                                textInputAction: TextInputAction.next,
                                onChanged: (v) {
                                  tempAnswer[0] = v;
                                },
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: option1Ctrl,
                                validator: (val) =>
                                    val!.isEmpty ? "Not be empty" : null,
                                decoration:
                                    const InputDecoration(hintText: "Option 1"),
                                textInputAction: TextInputAction.next,
                                onChanged: (v) {
                                  tempAnswer[1] = v;
                                },
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: option2Ctrl,
                                validator: (val) =>
                                    val!.isEmpty ? "Not be empty" : null,
                                decoration:
                                    const InputDecoration(hintText: "Option 2"),
                                textInputAction: TextInputAction.next,
                                onChanged: (v) {
                                  tempAnswer[2] = v;
                                },
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: option3Ctrl,
                                validator: (val) =>
                                    val!.isEmpty ? "Not be empty" : null,
                                decoration:
                                    const InputDecoration(hintText: "Option 3"),
                                textInputAction: TextInputAction.next,
                                onChanged: (v) {
                                  tempAnswer[3] = v;
                                },
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: option4Ctrl,
                                validator: (val) =>
                                    val!.isEmpty ? "Not be empty" : null,
                                decoration:
                                    const InputDecoration(hintText: "Option 4"),
                                textInputAction: TextInputAction.done,
                                onChanged: (v) {
                                  tempAnswer[4] = v;
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(children: const [
                                Text(
                                  'Correct Answer',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                )
                              ]),
                              const SizedBox(height: 20),
                              Container(
                                height: 45,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: Text(
                                      'Option: ${listQuestion[numOfQuestion].positionAnswer}',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    value: selectOption,
                                    isExpanded: true,
                                    items: items.map(buildMainItem).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectOption = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                updateQuestion();
                                EasyLoading.showSuccess('Updated Successful!');
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Update",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Warning',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        titleTextStyle: const TextStyle(
                                            fontSize: 30, color: Colors.blue),
                                        content: const Text(
                                            'Do you want to delete this question?'),
                                        actions: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                            child: const Text('Yes'),
                                            onPressed: () async {
                                              deleteQuestion();
                                              EasyLoading.showSuccess(
                                                  'Deleted Successful!');
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditQuestionScreen(
                                                              quizId: widget
                                                                  .quizId)));
                                            },
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle: Theme.of(context)
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
                              child: Container(
                                alignment: Alignment.center,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
            const SizedBox(height: 20),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("quiz")
                    .doc(widget.quizId)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  final DocumentSnapshot dataSnapshot;
                  dataSnapshot = snapshot.data!;
                  totalQuestion = int.parse(dataSnapshot['totalQuestion']);
                  return Container(
                    height: 240,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: totalQuestion! + 1,
                      itemBuilder: (BuildContext context, int index) {
                        return index != totalQuestion
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectOption = null;
                                    for (int i = 0;
                                        i <= listQuestion.length - 1;
                                        i++) {
                                      selectedQuestion[i] = false;
                                    }
                                    selectedQuestion[index] = true;
                                    numOfQuestion = index;
                                  });
                                  resetData();
                                },
                                child: CircleWidget(
                                    text: '${index + 1}',
                                    bgColor: selectedQuestion[index] == true
                                        ? Colors.blue
                                        : Colors.white),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddQuestionScreen(
                                                quizId: widget.quizId,
                                                totalQuestion:
                                                    totalQuestion.toString(),
                                              )));
                                  resetData();
                                  // numOfQuestion = totalQuestion!;
                                },
                                child: const CircleWidget(
                                    text: '+', bgColor: Colors.white),
                              );
                        ;
                      },
                    ),
                  );
                }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMainItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text('Option $item', style: const TextStyle(fontSize: 18)),
    );
  }
}
