// import 'package:flutter/material.dart';
// import 'package:quiz_app/screens/home/create_quiz.dart';
// import 'package:quiz_app/widgets/navigation_drawer_widget.dart';
// import 'components/stream_topic.dart';
//
// class LibraryScreen extends StatelessWidget {
//   static const String routeName = 'library_screen';
//
//   const LibraryScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         drawer: NavigationDrawerWidget(),
//         appBar: AppBar(
//           title: const Text('Library'),
//           centerTitle: true,
//           backgroundColor: Colors.green,
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.teal, Colors.indigo, Colors.red],
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//               ),
//             ),
//           ),
//         ),
//         body: ListView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.all(16),
//           children: const [
//             SizedBox(height: 8),
//             StreamTopic(),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.of(context).push(
//                 MaterialPageRoute(builder: (context) => const CreateQuizScreen()));
//           },
//           child: Container(
//               height: 60,
//               width: 60,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [Colors.teal, Colors.indigo, Colors.red],
//                   begin: Alignment.topRight,
//                   end: Alignment.bottomLeft,
//                 ),
//               ),
//               child: const Icon(Icons.add)),
//         ),
//       );
// }
