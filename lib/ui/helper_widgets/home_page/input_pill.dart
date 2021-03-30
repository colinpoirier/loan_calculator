import 'package:flutter/material.dart';

class InputPill extends StatelessWidget {
  const InputPill({
    Key? key,
    this.toDisplay = false,
    this.timeChange,
    this.timeChanged = false,
    required this.hintText,
    required this.leadingText,
    required this.controller,
    required this.maxWidth,
    required this.errorText,
  }) : super(key: key);

  final String hintText;
  final void Function(bool)? timeChange;
  final String leadingText;
  final bool toDisplay;
  final bool timeChanged;
  final TextEditingController controller;
  final double maxWidth;
  final String? errorText;

  Widget displayTimeChange() {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      height: 30,
      width: 30,
      child: Stack(
        alignment: const AlignmentDirectional(0.05, 0.5),
        children: [
          Text(
            timeChanged ? 'Y' : 'M',
            textScaleFactor: 1.0,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.calendar_today, size: 30),
            onPressed: () {
              timeChange!(!timeChanged);
            },
          ),
          // PopupMenuButton(
          //   padding: const EdgeInsets.all(0),
          //   icon: const Icon(
          //     Icons.calendar_today,
          //     size: 30.0,
          //   ),
          //   elevation: 10.0,
          //   onSelected: timeChange,
          //   itemBuilder: (context) => const [
          //     PopupMenuItem<bool>(
          //       value: false,
          //       child: Center(
          //         child: Text('Months'),
          //       ),
          //     ),
          //     PopupMenuItem<bool>(
          //       value: true,
          //       child: Center(
          //         child: Text('Years'),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          constraints: const BoxConstraints(
            maxWidth: 140,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (toDisplay) displayTimeChange(),
              Text(
                leadingText,
                textScaleFactor: 1.0,
                style: const TextStyle(
                  fontSize: 22.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: (maxWidth - 165).clamp(0.0, 215.0),
          ),
          padding: const EdgeInsets.all(3.0),
          child: TextField(
            style: TextStyle(
              fontSize: 22.0 / MediaQuery.textScaleFactorOf(context),
              height: 1.2,
            ),
            keyboardType: TextInputType.number,
            controller: controller,
            decoration: InputDecoration(hintText: hintText, errorText: errorText),
          ),
        ),
      ],
    );
  }
}
