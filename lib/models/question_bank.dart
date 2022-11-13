class Question {
  late String question;
  late List<String> listOption;
  late String answer;
  late String questionId;
  late String positionAnswer;

  Question(String _question, List<String> _listOption, String _answer,
      String _questionId, String _positionAnswer) {
    question = _question;
    listOption = _listOption;
    answer = _answer;
    questionId = _questionId;
    positionAnswer = _positionAnswer;
  }
}
