import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quiz_app/screens/quiz/edit_question.dart';
import 'package:quiz_app/widgets/gradient_button.dart';
import 'package:random_string/random_string.dart';
import '../../models/quiz_model.dart';

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
        "totalQuestion": totalQuestion.toString()
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
    totalQuestion = int.parse(widget.totalQuestion) + 1;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Question',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.teal, Colors.indigo, Colors.red],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Not be empty" : null,
                  decoration: const InputDecoration(
                      hintText: 'Please enter question.',
                      labelText: 'Question',
                      labelStyle: TextStyle(color: Colors.blue)),
                  onChanged: (val) {
                    question = val;
                  },
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Not be empty" : null,
                  decoration: const InputDecoration(
                      hintText: 'Please enter option 1.',
                      labelText: 'Option 1',
                      labelStyle: TextStyle(color: Colors.blue)),
                  onChanged: (val) {
                    option1 = val;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Not be empty" : null,
                  decoration: const InputDecoration(
                      hintText: "Please enter option 2.",
                      labelText: 'Option 2',
                      labelStyle: TextStyle(color: Colors.blue)),
                  onChanged: (val) {
                    option2 = val;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Not be empty" : null,
                  decoration: const InputDecoration(
                      hintText: "Please enter option 3.",
                      labelText: 'Option 3',
                      labelStyle: TextStyle(color: Colors.blue)),
                  onChanged: (val) {
                    option3 = val;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Not be empty" : null,
                  decoration: const InputDecoration(
                      hintText: "Please enter option 4.",
                      labelText: 'Option 4',
                      labelStyle: TextStyle(color: Colors.blue)),
                  onChanged: (val) {
                    option4 = val;
                  },
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20),
                Row(children: const [
                  Text(
                    'Correct Answer',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  )
                ]),
                const SizedBox(height: 10),
                Container(
                  height: 45,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 1)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: const Text(
                        'Select Option',
                        style: TextStyle(color: Colors.black, fontSize: 18),
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
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        uploadQuizData();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditQuestionScreen(quizId: widget.quizId)));
                        EasyLoading.showSuccess('Added Successful!');
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: gradientButton(context, 'Submit',
                            MediaQuery.of(context).size.width / 2 - 50),
                      ),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        uploadQuizData();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddQuestionScreen(
                                      quizId: widget.quizId,
                                      totalQuestion: totalQuestion.toString(),
                                    )));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: gradientButton(context, 'Next Question',
                            MediaQuery.of(context).size.width / 2 - 50),
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
