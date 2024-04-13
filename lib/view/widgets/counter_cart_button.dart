import 'package:flutter/material.dart';
import 'package:sudut_pos/model/product_cart.dart';

class CounterCartButton extends StatefulWidget {
  final ProductCart product;
  final int stock;
  final Function(ProductCart) onIncrement;
  final Function(ProductCart) onDecrement;

  const CounterCartButton({
    required this.product,
    required this.stock,
    required this.onIncrement,
    required this.onDecrement,
    super.key,
  });

  @override
  _CounterCartButtonState createState() => _CounterCartButtonState();
}

class _CounterCartButtonState extends State<CounterCartButton> {
  late TextEditingController _controller;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.product.qty.toString());
    _quantity = widget.product.qty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (_quantity > 0) {
                setState(() {
                  _quantity--;
                  _controller.text = _quantity.toString();
                });
                widget.onDecrement(widget.product.copyWith(qty: _quantity));
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.remove),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (value) {
                if (int.parse(value) > widget.stock) {
                  _controller.text = widget.stock.toString();
                  _quantity = widget.stock;
                } else {
                  _quantity = int.parse(value);
                }
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                border: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (_quantity < widget.stock) {
                setState(() {
                  _quantity++;
                  _controller.text = _quantity.toString();
                });
                widget.onIncrement(widget.product.copyWith(qty: _quantity));
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
