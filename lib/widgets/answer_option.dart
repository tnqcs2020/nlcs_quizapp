import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  const AnswerOption({
    Key? key,
    required this.no,
    required this.option,
    this.press,
    required this.answerColor,
  }) : super(key: key);
  final Color answerColor;
  final String no, option;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
            color: answerColor,
          ),

          alignment: Alignment.centerLeft,
          child: Text(
            '   $no. $option',
            style: const TextStyle(fontSize: 18),
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }
}