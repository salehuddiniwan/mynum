import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/brand.dart';

/// On phones the app fills the screen. On a wide Windows window or browser
/// it shows inside a phone-shaped frame, so the mobile layout stays intact.
class AdaptiveFrame extends StatelessWidget {
  const AdaptiveFrame({super.key, required this.child});

  final Widget child;

  static const _phoneWidth = 420.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 620) return child;
        final mq = MediaQuery.of(context);
        final height = math.min(constraints.maxHeight - 48, 900.0);
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFDDEFFF), Color(0xFFF4F9FF), Color(0xFFE6F6EE)],
            ),
          ),
          child: Center(
            child: Container(
              width: _phoneWidth,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: Brand.shadowFloat,
              ),
              clipBehavior: Clip.antiAlias,
              child: MediaQuery(
                data: mq.copyWith(
                  size: Size(_phoneWidth, height),
                  padding: EdgeInsets.zero,
                  viewPadding: EdgeInsets.zero,
                  viewInsets: EdgeInsets.zero,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}