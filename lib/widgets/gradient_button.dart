import 'package:flutter/material.dart';

Widget gradientButton(BuildContext context, String label, double width) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: const [Colors.teal, Colors.indigo, Colors.red],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    alignment: Alignment.center,
    child: Text(
      label,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}
