import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudut_pos/provider/cart_provider.dart';
import 'package:sudut_pos/view/pages/checkout.dart';
import 'package:sudut_pos/view/templates/base_templates.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'Sudut Pos',
        theme: ThemeData(
          textTheme: GoogleFonts.rubikTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const BaseTemplate(),
        routes: {
          '/checkout': (context) => const CheckoutPage(transactionDetails: []),
        },
      ),
    );
  }
}

