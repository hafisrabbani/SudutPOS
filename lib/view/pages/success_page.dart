import 'package:flutter/material.dart';
import 'package:sudut_pos/utility/common.dart';
import 'package:sudut_pos/view/themes/colors.dart';
import 'package:sudut_pos/view/widgets/custom_button.dart';
import 'package:sudut_pos/view/widgets/info_row.dart';
import 'package:sudut_pos/view_model/history_trx/history_transaction_detail.dart';

class SuccessPage extends StatefulWidget {
  final double subtotal;
  final double grandTotal;
  final double change;
  final int transactionId;

  const SuccessPage({
    Key? key,
    required this.subtotal,
    required this.grandTotal,
    required this.change,
    required this.transactionId,
  }) : super(key: key);

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  final HistoryTransactionDetailViewModel _viewModel = HistoryTransactionDetailViewModel();
  Map<String, dynamic> transaction = {};
  Map<String, dynamic> detail = {};
  @override
  void initState() {
    super.initState();
    _loadDataTransactionDetails(widget.transactionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Success'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/img/success_logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            const Text(
              'Transaction Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Transaction Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTransactionDetails(),
            const SizedBox(height: 16),
            InfoRow(
                title: 'Subtotal',
                value: CommonUtils().cvIDRCurrency(widget.subtotal)),
            InfoRow(
                title: 'Grand Total',
                value: CommonUtils().cvIDRCurrency(widget.grandTotal)),
            InfoRow(
                title: 'Change',
                value: CommonUtils().cvIDRCurrency(widget.change)),
            const SizedBox(height: 32),
            Center(
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () => _printReceipt(context),
                      label: 'Print Receipt',
                      btnColor: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: 'Print For Staff',
                      btnColor: warningColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _printReceipt(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt printed successfully!'),
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Column(
      children: [
        InfoRow(
          title: 'Transaction ID',
          value: transaction['id'].toString(),
        ),
        InfoRow(
          title: 'Table Number',
          value: transaction['tableNumber'].toString(),
        ),
        InfoRow(
          title: 'Created Time',
          value: transaction['createdTime'],
        ),
        const SizedBox(height: 16),
        const Text(
          'Transaction Items',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          itemCount: detail.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(detail[index]['productName']),
              subtitle: Text(
                  '${detail[index]['quantity']} x ${CommonUtils().cvIDRCurrency(detail[index]['price'])}'),
            );
          },
        ),
      ],
    );
  }

  void _loadDataTransactionDetails(int transactionId) async {
    final Map<String, dynamic> transactionDetails =
    await _viewModel.getTransactionDetails(transactionId);
    setState(() {
      transaction = transactionDetails['transaction'];
      detail = transactionDetails['details'];
    });
  }
}
