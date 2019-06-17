import 'package:flutter/material.dart';

class InputPill extends StatelessWidget {
  const InputPill({
    Key key,
    this.toDisplay = false,
    this.timeChange,
    this.timeChanged = false,
    this.hintText,
    this.errorText,
    this.leadingText,
    this.controller,
    this.validator
  }) : super(key: key);

  final String hintText;
  final String errorText;
  final ValueChanged<String> timeChange;
  final String leadingText;
  final bool toDisplay;
  final bool timeChanged;
  final TextEditingController controller;
  final Function(String) validator;

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
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          PopupMenuButton(
            padding: const EdgeInsets.all(0),
            icon: const Icon(
              Icons.calendar_today,
              size: 30.0,
            ),
            elevation: 10.0,
            onSelected: timeChange,
            itemBuilder: (context) {
              return const [
                PopupMenuItem<String>(
                  value: 'Months',
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Months'),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Years',
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Years'),
                  ),
                ),
              ];
            },
          ),
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
            maxWidth: 135,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if(toDisplay) displayTimeChange(),
              Text(
                leadingText,
                style: const TextStyle(
                  fontSize: 22.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          constraints: const BoxConstraints(
            maxWidth: 210,
          ),
          padding: const EdgeInsets.all(3.0),
          child: TextFormField(
            style: const TextStyle(
              fontSize: 22.0,
              height: 1.2,
              // color: Colors.black,
            ),
            keyboardType: TextInputType.number,
            validator: validator,
            autovalidate: true,
            controller: controller,
            decoration: InputDecoration(
              // focusedBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.red)
              // ),
              errorText: errorText,
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
