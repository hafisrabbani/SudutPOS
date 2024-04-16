import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sudut_pos/model/product_cart.dart';
import 'package:sudut_pos/provider/cart_provider.dart';
import 'package:sudut_pos/utility/common.dart';
import 'package:sudut_pos/view/pages/success_page.dart';
import 'package:sudut_pos/view/themes/colors.dart';
import 'package:sudut_pos/view/widgets/custom_button.dart';
import 'package:sudut_pos/view/widgets/info_row.dart';
import 'package:sudut_pos/view/widgets/text_field.dart';
import 'package:sudut_pos/view_model/checkout/checkout_view_model.dart';
import 'package:sudut_pos/model/transaction.dart';
import 'package:sudut_pos/model/transaction_detail.dart';

class CheckoutPage extends StatefulWidget {
  final List<ProductCart> carts;

  const CheckoutPage({
    super.key,
    required this.carts,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late TextEditingController _nominalPaymentController;
  late TextEditingController _tableNumberController;
  late TextEditingController _discountController;
  late int _selectedDiscType = 0;
  late CartProvider _cartProvider;
  bool _showDiscountFields = false;
  final CheckOutViewModel _checkOutViewModel = CheckOutViewModel();
  int trxId = CommonUtils().generateTransactionId();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartProvider = Provider.of<CartProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    _nominalPaymentController = TextEditingController();
    _tableNumberController = TextEditingController();
    _discountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Transaction Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                        },
                        children: [
                          const TableRow(
                            children: [
                              Text('Product Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: white)),
                              Text('Price',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: white)),
                              Text('Qty',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: white)),
                            ],
                          ),
                          const TableRow(
                              children: [SizedBox(), SizedBox(), SizedBox()]),
                          ..._cartProvider.carts.map((cart) {
                            return TableRow(
                              children: [
                                Text(cart.name,
                                    style: const TextStyle(
                                        color: white, fontSize: 16)),
                                Text(cart.price.toString(),
                                    style: const TextStyle(
                                        color: white, fontSize: 16)),
                                Text(cart.qty.toString(),
                                    style: const TextStyle(
                                        color: white, fontSize: 16)),
                              ],
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: white,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Transaction Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _buildTextField(
                              'Nominal Payment', _nominalPaymentController),
                          _buildTextField(
                              'Table Number', _tableNumberController),
                          _buildDiscountButton(),
                          if (_showDiscountFields) ...[
                            _buildDiscountTypeRadio(),
                            _buildTextField('Discount', _discountController),
                          ],
                          const Divider(),
                          _totalSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
                child: CustomButton(
              onPressed: () {
                _actionSaveTrx();
              },
              label: 'Checkout',
              btnColor: primaryColor,
            )),
            const SizedBox(height: 16),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String title, TextEditingController controller,
      {bool readOnly = false}) {
    return CustomTextField(
      labelText: title,
      controller: controller,
      readOnly: readOnly,
      keyboardType: TextInputType.number,
    );
  }

  Widget _validateForm() {
    if (calculateChange() < 0) {
      return const Text('Nominal payment must be greater than grand total');
    } else if (_tableNumberController.text.isEmpty) {
      return const Text('Table number must be filled');
    } else {
      return const SizedBox();
    }
  }

  Future<bool> _saveTrx() {

    final result = _checkOutViewModel.processTransaction(
      TransactionRecord(
          id: trxId,
          nominalPayment: double.tryParse(_nominalPaymentController.text) ?? 0,
          total: calculateGrandTotal(),
          tableNumber: int.tryParse(_tableNumberController.text) ?? 0,
          change: calculateChange(),
          discType: _selectedDiscType,
          discValue: double.tryParse(_discountController.text) ?? 0,
          createdTime: DateTime.now().toString()),
      _cartProvider.carts.map((cart) {
        return TransactionDetail(
          transactionId: trxId,
          productId: cart.id,
          quantity: cart.qty,
          price: cart.price,
        );
      }).toList(),
    );

    return result;
  }

  Widget _buildDiscountButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          setState(() {
            _showDiscountFields = !_showDiscountFields;
          });
        },
        child: Text(_showDiscountFields ? 'Hide Discount' : 'Add Discount',
            style: const TextStyle(color: white)),
      ),
    );
  }

  Widget _buildDiscountTypeRadio() {
    return ListTile(
      title: const Text('Discount Type'),
      subtitle: Row(
        children: [
          Radio<int>(
            value: 0,
            groupValue: _selectedDiscType,
            onChanged: (value) {
              setState(() {
                _selectedDiscType = value!;
              });
            },
          ),
          const Text('Percent'),
          Radio<int>(
            value: 1,
            groupValue: _selectedDiscType,
            onChanged: (value) {
              setState(() {
                _selectedDiscType = value!;
              });
            },
          ),
          const Text('Specific Value'),
        ],
      ),
    );
  }

  Widget _buildDiscount() {
    String discount;
    if (_selectedDiscType == 0) {
      discount = '${_discountController.text}%';
    } else {
      discount = CommonUtils()
          .cvIDRCurrency(double.tryParse(_discountController.text) ?? 0);
    }
    return InfoRow(title: 'Discount', value: discount);
  }

  Widget _totalSection() {
    return Column(
      children: [
        InfoRow(
            title: 'Subtotal',
            value: CommonUtils().cvIDRCurrency(calculateSubTotal())),
        if (_showDiscountFields) _buildDiscount(),
        const Divider(),
        InfoRow(
            title: 'Grand Total',
            value: CommonUtils().cvIDRCurrency(calculateGrandTotal())),
        InfoRow(
            title: 'Change',
            value: CommonUtils().cvIDRCurrency(calculateChange())),
      ],
    );
  }

  double calculateSubTotal() {
    double total = 0;
    for (var cart in _cartProvider.carts) {
      total += cart.price * cart.qty;
    }
    return total;
  }

  double calculateChange() {
    double total = double.tryParse(_nominalPaymentController.text) ?? 0;
    return total - calculateGrandTotal();
  }

  double calculateGrandTotal() {
    double total = calculateSubTotal();
    if (_selectedDiscType == 0) {
      total -= (total * (double.tryParse(_discountController.text) ?? 0) / 100);
    } else {
      total -= double.tryParse(_discountController.text) ?? 0;
    }
    return total;
  }

  void _actionSaveTrx() {
    Widget validationWidget = _validateForm();
    if (validationWidget is SizedBox) {
      _saveTrx().then((value) {
        if (value) {
          _cartProvider.clearCart();
          // redirect to success page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessPage(
                transactionId: trxId,
                  subtotal: 10000, grandTotal: 10000, change: 0),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to process transaction'),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: validationWidget,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nominalPaymentController.dispose();
    _tableNumberController.dispose();
    _discountController.dispose();
    super.dispose();
  }
}
