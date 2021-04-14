import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:loan_calc_dev/models/data_classes.dart';

class GraphPainter extends CustomPainter {

  GraphPainter({
    required this.themeBrightness,
    required this.textStyle,
    required this.ipt,
    required this.mbd,
  })  : linePainter = Paint()
          ..color = textStyle.color!
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round,
        textPainter = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        isDark = themeBrightness == Brightness.dark {
    paymentColor = isDark ? Colors.purpleAccent : Colors.purple;
    principalColor = isDark ? Colors.blueAccent : Colors.blue;
    interestColor = isDark ? Colors.redAccent : Colors.red;
    totalRepaidColor = isDark ? Colors.greenAccent : Colors.green;
  }

  final Paint linePainter;
  final TextPainter textPainter;
  final TextStyle textStyle;
  final Brightness themeBrightness;
  final List<MonthlyBreakDown> mbd;
  final InputTracker ipt;
  final bool isDark;
  late Color paymentColor;
  late Color principalColor;
  late Color interestColor;
  late Color totalRepaidColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.rotate(math.pi / 2);

    final heightResizer = size.height * 0.65;
    final widthResizer = size.width * 0.85;

    final monthLength = mbd.length;

    final offsetter = heightResizer / monthLength;
    final iptAmount = double.parse("ipt.amount");
    final offsetterPrinc = widthResizer / (iptAmount * 1.1);
    final length = widthResizer / (mbd[0].payment * 1.1);

    canvas.save();

    canvas.translate(55, -25);

    Paint graphLinePaint(Color color) => Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = color;

    final graphIndexPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    final princPaint = graphLinePaint(principalColor);
    final princPath = Path();
    final intPaint = graphLinePaint(interestColor);
    final intPath = Path();
    final totPrincPaint = graphLinePaint(totalRepaidColor);
    final totPrincPath = Path();
    final monthPaint = graphLinePaint(paymentColor);
    final monthPath = Path();   

    if (monthLength == 1) {
      canvas.drawPoints(
        ui.PointMode.points,
        [Offset(0.5 * offsetter, -length * mbd[0].paidPrinc)],
        princPaint..strokeWidth = 10,
      );
      canvas.drawPoints(
        ui.PointMode.points,
        [Offset(0.5 * offsetter, -length * mbd[0].paidInt)],
        intPaint..strokeWidth = 8,
      );
      canvas.drawPoints(
        ui.PointMode.points,
        [Offset(0.5 * offsetter, -length * mbd[0].totPrinc)],
        totPrincPaint..strokeWidth = 6,
      );
      canvas.drawPoints(
        ui.PointMode.points,
        [Offset(0.5 * offsetter, -length * mbd[0].payment)],
        monthPaint,
      ); 
    } else {
      princPath.moveTo(0.5 * offsetter, -length * mbd[0].paidPrinc);
      intPath.moveTo(0.5 * offsetter, -length * mbd[0].paidInt);
      totPrincPath.moveTo(0.5 * offsetter, -offsetterPrinc * mbd[0].totPrinc);
      monthPath.moveTo(0.5 * offsetter, -length * mbd[0].payment);
      for (int i = 1; i < monthLength; i++) {
        princPath.lineTo((i + 0.5) * offsetter, -length * mbd[i].paidPrinc);
        intPath.lineTo((i + 0.5) * offsetter, -length * mbd[i].paidInt);
        totPrincPath.lineTo((i + 0.5) * offsetter, -offsetterPrinc * mbd[i].totPrinc);    
        monthPath.lineTo((i + 0.5) * offsetter, -length * mbd[i].payment);
      }        
      canvas.drawPath(princPath, princPaint);
      canvas.drawPath(intPath, intPaint);
      canvas.drawPath(totPrincPath, totPrincPaint);
      canvas.drawPath(monthPath, monthPaint);
    }

    //
    //Left Axis
    //
    double moredub = mbd[0].payment;
    if (moredub > 1) {
      moredub /= 10;
    }
    for (int i = 1; i <= 10; i++) {
      double dub = moredub * i;
      canvas.drawLine(
        Offset(-10, -length * dub),
        Offset(0, -length * dub),
        graphIndexPaint..color = textStyle.color!,
      );
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
          -textPainter.width - 15,
          -length * dub - textPainter.height / 2,
        ),
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
    if (monthLength > 4)  {
      modulo = (monthLength / 10).roundToDouble().toInt();
    }

    for (int i = 1; i <= monthLength; i++) {
      if (i % modulo == 0 && i <= (monthLength * 0.95).toInt() ||
          i == 1 ||
          i == monthLength) {
        canvas.drawLine(
          Offset(offsetter * (i - 0.5), 10),
          Offset(offsetter * (i - 0.5), 0),
          graphIndexPaint,
        );
        textPainter.text = TextSpan(
          text: '$i',
          style: textStyle,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            offsetter * (i - 0.5) - textPainter.width / 2,
            textPainter.height - 5,
          ),
        );
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
    moredub = iptAmount;
    if (moredub > 1) {
      moredub /= 10;
    }
    for (int i = 1; i <= 10; i++) {
      double dub = moredub * i;
      canvas.drawLine(
        Offset(heightResizer, -offsetterPrinc * dub),
        Offset(heightResizer + 10, -offsetterPrinc * dub),
        graphIndexPaint..color = totalRepaidColor,
      );
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
        Offset(
          heightResizer + 15,
          -offsetterPrinc * dub - textPainter.height / 2,
        ),
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

    void paintLegendText(String text, Color textColor, double position) {
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.textAlign = TextAlign.right;
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          size.height - textPainter.width,
          -widthResizer * position - textPainter.height / 2,
        ),
      );
    }

    paintLegendText(
      'Payment',
      paymentColor,
      1, // 3 / 3
    );

    paintLegendText(
      'Principal',
      principalColor,
      2 / 3,
    );

    paintLegendText(
      'Interest',
      interestColor,
      1 / 3,
    );

    paintLegendText(
      'Total Repaid',
      totalRepaidColor,
      0,
    );
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) => false;
}