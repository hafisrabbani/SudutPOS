import 'package:flutter/material.dart';
import 'package:sudut_pos/view/themes/colors.dart';

class CustomAlert {
  final String title;
  final String content;

  CustomAlert({this.title = 'Alert', this.content = 'This is an alert message.'});

  static void show(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.warning, color: dangerColor),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
