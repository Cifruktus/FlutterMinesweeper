import 'dart:math';

import 'package:flutter/material.dart';

class SevenSegmentIndicator extends StatelessWidget {
  final int number;
  final double height;
  final int maxDigits;

  const SevenSegmentIndicator({
    Key? key,
    required this.number,
    required this.height,
    this.maxDigits = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textPainter = SevenSegmentTextPainter(
      number: max(min(number, pow(10, maxDigits).toInt() - 1), 0),
      height: height,
      digits: maxDigits,
    );

    return Container(
      color: Colors.black87,
      padding: EdgeInsets.all(4),
      child: CustomPaint(
        size: textPainter.layout(),
        painter: SevenSegmentIndicatorPainter(
          textPainter: textPainter,
        ),
      ),
    );
  }
}

class SevenSegmentIndicatorPainter extends CustomPainter {
  SevenSegmentTextPainter textPainter;

  SevenSegmentIndicatorPainter({
    required this.textPainter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    textPainter.draw(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SevenSegmentTextPainter {
  List<Path> segments = []; // starting from top, going clockwise, center segment at the end

  final double letterSpacing = 1.07;
  final double height;
  final int digits;
  final int number;
  late Size size;

  static const segmentsToLight = [
    [true, true, true, true, true, true, false],
    [false, true, true, false, false, false, false],
    [true, true, false, true, true, false, true],
    [true, true, true, true, false, false, true],
    [false, true, true, false, false, true, true],
    [true, false, true, true, false, true, true],
    [true, false, true, true, true, true, true],
    [true, true, true, false, false, false, false],
    [true, true, true, true, true, true, true],
    [true, true, true, true, false, true, true],
  ];

  SevenSegmentTextPainter({required this.height, required this.digits, required this.number}) {
    var segmentWidth = height * 0.15;
    size = Size((height + (segmentWidth / 2)) / 2, height);

    var shrinkValue = 0.1;
    var topSquare = Rect.fromLTRB(
      segmentWidth,
      segmentWidth,
      size.width - segmentWidth,
      (size.height - segmentWidth) / 2,
    );
    var botSquare = Rect.fromLTRB(
      segmentWidth,
      (size.height + segmentWidth) / 2,
      size.width - segmentWidth,
      size.height - segmentWidth,
    );

    var segmentsPoints = [
      [
        Offset(0, 0),
        Offset(size.width, 0),
        Offset(topSquare.right, topSquare.top),
        Offset(topSquare.left, topSquare.top),
      ],
      [
        Offset(size.width, 0),
        Offset(size.width, size.height / 2),
        Offset(topSquare.right, topSquare.bottom),
        Offset(topSquare.right, topSquare.top),
      ],
      [
        Offset(size.width, size.height / 2),
        Offset(size.width, size.height),
        Offset(botSquare.right, botSquare.bottom),
        Offset(botSquare.right, botSquare.top),
      ],
      [
        Offset(0, size.height),
        Offset(botSquare.left, botSquare.bottom),
        Offset(botSquare.right, botSquare.bottom),
        Offset(size.width, size.height),
      ],
      [
        Offset(0, size.height),
        Offset(0, size.height / 2),
        Offset(botSquare.left, botSquare.top),
        Offset(botSquare.left, botSquare.bottom),
      ],
      [
        Offset(0, 0),
        Offset(topSquare.left, topSquare.top),
        Offset(topSquare.left, topSquare.bottom),
        Offset(0, size.height / 2),
      ],
      [
        Offset(0, size.height / 2),
        Offset(topSquare.left, topSquare.bottom),
        Offset(topSquare.right, topSquare.bottom),
        Offset(size.width, size.height / 2),
        Offset(botSquare.right, botSquare.top),
        Offset(botSquare.left, botSquare.top),
      ]
    ];

    for (var segment in segmentsPoints) {
      segments.add(Path()..addPolygon(shrink(segment, shrinkValue), true));
    }
  }

  Size layout() {
    return Size(size.width * digits * letterSpacing - (size.width * (letterSpacing - 1)), size.height);
  }

  void drawDigit(Canvas canvas, Offset position, int number) {
    var activeColor = Paint()..color = Colors.red;
    var inactiveColor = Paint()..color = Colors.red.withAlpha(80);
    for (int i = 0; i < segments.length; i++) {
      canvas.drawPath(segments[i].shift(position), segmentsToLight[number][i] ? activeColor : inactiveColor);
    }
  }

  void draw(Canvas canvas) {
    var num = number;
    for (int i = digits - 1; i >= 0; i--) {
      drawDigit(canvas, Offset(size.width * i * letterSpacing, 0), num % 10);
      num = (num / 10).floor();
    }
  }

  List<Offset> shrink(List<Offset> points, double amount) {
    var center = Offset(0, 0);

    for (var point in points) {
      center = center.translate(point.dx, point.dy);
    }
    center = Offset(center.dx / points.length, center.dy / points.length);

    List<Offset> shrunken = [];

    for (var point in points) {
      shrunken.add(Offset.lerp(point, center, amount)!);
    }
    return shrunken;
  }
}
