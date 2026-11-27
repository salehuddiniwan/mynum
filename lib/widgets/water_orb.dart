import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/brand.dart';

/// A glassy bubble that fills with animated water as [level] goes 0 → 1,
/// with pulsing rings behind it. The buddy sits inside as [child].
class WaterOrb extends StatefulWidget {
  const WaterOrb({
    super.key,
    required this.level,
    required this.size,
    this.child,
  });

  final double level;
  final double size;

  /// Placed so its bottom-centre sits low inside the orb.
  final Widget? child;

  @override
  State<WaterOrb> createState() => _WaterOrbState();
}

class _OrbState {
  double t = 0;
  double level = 0;
  double velocity = 0;
  double slosh = 0;
}

class _WaterOrbState extends State<WaterOrb>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _frame = ValueNotifier<int>(0);
  final _s = _OrbState();
  Duration _last = Duration.zero;

  @override
  void initState() {
    super.initState();
    _s.level = widget.level;
    _ticker = createTicker(_tick)..start();
  }

  @override
  void didUpdateWidget(WaterOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.level - oldWidget.level).abs() > 0.02) _s.slosh = 1;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    var dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    if (dt <= 0) return;
    dt = math.min(dt, 1 / 30);
    _s.t += dt;
    // A soft spring toward the target level, so the water "pours" in.
    final a = 28 * (widget.level - _s.level) - 9 * _s.velocity;
    _s.velocity += a * dt;
    _s.level += _s.velocity * dt;
    _s.slosh *= math.exp(-dt * 1.2);
    _frame.value++;
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final r = size * 0.4;
    final childSize = r * 1.3;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(painter: _OrbPainter(_s, _frame)),
            ),
          ),
          if (widget.child != null)
            Positioned(
              left: size / 2 - childSize / 2,
              top: size / 2 + r * 0.6 - childSize * 0.94,
              width: childSize,
              height: childSize,
              child: widget.child!,
            ),
        ],
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  _OrbPainter(this.s, Listenable repaint) : super(repaint: repaint);

  final _OrbState s;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width * 0.4;
    final t = s.t;

    // Pulsing rings.
    for (var i = 0; i < 2; i++) {
      final ph = ((t / 2.8) + i * 0.5) % 1.0;
      canvas.drawCircle(
        c,
        r * (1.0 + ph * 0.24),
        Paint()..color = Brand.water.withValues(alpha: 0.14 * (1 - ph)),
      );
    }

    canvas.drawCircle(
      c + Offset(0, r * 0.06),
      r,
      Paint()
        ..color = Brand.waterDeep.withValues(alpha: 0.18)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.12),
    );

    final circle = Rect.fromCircle(center: c, radius: r);
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.4),
          colors: [Colors.white, Brand.foam],
        ).createShader(circle),
    );

    canvas.save();
    canvas.clipPath(Path()..addOval(circle));

    final level = s.level.clamp(0.0, 1.05);
    final top = c.dy + r - math.max(level, 0.03) * 2 * r;
    final amp = r * (0.03 + 0.05 * s.slosh + 0.04 * s.velocity.abs());
    final k = math.pi * 2 / (r * 1.6);

    Path wave(double phase, double speed, double ampScale) {
      final path = Path()..moveTo(c.dx - r, c.dy + r);
      for (var x = c.dx - r; x <= c.dx + r + 4; x += 4) {
        path.lineTo(
          x,
          top + math.sin(x * k + t * speed + phase) * amp * ampScale,
        );
      }
      path
        ..lineTo(c.dx + r, c.dy + r)
        ..close();
      return path;
    }

    canvas.drawPath(
      wave(1.3, 1.7, 0.9),
      Paint()..color = Brand.waterLight.withValues(alpha: 0.75),
    );
    canvas.drawPath(
      wave(0, -2.3, 1),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Brand.water.withValues(alpha: 0.85), Brand.waterDeep],
        ).createShader(Rect.fromLTRB(c.dx - r, top, c.dx + r, c.dy + r)),
    );

    // Rising bubbles.
    final bubble = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = Colors.white.withValues(alpha: 0.45);
    for (var i = 0; i < 7; i++) {
      final seed = (i * 0.37) % 1.0;
      final ph = (t * (0.12 + seed * 0.1) + seed) % 1.0;
      final y = c.dy + r - ph * (c.dy + r - top);
      if (y < top + amp) continue;
      final x = c.dx + (seed * 2 - 1) * r * 0.75 + math.sin(t * 2 + i) * 4;
      canvas.drawCircle(Offset(x, y), 2 + seed * 4, bubble);
    }
    canvas.restore();

    // Glass rim and gloss.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.035
        ..color = Colors.white.withValues(alpha: 0.9),
    );
    canvas.drawCircle(
      c,
      r + r * 0.018,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = Brand.waterLight.withValues(alpha: 0.6),
    );
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r * 0.86),
      math.pi * 1.08,
      math.pi * 0.3,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = r * 0.045
        ..color = Colors.white.withValues(alpha: 0.75),
    );
  }

  @override
  bool shouldRepaint(_OrbPainter oldDelegate) => false;
}