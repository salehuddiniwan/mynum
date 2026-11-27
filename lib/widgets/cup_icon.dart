import 'package:flutter/material.dart';

import '../theme/brand.dart';

/// A tiny drawn cup, glass or bottle depending on the amount.
class CupIcon extends StatelessWidget {
  const CupIcon({super.key, required this.ml, this.size = 40});

  final int ml;
  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size * 0.8, size), painter: _CupPainter(ml));
}

class _CupPainter extends CustomPainter {
  _CupPainter(this.ml);

  final int ml;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.075
      ..strokeJoin = StrokeJoin.round
      ..color = Brand.waterDeep;
    final fill = Paint()..color = Brand.waterLight;

    final Path shape;
    double fillTop;
    if (ml <= 150) {
      shape = Path()
        ..moveTo(w * 0.1, h * 0.4)
        ..lineTo(w * 0.2, h * 0.95)
        ..lineTo(w * 0.8, h * 0.95)
        ..lineTo(w * 0.9, h * 0.4)
        ..close();
      fillTop = h * 0.58;
    } else if (ml <= 300) {
      shape = Path()
        ..moveTo(w * 0.12, h * 0.08)
        ..lineTo(w * 0.24, h * 0.95)
        ..lineTo(w * 0.76, h * 0.95)
        ..lineTo(w * 0.88, h * 0.08)
        ..close();
      fillTop = h * 0.36;
    } else {
      final body = Path()
        ..addRRect(
          RRect.fromLTRBR(
            w * 0.16,
            h * 0.3,
            w * 0.84,
            h * 0.96,
            Radius.circular(w * 0.18),
          ),
        );
      final neck = Path()
        ..addRect(Rect.fromLTRB(w * 0.36, h * 0.12, w * 0.64, h * 0.34));
      shape = Path.combine(PathOperation.union, body, neck);
      fillTop = h * 0.4;
      canvas.drawRRect(
        RRect.fromLTRBR(
          w * 0.3,
          h * 0.02,
          w * 0.7,
          h * 0.14,
          Radius.circular(w * 0.05),
        ),
        Paint()..color = Brand.coral,
      );
    }

    canvas.save();
    canvas.clipPath(shape);
    canvas.drawRect(Rect.fromLTRB(0, fillTop, w, h), fill);
    canvas.restore();
    canvas.drawPath(shape, outline);
  }

  @override
  bool shouldRepaint(_CupPainter oldDelegate) => oldDelegate.ml != ml;
}