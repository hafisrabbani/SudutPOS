import 'package:flutter/material.dart';
import 'package:sudut_pos/view/themes/colors.dart';
import 'package:sudut_pos/view/widgets/card_product.dart';
import 'package:sudut_pos/model/product.dart';
import 'package:sudut_pos/view/widgets/search_bar.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final Product product = Product(
    id: 1,
    name: 'Product Name',
    price: 10000,
    stock: 10,
    createdTime: '2021-10-10',
    // 'yyyy-MM-dd
    updatedTime: '2021-10-10', // 'yyyy-MM-dd
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                      controller: TextEditingController(),
                      hintText: 'Search product',
                      onChanged: (value) {},
                      onClear: () {},
                      onSearch: () {}),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                // Padding(padding: const EdgeInsets.all(8), child: ProductCard(product: product));
                // return ProductCard(product: product);
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ProductCard(product: product),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Trigger modal insert inventory
        },
        mini: true,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: secondaryColor),
      ),
    );
  }
}
