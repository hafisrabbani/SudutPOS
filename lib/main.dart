import 'package:flutter/material.dart';
import 'package:sudut_pos/view/templates/base_templates.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudut Pos',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        )
      ),
      home: BaseTemplate(),
    );
  }
}
