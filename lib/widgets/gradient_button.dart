import 'package:flutter/material.dart';

Widget gradientButton(BuildContext context, String label, double width) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(vertical: 18),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.teal, Colors.indigo, Colors.red],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    alignment: Alignment.center,
    child: Text(
      label,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}
