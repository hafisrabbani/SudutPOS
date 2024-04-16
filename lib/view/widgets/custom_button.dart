import 'package:flutter/material.dart';
import 'package:sudut_pos/view/themes/colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color btnColor;
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.label, required this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: Size(MediaQuery.of(context).size.width * 0.9,
            MediaQuery.of(context).size.height * 0.06),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: white)),
    );
  }
}
