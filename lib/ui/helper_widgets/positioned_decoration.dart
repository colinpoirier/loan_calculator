// import 'package:flutter/material.dart';

// class PositionedDecoration extends StatelessWidget {
//   const PositionedDecoration({Key key, this.color}) : super(key: key);

//   final Color color;
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 0.0,
//       left: 0.0,
//       right: 0.0,
//       height: 0.0,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [color, color.withOpacity(0.05)],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PositionedDecorationBottom extends StatelessWidget {
//   const PositionedDecorationBottom({Key key, this.color}) : super(key: key);

//   final Color color;
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       bottom: 0.0,
//       left: 0.0,
//       right: 0.0,
//       height: 10.0,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             end: Alignment.topCenter,
//             begin: Alignment.bottomCenter,
//             colors: [color, color.withOpacity(0.05)],
//           ),
//         ),
//       ),
//     );
//   }
// }