// import 'package:flutter/material.dart';
// import 'demoData.dart';
//
// class ImageCarousel extends StatefulWidget {
//   const ImageCarousel({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<ImageCarousel> createState() => _ImageCarouselState();
// }
//
// class _ImageCarouselState extends State<ImageCarousel> {
//   int _currentPage = 0;
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.7,
//       child: Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           PageView.builder(
//               itemCount: demoBanner.length,
//               onPageChanged: (value) {
//                 setState(() {
//                   _currentPage = value;
//                 });
//               },
//               itemBuilder: (context, index) => ClipRRect(
//                 borderRadius: const BorderRadius.all(Radius.circular(50)),
//                 child: Image.asset(
//                   demoBanner[index],
//                   scale: 0.5,
//                 ),
//               )
//           ),
//           Positioned(
//             bottom: 21,
//             right: 26,
//             child: Row(
//               children: List.generate(
//                 demoBanner.length,
//                     (index) => Padding(
//                   padding: const EdgeInsets.only(left: 4),
//                   child: IndicatorDot(isActive: index == _currentPage),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class IndicatorDot extends StatelessWidget {
//   const IndicatorDot({
//     Key? key,
//     required this.isActive,
//   }) : super(key: key);
//   final bool isActive;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: 3,
//         width: 8,
//         decoration: BoxDecoration(
//           color: isActive ? Colors.black : Colors.grey,
//           borderRadius: const BorderRadius.all(Radius.circular(12)),
//         ));
//   }
// }