import 'package:cloud_firestore/cloud_firestore.dart';

class InfoQuiz {
  String? quizId, title, categories, imageUrl, shuffle;
  int? time;
  InfoQuiz({
    required this.quizId,
    required this.title,
    required this.categories,
    required this.shuffle,
    this.imageUrl,
  });

  Map<String, dynamic> toJsonTest() => {
        'quizId': quizId,
        'title': title,
        'categories': categories,
        'shuffle': shuffle,
        'imageUrl': imageUrl,
      };

  static InfoQuiz fromJsonTest(Map<String, dynamic> json) => InfoQuiz(
        quizId: json['quizId'],
        title: json['name'],
        categories: json['categories'],
        shuffle: json['shuffle'],
        imageUrl: json['imageUrl'],
      );
}

Future addQuizData(InfoQuiz quiz) async {
  await FirebaseFirestore.instance.collection('quiz').doc(quiz.quizId).set({
    'quizId': quiz.quizId,
    'title': quiz.title,
    'categories': quiz.categories,
    'shuffle': quiz.shuffle,
    'imageUrl': quiz.imageUrl,
    'totalQuestion': '0'
  }).catchError((e) {
    print(e);
  });
}

Future addQuestionData(quizData, String? quizId) async {
  if (quizData['question'] != null &&
      quizData['option1'] != null &&
      quizData['option2'] != null &&
      quizData['option3'] != null &&
      quizData['option4'] != null &&
      quizData['answer'] != null) {
    await FirebaseFirestore.instance
        .collection("quiz")
        .doc(quizId)
        .collection("questions")
        .doc(quizData['questionId'])
        .set({
      "question": quizData['question'],
      "option1": quizData['option1'],
      "option2": quizData['option2'],
      "option3": quizData['option3'],
      "option4": quizData['option4'],
      "answer": quizData['answer'],
      "questionId": quizData['questionId'],
      "positionAnswer": quizData['positionAnswer'],
      'timestamp': DateTime.now(),
    }).catchError((e) {
      print(e);
    });
    await FirebaseFirestore.instance.collection("quiz").doc(quizId).update({
      "totalQuestion": quizData['totalQuestion'],
    }).catchError((e) {
      print(e);
    });
  }
}

Future updateQuestionData(quizData, String? quizId) async {
  await FirebaseFirestore.instance
      .collection("quiz")
      .doc(quizId)
      .collection("questions")
      .doc(quizData['questionId'])
      .update({
    "question": quizData['question'],
    "option1": quizData['option1'],
    "option2": quizData['option2'],
    "option3": quizData['option3'],
    "option4": quizData['option4'],
    "answer": quizData['answer'],
    "positionAnswer": quizData['positionAnswer'],
  }).catchError((e) {
    print(e);
  });
}

Future deleteQuestionData(deleteQues) async {
  await FirebaseFirestore.instance
      .collection('quiz')
      .doc(deleteQues['quizId'])
      .update({
    "totalQuestion": (int.parse(deleteQues['totalQuestion']) - 1).toString(),
  }).catchError((e) {
    print(e);
  });
  await FirebaseFirestore.instance
      .collection('quiz')
      .doc(deleteQues['quizId'])
      .collection('questions')
      .doc(deleteQues['questionId'])
      .delete()
      .catchError((e) {
    print(e);
  });
}
