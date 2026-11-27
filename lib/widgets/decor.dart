import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/brand.dart';

/// Draws a pond decoration centred on [c], roughly [size] wide.
void paintDecor(
  Canvas canvas,
  String id,
  Offset c,
  double size,
  double t, {
  bool flip = false,
}) {
  switch (id) {
    case 'lily':
      _lilyPad(canvas, c, size, t);
    case 'lotus':
      _lilyPad(canvas, c + Offset(0, size * 0.12), size * 0.9, t);
      _lotus(canvas, c, size * 0.55, t);
    case 'duck':
      _duck(canvas, c, size, t, flip);
    case 'frog':
      _frog(canvas, c, size, t);
  }
}

void _lilyPad(Canvas canvas, Offset c, double size, double t) {
  final rect = Rect.fromCenter(center: c, width: size, height: size * 0.42);
  final pad = Path()
    ..moveTo(c.dx, c.dy)
    ..arcTo(rect, -math.pi / 2 + 0.3, math.pi * 2 - 0.6, false)
    ..close();
  canvas.drawPath(
    pad.shift(Offset(0, size * 0.03)),
    Paint()..color = const Color(0xFF1E7A4C).withValues(alpha: 0.35),
  );
  canvas.drawPath(pad, Paint()..color = const Color(0xFF3DBB6E));
  final vein = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = size * 0.02
    ..color = const Color(0xFF2E9E5A);
  for (var i = 1; i < 5; i++) {
    final a = -math.pi / 2 + 0.3 + i * (math.pi * 2 - 0.6) / 5;
    canvas.drawLine(
      c,
      c + Offset(math.cos(a) * size * 0.4, math.sin(a) * size * 0.17),
      vein,
    );
  }
}

void _lotus(Canvas canvas, Offset c, double size, double t) {
  final petal = Paint()..color = const Color(0xFFFF9EC0);
  final petalLight = Paint()..color = const Color(0xFFFFC7DA);
  for (final (angle, paint) in [
    (-1.1, petal),
    (1.1, petal),
    (-0.55, petalLight),
    (0.55, petalLight),
    (0.0, petalLight),
  ]) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angle + math.sin(t * 1.2) * 0.04);
    final p = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size * 0.28, -size * 0.35, 0, -size * 0.7)
      ..quadraticBezierTo(-size * 0.28, -size * 0.35, 0, 0)
      ..close();
    canvas.drawPath(p, paint);
    canvas.restore();
  }
  canvas.drawCircle(
    c + Offset(0, -size * 0.12),
    size * 0.1,
    Paint()..color = Brand.sun,
  );
}

void _duck(Canvas canvas, Offset c, double size, double t, bool flip) {
  canvas.save();
  canvas.translate(c.dx, c.dy + math.sin(t * 2.2) * size * 0.03);
  if (flip) canvas.scale(-1, 1);
  canvas.rotate(math.sin(t * 2.2 + 1) * 0.05);
  const yellow = Color(0xFFFFD84A);
  const yellowDeep = Color(0xFFF2B70F);
  canvas.drawOval(
    Rect.fromCenter(
      center: Offset(0, size * 0.18),
      width: size * 1.0,
      height: size * 0.16,
    ),
    Paint()..color = Colors.white.withValues(alpha: 0.35),
  );
  final body = Path()
    ..moveTo(-size * 0.45, -size * 0.05)
    ..quadraticBezierTo(-size * 0.5, size * 0.2, -size * 0.1, size * 0.2)
    ..lineTo(size * 0.25, size * 0.2)
    ..quadraticBezierTo(size * 0.45, size * 0.18, size * 0.38, -size * 0.05)
    ..quadraticBezierTo(0, size * 0.02, -size * 0.45, -size * 0.05)
    ..close();
  canvas.drawPath(body, Paint()..color = yellow);
  canvas.drawPath(
    Path()
      ..moveTo(-size * 0.2, size * 0.02)
      ..quadraticBezierTo(0, size * 0.14, size * 0.15, size * 0.02),
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size * 0.04
      ..color = yellowDeep,
  );
  final head = Offset(size * 0.22, -size * 0.2);
  canvas.drawCircle(head, size * 0.2, Paint()..color = yellow);
  final beak = Path()
    ..moveTo(head.dx + size * 0.14, head.dy - size * 0.02)
    ..quadraticBezierTo(
      head.dx + size * 0.36,
      head.dy + size * 0.02,
      head.dx + size * 0.14,
      head.dy + size * 0.08,
    )
    ..close();
  canvas.drawPath(beak, Paint()..color = Brand.flame);
  canvas.drawCircle(
    head + Offset(size * 0.06, -size * 0.05),
    size * 0.035,
    Paint()..color = const Color(0xFF1B2433),
  );
  canvas.restore();
}

