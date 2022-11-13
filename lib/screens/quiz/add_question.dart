import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:random_string/random_string.dart';
import '../../models/quiz_model.dart';
import '../../widgets/circle_widget.dart';

class AddQuestionScreen extends StatefulWidget {
  final String quizId;
  final String totalQuestion;

  const AddQuestionScreen(
      {Key? key, required this.quizId, required this.totalQuestion})
      : super(key: key);

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  String question = "",
      option1 = "",
      option2 = "",
      option3 = "",
      option4 = "",
      answer = "",
      questionId = "",
      positionAnswer = "";
  late int totalQuestion;
  String? selectOption;
  final items = ['1', '2', '3', '4'];

  uploadQuizData() {
    if (selectOption == '1') {
      answer = option1;
      positionAnswer = '1';
    } else if (selectOption == '2') {
      answer = option2;
      positionAnswer = '2';
    } else if (selectOption == '3') {
      answer = option3;
      positionAnswer = '3';
    } else if (selectOption == '4') {
      answer = option4;
      positionAnswer = '4';
    }
    if (_formKey.currentState!.validate()) {
      questionId = randomAlphaNumeric(20);
      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
        "answer": answer,
        "questionId": questionId,
        "positionAnswer": positionAnswer,
        "totalQuestion": totalQuestion.toString(),
      };
      addQuestionData(questionMap, widget.quizId).then((value) {
        question = "";
        option1 = "";
        option2 = "";
        option3 = "";
        option4 = "";
        answer = "";
        questionId = "";
        positionAnswer = "";
        selectOption = null;
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    totalQuestion = int.parse(widget.totalQuestion);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black54,
        ),
        title: const Text(
          'Add Question',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Not be empty" : null,
                        decoration: const InputDecoration(hintText: "Question"),
                        onChanged: (val) {
                          question = val;
                        },
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Not be empty" : null,
                        decoration: const InputDecoration(hintText: "Option 1"),
                        onChanged: (val) {
                          option1 = val;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Not be empty" : null,
                        decoration: const InputDecoration(hintText: "Option 2"),
                        onChanged: (val) {
                          option2 = val;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Not be empty" : null,
                        decoration: const InputDecoration(hintText: "Option 3"),
                        onChanged: (val) {
                          option3 = val;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Not be empty" : null,
                        decoration: const InputDecoration(hintText: "Option 4"),
                        onChanged: (val) {
                          option4 = val;
                        },
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 20),
                      Row(children: const [
                        Text(
                          'Correct Answer',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        )
                      ]),
                      const SizedBox(height: 20),
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
                              'Select Option',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
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
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                totalQuestion++;
                              });
                              uploadQuizData();
                              Navigator.pop(context);
                              EasyLoading.showSuccess('Added Successful!');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 2 - 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                totalQuestion++;
                              });
                              uploadQuizData();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 2 - 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Text(
                                "Next Question",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
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
