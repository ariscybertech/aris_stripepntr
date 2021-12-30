import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum RectType { Square, Circle, Triangle }

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomPaint(
      painter: StripePainter(),
      size: Size.infinite,
    ));
  }
}

class StripePainter extends CustomPainter {
  StripePainter();

  @override
  void paint(Canvas canvas, Size size) {
    drawRRect(
      canvas,
      path: path(
        RectType.Square,
        position: Offset(160, 200),
        size: Size(200, 120),
      ),
      color: Colors.amberAccent,
    );

    drawRRect(
      canvas,
      path: path(
        RectType.Circle,
        position: Offset(100, 600),
        size: Size(120, 120),
      ),
      color: Colors.redAccent,
    );

    drawRRect(
      canvas,
      path:  path(
       RectType.Triangle,
        position: Offset(300, 520),
        size: Size(160, 160),
      ),
      color: Colors.blueAccent,
    );

  }

  Path path(RectType type, {@required Offset position, @required Size size}) {
    double widthf = size.width / 2.0;
    double heightf = size.height / 2.0;
    var start = position - Offset(widthf, heightf);
    var end = position + Offset(widthf, heightf);
    Path _path = Path();
    if (type == RectType.Circle) {
      var radius = min(widthf, heightf) * 2;
      end = start + Offset(radius, radius);
      Rect rect = Rect.fromPoints(start, end);
      RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
      _path.addRRect(rrect);
    } else if (type == RectType.Square) {
      RRect rrect = RRect.fromRectAndRadius(
          Rect.fromPoints(start, end), Radius.circular(8));
      _path.addRRect(rrect);
    } else if (type == RectType.Triangle) {
      _path.moveTo(start.dx, start.dy);
      _path.relativeLineTo(widthf * 2, 0);
      _path.relativeLineTo(-widthf, 2 * heightf);
      _path.relativeLineTo(-widthf, -2 * heightf);
    }
    return _path;
  }

  void drawRRect(Canvas canvas, {@required Path path, @required Color color}) {
    double distance = 20;
    double stroke = 3;
    Offset position = path.getBounds().center;
    double widthf = path.getBounds().width / 2.0;
    double heightf = path.getBounds().height / 2.0;

    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
    Path _path = Path();
    _path.moveTo(position.dx, position.dy);
    for (int i = 0; i < widthf / distance * 2; i++) {
      _path.relativeMoveTo(-distance * i, 0);
      _path.relativeMoveTo(widthf, -heightf);
      _path.relativeLineTo(-widthf * 2, heightf * 2);
      _path.moveTo(position.dx, position.dy);

      _path.relativeMoveTo(distance * i, 0);
      _path.relativeMoveTo(widthf, -heightf);
      _path.relativeLineTo(-widthf * 2, heightf * 2);
      _path.moveTo(position.dx, position.dy);
    }
    canvas.save();
    canvas.clipPath(path);

    canvas.drawPath(
        _path..fillType = PathFillType.evenOdd,
        Paint()
          ..color = Colors.black54
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
