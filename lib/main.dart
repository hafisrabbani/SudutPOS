import 'package:flutter/material.dart';
import 'package:sudut_pos/view/templates/base_templates.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sudut Pos',
      home: BaseTemplate(),
    );
  }
}
