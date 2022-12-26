import 'package:flutter/material.dart';

class CircleWidget extends StatefulWidget {
  final String text;
  final Color bgColor;

  const CircleWidget({
    Key? key,
    required this.text,
    required this.bgColor,
  }) : super(key: key);

  @override
  State<CircleWidget> createState() => _CircleWidgetState();
}

class _CircleWidgetState extends State<CircleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.teal, Colors.indigo, Colors.red],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(),
      ),
      child: CircleAvatar(
          child: Text(
            widget.text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: widget.bgColor == Colors.blue
              ? Colors.transparent
              : Colors.white),
    );
  }
}