void _frog(Canvas canvas, Offset c, double size, double t) {
  const green = Color(0xFF55C46A);
  const greenDeep = Color(0xFF379C4C);
  final breathe = 1 + math.sin(t * 3) * 0.03;
  canvas.save();
  canvas.translate(c.dx, c.dy);
  canvas.scale(breathe, 1 / breathe);
  final body = Rect.fromCenter(
    center: Offset(0, -size * 0.12),
    width: size * 0.8,
    height: size * 0.5,
  );
  canvas.drawOval(body, Paint()..color = green);
  canvas.drawOval(
    Rect.fromCenter(
      center: Offset(0, -size * 0.02),
      width: size * 0.5,
      height: size * 0.2,
    ),
    Paint()..color = const Color(0xFFBFF0B0),
  );
  for (final side in const [-1.0, 1.0]) {
    final e = Offset(side * size * 0.2, -size * 0.36);
    canvas.drawCircle(e, size * 0.14, Paint()..color = green);
    canvas.drawCircle(e, size * 0.09, Paint()..color = Colors.white);
    canvas.drawCircle(
      e + Offset(0, size * 0.01),
      size * 0.05,
      Paint()..color = const Color(0xFF1B2433),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(side * size * 0.27, -size * 0.12),
        width: size * 0.1,
        height: size * 0.05,
      ),
      Paint()..color = const Color(0xFFFF8FA3).withValues(alpha: 0.6),
    );
  }
  canvas.drawPath(
    Path()
      ..moveTo(-size * 0.14, -size * 0.17)
      ..quadraticBezierTo(0, -size * 0.07, size * 0.14, -size * 0.17),
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size * 0.03
      ..color = greenDeep,
  );
  canvas.restore();
}

/// A small static preview of a decoration (used in the shop).
class DecorPreview extends StatefulWidget {
  const DecorPreview({super.key, required this.id, this.size = 90});

  final String id;
  final double size;

  @override
  State<DecorPreview> createState() => _DecorPreviewState();
}

class _DecorPreviewState extends State<DecorPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.square(widget.size),
        painter: _DecorPreviewPainter(widget.id, _c),
      ),
    );
  }
}

class _DecorPreviewPainter extends CustomPainter {
  _DecorPreviewPainter(this.id, this.anim) : super(repaint: anim);

  final String id;
  final Animation<double> anim;

  @override
  void paint(Canvas canvas, Size size) {
    final t = anim.value * 20;
    final c = size.center(Offset.zero);
    canvas.drawOval(
      Rect.fromCenter(
        center: c + Offset(0, size.height * 0.12),
        width: size.width * 0.95,
        height: size.height * 0.42,
      ),
      Paint()..color = Brand.waterLight.withValues(alpha: 0.55),
    );
    paintDecor(
      canvas,
      id,
      c + Offset(0, size.height * 0.08),
      size.width * 0.62,
      t,
    );
  }

  @override
  bool shouldRepaint(_DecorPreviewPainter oldDelegate) => oldDelegate.id != id;
}
