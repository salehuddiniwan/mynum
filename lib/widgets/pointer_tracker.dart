import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Shares the latest pointer position (global coordinates) with every buddy
/// on screen, so their eyes can follow your cursor or finger. This is the
/// "interactive character" trick from Rive, done in plain Flutter.
class PointerTracker extends StatefulWidget {
  const PointerTracker({super.key, required this.child});

  final Widget child;

  static ValueNotifier<Offset?>? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_PointerScope>()?.position;

  @override
  State<PointerTracker> createState() => _PointerTrackerState();
}

class _PointerTrackerState extends State<PointerTracker> {
  final _position = ValueNotifier<Offset?>(null);
  Timer? _release;

  void _set(Offset? p) {
    _release?.cancel();
    _position.value = p;
  }

  @override
  void dispose() {
    _release?.cancel();
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: false,
      onHover: (e) => _set(e.position),
      onExit: (_) => _set(null),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (e) => _set(e.position),
        onPointerMove: (e) => _set(e.position),
        onPointerUp: (e) {
          if (e.kind != PointerDeviceKind.touch) return;
          // Keep looking at where the finger lifted for a moment.
          _release?.cancel();
          _release = Timer(
            const Duration(milliseconds: 900),
            () => _position.value = null,
          );
        },
        child: _PointerScope(position: _position, child: widget.child),
      ),
    );
  }
}

class _PointerScope extends InheritedWidget {
  const _PointerScope({required this.position, required super.child});

  final ValueNotifier<Offset?> position;

  @override
  bool updateShouldNotify(_PointerScope oldWidget) =>
      oldWidget.position != position;
}