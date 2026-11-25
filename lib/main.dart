import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'theme/brand.dart';
import 'widgets/adaptive_frame.dart';

void main() {
  runApp(const MynumApp());
}

class MynumApp extends StatelessWidget {
  const MynumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MYNUM',
      debugShowCheckedModeBanner: false,
      theme: Brand.theme(),
      builder: (context, child) => AdaptiveFrame(child: child!),
      home: const HomeShell(),
    );
  }
}