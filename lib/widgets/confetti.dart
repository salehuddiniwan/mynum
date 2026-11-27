import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/brand.dart';

/// Two confetti cannons that fire from the lower corners.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({super.key});

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _Piece {
  _Piece({
    required this.p,
    required this.v,
    required this.color,
    required this.size,
    required this.spin,
    required this.round,
  });

  Offset p; // fraction of the screen
  Offset v;
  final Color color;
  final double size;
  final double spin;
  final bool round;
  double rot = 0;
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  static const _colors = [
    Brand.water,
    Brand.waterLight,
    Brand.coral,
    Brand.sun,
    Brand.leaf,
    Color(0xFFB79BFF),
  ];

  final _rng = math.Random();
  final _pieces = <_Piece>[];
  final _frame = ValueNotifier<int>(0);
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  double _age = 0;
  bool _second = false;

  @override
  void initState() {
    super.initState();
    _fire();
    _ticker = createTicker(_tick)..start();
  }

  void _fire() {
    for (final fromLeft in const [true, false]) {
      for (var i = 0; i < 55; i++) {
        final a =
            (fromLeft ? -1.15 : -math.pi + 1.15) +
            (_rng.nextDouble() - 0.5) * 0.7;
        final speed = 1.0 + _rng.nextDouble() * 0.9;
        _pieces.add(
          _Piece(
            p: Offset(fromLeft ? -0.02 : 1.02, 0.78),
            v: Offset(math.cos(a) * speed * 0.75, math.sin(a) * speed),
            color: _colors[_rng.nextInt(_colors.length)],
            size: 6 + _rng.nextDouble() * 6,
            spin: (_rng.nextDouble() - 0.5) * 16,
            round: _rng.nextDouble() < 0.3,
          ),
        );
      }
    }
  }

  void _tick(Duration elapsed) {
    var dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    if (dt <= 0) return;
    dt = math.min(dt, 1 / 30);
    _age += dt;
    if (!_second && _age > 0.7) {
      _second = true;
      _fire();
    }
    for (final c in _pieces) {
      c.v = Offset(c.v.dx * (1 - 1.2 * dt), c.v.dy * (1 - 1.2 * dt) + 1.3 * dt);
      c.p += c.v * dt;
      c.rot += c.spin * dt;
    }
    _pieces.removeWhere((c) => c.p.dy > 1.1);
    if (_second && _pieces.isEmpty) _ticker.stop();
    _frame.value++;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(_pieces, _frame),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces, Listenable repaint) : super(repaint: repaint);

  final List<_Piece> pieces;

  @override
  void paint(Canvas canvas, Size size) {
    for (final c in pieces) {
      final paint = Paint()..color = c.color;
      final o = Offset(c.p.dx * size.width, c.p.dy * size.height);
      canvas.save();
      canvas.translate(o.dx, o.dy);
      canvas.rotate(c.rot);
      if (c.round) {
        canvas.drawCircle(Offset.zero, c.size * 0.45, paint);
      } else {
        // Scaling one axis by cos(rot) fakes a 3D tumble.
        canvas.scale(1, math.cos(c.rot * 1.7).abs() * 0.8 + 0.2);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: c.size,
              height: c.size * 0.55,
            ),
            const Radius.circular(2),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => false;
}