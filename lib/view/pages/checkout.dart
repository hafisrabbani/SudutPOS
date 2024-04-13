import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudut_pos/model/product_cart.dart';
import 'package:sudut_pos/provider/cart_provider.dart';

enum DiscType { percent, value }

class CheckoutPage extends StatefulWidget {
  // final List<TransactionDetail> transactionDetails;
  final List<ProductCart> carts;

  const CheckoutPage({
    super.key,
    required this.carts,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late TextEditingController _customerNameController;
  late TextEditingController _nominalPaymentController;
  late TextEditingController _tableNumberController;
  late TextEditingController _changeController;
  late TextEditingController _cashierController;
  late TextEditingController _discountController;
  late DiscType _selectedDiscType = DiscType.percent;
  late CartProvider _cartProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartProvider = Provider.of<CartProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    print(widget.carts);
    _customerNameController = TextEditingController();
    _nominalPaymentController = TextEditingController();
    _tableNumberController = TextEditingController();
    _changeController = TextEditingController();
    _cashierController = TextEditingController();
    _discountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Transaction Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _cartProvider.carts.length,
              itemBuilder: (context, index) {
                final cart = _cartProvider.carts[index];
                return ListTile(
                  title: Text(cart.name),
                  subtitle: Text('Price: ${cart.price}, Quantity: ${cart.qty}'),
                );
              },
            )
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Transaction Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _customerNameController,
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                ),
                TextFormField(
                  controller: _nominalPaymentController,
                  decoration: const InputDecoration(labelText: 'Nominal Payment'),
                ),
                TextFormField(
                  controller: _tableNumberController,
                  decoration: const InputDecoration(labelText: 'Table Number'),
                ),
                TextFormField(
                  controller: _changeController,
                  decoration: const InputDecoration(labelText: 'Change'),
                ),
                TextFormField(
                  controller: _cashierController,
                  decoration: const InputDecoration(labelText: 'Cashier'),
                ),
                TextFormField(
                  controller: _discountController,
                  decoration: const InputDecoration(labelText: 'Discount'),
                ),
                DropdownButtonFormField<DiscType>(
                  value: _selectedDiscType,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDiscType = newValue!;
                    });
                  },
                  items: DiscType.values.map((discType) {
                    return DropdownMenuItem<DiscType>(
                      value: discType,
                      child: Text(discType.toString().split('.').last),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Discount Type'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _nominalPaymentController.dispose();
    _tableNumberController.dispose();
    _changeController.dispose();
    _cashierController.dispose();
    _discountController.dispose();
    super.dispose();
  }
}
