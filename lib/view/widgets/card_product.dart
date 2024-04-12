import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sudut_pos/utility/common.dart';
import 'package:sudut_pos/view/themes/colors.dart';
import 'package:sudut_pos/model/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Widget? child;

  const ProductCard({Key? key, required this.product, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: const Color.fromARGB(255, 255, 255, 255),
      shadowColor: Colors.grey.withOpacity(0.3),
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                CommonUtils().cvIDRCurrency(product.price),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: textColor),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd MMMM yyyy').format(DateTime.parse(product.createdTime)),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.inventory, size: 14, color: textColor),
                  const SizedBox(width: 4),
                  Text(
                    '${product.stock} pcs',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              if (child != null) ...[
                const Divider(),
                child!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
