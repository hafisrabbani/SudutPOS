import 'package:flutter/material.dart';
import 'package:sudut_pos/model/product_cart.dart';
import 'package:sudut_pos/view/themes/colors.dart';

class SingleCartButton extends StatelessWidget {
  final ProductCart product;
  final Function(ProductCart) onPressed;

  const SingleCartButton({
    required this.product,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // set width full
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: white),
        onPressed: () {
          onPressed(product);
        },
      ),
    );
  }
}
