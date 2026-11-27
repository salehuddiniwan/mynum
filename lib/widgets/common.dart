import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/brand.dart';

/// A chunky, tactile button with a "lip" underneath that squishes when
/// pressed — the Duolingo-style 3D button.
class Pressable3D extends StatefulWidget {
  const Pressable3D({
    super.key,
    required this.child,
    required this.onPressed,
    this.face = Brand.water,
    this.lip = Brand.waterDeep,
    this.height = 56,
    this.radius = 18,
    this.lipHeight = 5,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.border,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color face;
  final Color lip;
  final double height;
  final double radius;
  final double lipHeight;
  final EdgeInsets padding;
  final BoxBorder? border;

  @override
  State<Pressable3D> createState() => _Pressable3DState();
}

class _Pressable3DState extends State<Pressable3D> {
  bool _down = false;

  void _set(bool down) {
    if (_down != down) setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final face = enabled ? widget.face : Brand.disabled;
    final lip = enabled ? widget.lip : Brand.disabledDeep;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: enabled ? (_) => _set(true) : null,
        onTapCancel: enabled ? () => _set(false) : null,
        onTapUp: enabled
            ? (_) {
                _set(false);
                HapticFeedback.selectionClick();
                widget.onPressed!();
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 70),
          height: widget.height,
          margin: EdgeInsets.only(
            top: _down ? widget.lipHeight : 0,
            bottom: _down ? 0 : widget.lipHeight,
          ),
          padding: widget.padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: face,
            borderRadius: BorderRadius.circular(widget.radius),
            border: widget.border,
            boxShadow: [
              BoxShadow(
                color: lip,
                offset: Offset(0, _down ? 0 : widget.lipHeight),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class ChunkyButton extends StatelessWidget {
  const ChunkyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = Brand.water,
    this.lip = Brand.waterDeep,
    this.foreground = Colors.white,
    this.height = 56,
    this.fontSize = 19,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final Color lip;
  final Color foreground;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final fg = onPressed == null ? Brand.inkSoft : foreground;
    return Pressable3D(
      onPressed: onPressed,
      face: color,
      lip: lip,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: fg, size: fontSize + 3),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Brand.display(fontSize, color: fg),
            ),
          ),
        ],
      ),
    );
  }
}

/// A small rounded stat pill, e.g. 🔥 3 or 💧 120.
class StatPill extends StatelessWidget {
  const StatPill({
    super.key,
    required this.icon,
    required this.color,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
      decoration: BoxDecoration(
        color: Brand.surface,
        borderRadius: BorderRadius.circular(99),
        boxShadow: Brand.shadowCard,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          TweenAnimationBuilder<double>(
            tween: Tween(end: value.toDouble()),
            duration: Brand.slow,
            curve: Curves.easeOutCubic,
            builder: (context, v, _) =>
                Text(v.round().toString(), style: Brand.display(16)),
          ),
        ],
      ),
    );
  }
}

/// Title + subtitle at the top of a tab, with optional trailing widgets.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing = const [],
  });

  final String title;
  final String? subtitle;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtitle != null)
                Text(subtitle!, style: Brand.body(14, color: Brand.inkSoft)),
              Text(title, style: Brand.display(30)),
            ],
          ),
        ),
        for (final w in trailing) ...[const SizedBox(width: 8), w],
      ],
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.title,
    this.trailing,
    required this.child,
  });

  final String? title;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Brand.gap5),
      decoration: Brand.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(child: Text(title!, style: Brand.display(19))),
                ?trailing,
              ],
            ),
            const SizedBox(height: Brand.gap3),
          ],
          child,
        ],
      ),
    );
  }
}

class SpeechBubble extends StatelessWidget {
  const SpeechBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BubblePainter(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 9, 16, 19),
        child: Text(text, style: Brand.display(16)),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const tail = 10.0;
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height - tail),
      const Radius.circular(16),
    );
    final cx = size.width / 2;
    final path = Path()
      ..addRRect(body)
      ..moveTo(cx - 9, size.height - tail - 1)
      ..lineTo(cx, size.height)
      ..lineTo(cx + 9, size.height - tail - 1)
      ..close();
    canvas.drawShadow(path, const Color(0xFF1C64D8), 6, false);
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_BubblePainter oldDelegate) => false;
}

/// Floats a little "+12" (or any text) up from a point on screen.
void showFloatingText(
  BuildContext context,
  Offset globalPosition,
  String text, {
  Color color = Brand.water,
  IconData? icon = Icons.water_drop_rounded,
}) {
  final overlay = Overlay.maybeOf(context);
  if (overlay == null) return;
  final box = overlay.context.findRenderObject() as RenderBox?;
  final local = box?.globalToLocal(globalPosition) ?? globalPosition;
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _FloatingText(
      position: local,
      text: text,
      color: color,
      icon: icon,
      onDone: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

class _FloatingText extends StatefulWidget {
  const _FloatingText({
    required this.position,
    required this.text,
    required this.color,
    required this.icon,
    required this.onDone,
  });

  final Offset position;
  final String text;
  final Color color;
  final IconData? icon;
  final VoidCallback onDone;

  @override
  State<_FloatingText> createState() => _FloatingTextState();
}

class _FloatingTextState extends State<_FloatingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward().whenComplete(widget.onDone);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        final rise = Curves.easeOutCubic.transform(t);
        final pop = t < 0.2 ? Curves.easeOutBack.transform(t / 0.2) : 1.0;
        return Positioned(
          left: widget.position.dx - 60,
          top: widget.position.dy - 30 - rise * 56,
          width: 120,
          child: IgnorePointer(
            child: Opacity(
              opacity: (1 - t * t).clamp(0.0, 1.0),
              child: Transform.scale(
                scale: pop,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      style: Brand.display(22, color: widget.color).copyWith(
                        shadows: const [
                          Shadow(color: Colors.white, blurRadius: 6),
                        ],
                      ),
                    ),
                    if (widget.icon != null)
                      Icon(widget.icon, color: widget.color, size: 22),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}