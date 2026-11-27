import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/brand.dart';

/// Geometry of the buddy's head, in the buddy's local space (origin at the
/// feet, y up is negative). Accessories are drawn relative to this.
class AccessoryFrame {
  const AccessoryFrame({
    required this.w,
    required this.h,
    required this.s,
    required this.tipX,
    required this.lookX,
    required this.eyeY,
    required this.t,
  });

  final double w;
  final double h;
  final double s;
  final double tipX;
  final double lookX;
  final double eyeY;
  final double t;
}

void paintAccessory(Canvas canvas, String id, AccessoryFrame f) {
  switch (id) {
    case 'party':
      _partyHat(canvas, f);
    case 'crown':
      _crown(canvas, f);
    case 'shades':
      _shades(canvas, f);
    case 'flower':
      _flower(canvas, f);
    case 'bow':
      _bow(canvas, f);
  }
}

void _partyHat(Canvas canvas, AccessoryFrame f) {
  final baseY = -f.h * 0.78;
  final bw = f.w * 0.36;
  final cx = f.tipX * 0.7;
  final apex = Offset(cx + f.w * 0.06, -f.h * 1.24);
  final cone = Path()
    ..moveTo(cx - bw / 2, baseY)
    ..lineTo(apex.dx, apex.dy)
    ..lineTo(cx + bw / 2, baseY)
    ..quadraticBezierTo(cx, baseY + f.h * 0.05, cx - bw / 2, baseY)
    ..close();
  canvas.drawPath(
    cone,
    Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF9A8F), Brand.coral, Brand.coralDeep],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(cx - bw / 2, apex.dy, cx + bw / 2, baseY)),
  );
  canvas.save();
  canvas.clipPath(cone);
  final stripe = Paint()
    ..color = Brand.sun
    ..strokeWidth = f.s * 0.028
    ..style = PaintingStyle.stroke;
  final height = baseY - apex.dy;
  for (var i = 0; i < 4; i++) {
    final y = baseY - (i + 0.5) * height / 4;
    canvas.drawLine(
      Offset(cx - bw, y + bw * 0.25),
      Offset(cx + bw, y - bw * 0.25),
      stripe,
    );
  }
  canvas.restore();
  canvas.drawCircle(apex, f.w * 0.06, Paint()..color = Brand.sun);
  canvas.drawCircle(
    apex + Offset(-f.w * 0.018, -f.w * 0.018),
    f.w * 0.02,
    Paint()..color = Colors.white.withValues(alpha: 0.7),
  );
}

void _crown(Canvas canvas, AccessoryFrame f) {
  final by = -f.h * 0.74;
  final bw = f.w * 0.44;
  final ch = f.h * 0.2;
  final cx = f.tipX * 0.6;
  final crown = Path()
    ..moveTo(cx - bw / 2, by)
    ..lineTo(cx - bw / 2, by - ch)
    ..lineTo(cx - bw / 4, by - ch * 0.5)
    ..lineTo(cx, by - ch * 1.15)
    ..lineTo(cx + bw / 4, by - ch * 0.5)
    ..lineTo(cx + bw / 2, by - ch)
    ..lineTo(cx + bw / 2, by)
    ..close();
  canvas.drawPath(
    crown,
    Paint()
      ..shader =
          const LinearGradient(
            colors: [Color(0xFFFFE27A), Brand.sun, Brand.sunDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(
            Rect.fromLTRB(cx - bw / 2, by - ch * 1.15, cx + bw / 2, by),
          ),
  );
  canvas.drawPath(
    crown,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = f.s * 0.01
      ..color = Brand.sunDeep,
  );
  canvas.drawCircle(
    Offset(cx, by - ch * 0.35),
    f.w * 0.035,
    Paint()..color = Brand.coral,
  );
  canvas.drawCircle(
    Offset(cx - bw * 0.3, by - ch * 0.3),
    f.w * 0.022,
    Paint()..color = Brand.water,
  );
  canvas.drawCircle(
    Offset(cx + bw * 0.3, by - ch * 0.3),
    f.w * 0.022,
    Paint()..color = Brand.water,
  );
}

void _shades(Canvas canvas, AccessoryFrame f) {
  final lens = Paint()..color = const Color(0xFF1B2433);
  final shine = Paint()..color = Colors.white.withValues(alpha: 0.35);
  final lw = f.w * 0.24, lh = f.h * 0.12;
  final centers = [
    Offset(-f.w * 0.17 + f.lookX * 0.5, f.eyeY),
    Offset(f.w * 0.17 + f.lookX * 0.5, f.eyeY),
  ];
  canvas.drawLine(
    centers[0] + Offset(lw * 0.4, -lh * 0.2),
    centers[1] - Offset(lw * 0.4, lh * 0.2),
    Paint()
      ..color = const Color(0xFF1B2433)
      ..strokeWidth = f.s * 0.016,
  );
  for (final c in centers) {
    final r = RRect.fromRectAndCorners(
      Rect.fromCenter(center: c, width: lw, height: lh),
      topLeft: Radius.circular(lh * 0.25),
      topRight: Radius.circular(lh * 0.25),
      bottomLeft: Radius.circular(lh * 0.6),
      bottomRight: Radius.circular(lh * 0.6),
    );
    canvas.drawRRect(r, lens);
    canvas.save();
    canvas.clipRRect(r);
    canvas.drawLine(
      c + Offset(-lw * 0.3, lh * 0.5),
      c + Offset(lw * 0.05, -lh * 0.6),
      shine..strokeWidth = lw * 0.14,
    );
    canvas.restore();
  }
}

void _flower(Canvas canvas, AccessoryFrame f) {
  final c = Offset(f.w * 0.3 + f.tipX * 0.3, -f.h * 0.66);
  final r = f.w * 0.075;
  canvas.save();
  canvas.translate(c.dx, c.dy);
  canvas.rotate(math.sin(f.t * 1.5) * 0.15);
  final petal = Paint()..color = const Color(0xFFFFF4F6);
  final edge = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = f.s * 0.006
    ..color = const Color(0xFFFFB3C1);
  for (var i = 0; i < 5; i++) {
    canvas.save();
    canvas.rotate(i * math.pi * 2 / 5);
    final o = Rect.fromCenter(
      center: Offset(0, -r * 1.05),
      width: r * 1.1,
      height: r * 1.6,
    );
    canvas.drawOval(o, petal);
    canvas.drawOval(o, edge);
    canvas.restore();
  }
  canvas.drawCircle(Offset.zero, r * 0.65, Paint()..color = Brand.sun);
  canvas.restore();
}

void _bow(Canvas canvas, AccessoryFrame f) {
  final c = Offset(-f.w * 0.27 + f.tipX * 0.3, -f.h * 0.66);
  final bw = f.w * 0.19;
  canvas.save();
  canvas.translate(c.dx, c.dy);
  canvas.rotate(-0.35 + math.sin(f.t * 1.8) * 0.06);
  final fill = Paint()..color = Brand.coral;
  for (final side in const [-1.0, 1.0]) {
    final loop = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(side * bw * 0.9, -bw * 0.8, side * bw, 0)
      ..quadraticBezierTo(side * bw * 0.9, bw * 0.8, 0, 0)
      ..close();
    canvas.drawPath(loop, fill);
  }
  canvas.drawCircle(Offset.zero, bw * 0.24, Paint()..color = Brand.coralDeep);
  canvas.restore();
}