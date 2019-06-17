import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loan_calc_dev/models/data_classes.dart';

class GraphPainter extends CustomPainter {
  final Paint linePainter;
  final TextPainter textPainter;
  final TextStyle textStyle;
  final Brightness themeBrightness;
  final List<MonthlyBreakDown> mbd;
  final List<InputTracker> ipt;
  final bool isDark;
  Color paymentColor;
  Color principalColor;
  Color interestColor;
  Color totalRepaidColor;

  GraphPainter({
    this.themeBrightness,
    this.textStyle,
    this.ipt,
    this.mbd,
  })  : linePainter = Paint()
          ..color = textStyle.color
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round,
        textPainter = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        isDark = themeBrightness == Brightness.dark
  // ,
  // textStyle = const TextStyle(
  //   color: Colors.black,
  //   fontSize: 15.0,
  // )
  {
    paymentColor = isDark ? Colors.purpleAccent : Colors.purple;
    principalColor = isDark ? Colors.blueAccent : Colors.blue;
    interestColor = isDark ? Colors.redAccent : Colors.red;
    totalRepaidColor = isDark ? Colors.greenAccent : Colors.green;
    // linePainter.color = textStyle.color;
    // linePainter.strokeWidth = 4.0;
    // linePainter.strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.rotate(pi / 2);

    double heightResizer = size.height * .65;
    double widthResizer = size.width * .85;

    int monthLength = mbd.length;

    double offsetter = heightResizer / monthLength;
    double offsetterPrinc = widthResizer / (ipt.first.amount * 1.1);
    double length = widthResizer / (mbd[0].payment * 1.1);

    canvas.save();

    canvas.translate(55, -25);

    //
    //Paid to Principal
    //
    for (int i = 1; i < monthLength; i++) {
      canvas.drawLine(
          Offset((i - .5) * offsetter, -length * mbd[i - 1].paidPrinc),
          Offset((i + .5) * offsetter, -length * mbd[i].paidPrinc),
          Paint()
            ..color =principalColor
            ..strokeWidth = 4.0
            ..strokeCap = StrokeCap.round);
    }
    //
    //Paid to Interest
    //
    for (int i = 1; i < monthLength; i++) {
      canvas.drawLine(
          Offset((i - .5) * offsetter, -length * mbd[i - 1].paidInt),
          Offset((i + .5) * offsetter, -length * mbd[i].paidInt),
          Paint()
            ..color = interestColor
            ..strokeWidth = 4.0
            ..strokeCap = StrokeCap.round);
    }
    //
    //Total Principal
    //
    for (int i = 1; i < monthLength; i++) {
      canvas.drawLine(
          Offset((i - .5) * offsetter, -offsetterPrinc * mbd[i - 1].totPrinc),
          Offset((i + .5) * offsetter, -offsetterPrinc * mbd[i].totPrinc),
          Paint()
            ..color = totalRepaidColor
            ..strokeWidth = 4.0
            ..strokeCap = StrokeCap.round);
    }
    //
    //Monthly Payment
    //
    for (int i = 1; i < monthLength; i++) {
      canvas.drawLine(
          Offset((i - .5) * offsetter, -length * mbd[i - 1].payment),
          Offset((i + .5) * offsetter, -length * mbd[i].payment),
          Paint()
            ..color = paymentColor
            ..strokeWidth = 4.0
            ..strokeCap = StrokeCap.round);
    }

    //
    //Left Axis
    //
    double moredub = mbd[0].payment;
    if (moredub > 1) {
      moredub /= 10;
    }
    //int tempSaver = mbd[0].payment < 10 ? 1 : ((mbd[0].payment) / 10).roundToDouble().toInt();//fix
    //for (int i = tempSaver; i <= (mbd[0].payment * 1.1); i+=tempSaver) {
    for (int i = 1; i <= 10; i++) {
      double dub = moredub * i;
//      dub*=i;
      canvas.drawLine(
          Offset(-10, -length * (dub)),
          Offset(0, -length * (dub)),
          Paint()
            ..color = textStyle.color
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round);
      textPainter.text = TextSpan(
        text: moredub <= 1
            ? '${dub.toStringAsFixed(2)}'
            : '${dub.toStringAsFixed(0)}',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
            -textPainter.width - 15, -length * (dub) - textPainter.height / 2),
      );
      if (moredub <= 1) break;
    }
    canvas.drawLine(
      Offset(0, 0),
      Offset(0, -widthResizer),
      linePainter,
    );

    //
    //Bottom Axis
    //
    int modulo = 1;
    if (monthLength <= 4) {
      modulo = 1;
    } else {
      modulo = (monthLength / 10).roundToDouble().toInt();
    }

    for (int i = 1; i <= monthLength; i++) {
      if (i % modulo == 0 && i <= (monthLength * .95).toInt() ||
          i == 1 ||
          i == monthLength) {
        // if (i <= (monthLength * .95).toInt() || i == monthLength) {
        // if(i>(monthLength*.95).toInt() && i < monthLength){
        //   //Do Nothing
        // }else{
        canvas.drawLine(
            Offset(offsetter * ((i) - .5), 10),
            Offset(offsetter * ((i) - .5), 0),
            Paint()
              ..color = textStyle.color
              ..strokeWidth = 2
              ..strokeCap = StrokeCap.round);
        textPainter.text = TextSpan(
          text: '$i',
          style: textStyle,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(offsetter * ((i) - .5) - textPainter.width / 2,
              textPainter.height - 5),
        );
        // }
      }
    }
    canvas.drawLine(
      Offset(0, 0),
      Offset(heightResizer, 0),
      linePainter,
    );

    //
    //Right Axis
    //
    moredub = ipt.first.amount;
    if (moredub > 1) {
      moredub /= 10;
    }
    //tempSaver = ipt.last.amount < 10 ? 1 : ((ipt.last.amount) /10).roundToDouble().toInt();
    //for (int i = tempSaver; i <= (ipt.last.amount); i+=tempSaver) {
    for (int i = 1; i <= 10; i++) {
      double dub = moredub * i;
      canvas.drawLine(
          Offset(heightResizer, -offsetterPrinc * (dub)),
          Offset(heightResizer + 10, -offsetterPrinc * (dub)),
          Paint()
            ..color = totalRepaidColor
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round);
      textPainter.text = TextSpan(
        text: moredub <= 1
            ? '${dub.toStringAsFixed(2)}'
            : '${dub.toStringAsFixed(0)}',
        style: textStyle,
      );
      textPainter.textAlign = TextAlign.left;
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((heightResizer + 15),
            -offsetterPrinc * (dub) - textPainter.height / 2),
      );
      if (moredub <= 1) break;
    }
    canvas.drawLine(
      Offset(heightResizer, 0),
      Offset(heightResizer, -widthResizer),
      linePainter,
    );

    canvas.restore();

    canvas.translate(0, -25);

    textPainter.text =
        TextSpan(text: 'Payment', style: TextStyle(color: paymentColor));
    textPainter.textAlign = TextAlign.right;
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(size.height - textPainter.width,
            -widthResizer - textPainter.height / 2));

    textPainter.text =
        TextSpan(text: 'Principal', style: TextStyle(color: principalColor));
    textPainter.textAlign = TextAlign.right;
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(size.height - textPainter.width,
            -widthResizer * 2 / 3 - textPainter.height / 2));

    textPainter.text =
        TextSpan(text: 'Interest', style: TextStyle(color: interestColor));
    textPainter.textAlign = TextAlign.right;
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(size.height - textPainter.width,
            -widthResizer / 3 - textPainter.height / 2));

    textPainter.text =
        TextSpan(text: 'Total Repaid', style: TextStyle(color: totalRepaidColor));
    textPainter.textAlign = TextAlign.right;
    textPainter.layout();
    textPainter.paint(canvas,
        Offset(size.height - textPainter.width, -textPainter.height / 2));
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) {
    // return oldDelegate.mbd != mbd;
    return false;
  }
}
