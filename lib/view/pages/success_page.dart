import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sudut_pos/utility/common.dart';
import 'package:sudut_pos/view/themes/colors.dart';
import 'package:sudut_pos/view/widgets/custom_button.dart';
import 'package:sudut_pos/view/widgets/info_row.dart';
import 'package:sudut_pos/view_model/history_trx/history_transaction_detail.dart';
import 'package:sudut_pos/view/pages/home.dart';
import 'package:sudut_pos/view_model/setting/thermal_print_view_model.dart';

class SuccessPage extends StatefulWidget {
  final int transactionId;

  const SuccessPage({
    super.key,
    required this.transactionId,
  });

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  final HistoryTransactionDetailViewModel _viewModel =
  HistoryTransactionDetailViewModel();
  final SettingThermalPrint _settingThermalPrint = SettingThermalPrint();
  Map<String, dynamic> transaction = {};
  List<dynamic> detail = [];
  int transactionId = 0;
  int tableNumber = 0;
  String createdTime = '';
  String discType = '';
  String discValue = '';
  String discDisplay = '';
  double nominalPayment = 0.0;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadDataTransactionDetails(widget.transactionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
              _buildTransactionSummary(),
              const Text(
                'Transaction Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTransactionDetails(),
              const SizedBox(height: 32),
              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () =>
                            _printReceipt(context),
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
              const SizedBox(height: 16),
              CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                label: 'Back to Home',
                btnColor: textColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _printReceipt(BuildContext context) {
    _settingThermalPrint.checkConnection().then((value) {
      if (value!) {
        _settingThermalPrint.printReceipt(transaction);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to connect to printer'),
          ),
        );
      }
    });
  }

  Widget _buildTransactionSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRow(
          title: 'Transaction ID',
          value: transactionId.toString(),
        ),
        InfoRow(
          title: 'Table Number',
          value: tableNumber.toString(),
        ),
        InfoRow(
          title: 'Transaction Time',
          value: createdTime,
        ),
        const SizedBox(height: 16), // Tambahkan jarak antar kelompok informasi
        InfoRow(
          title: 'Payment Details',
          value: '', // Kosongkan nilai karena ini hanya judul
        ),
        InfoRow(
          title: 'Nominal Payment',
          value: CommonUtils().cvIDRCurrency(nominalPayment),
        ),
        InfoRow(
          title: 'Total',
          value: CommonUtils().cvIDRCurrency(total),
        ),
        const SizedBox(height: 16),
        InfoRow(
          title: 'Discount',
          value: discDisplay,
        ),
        const SizedBox(height: 32),
      ],
    );
  }


  Widget _buildTransactionDetails() {
    return Column(
      children: [
        Table(
          border: TableBorder.all(color: Colors.black),
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    color: primaryColor,
                    padding: EdgeInsets.all(8.0),
                    child: const Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold,color: white),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    color: primaryColor,
                    padding: EdgeInsets.all(8.0),
                    child: const Text(
                      'Qty',
                      style: TextStyle(fontWeight: FontWeight.bold,color: white),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    color: primaryColor,
                    padding: EdgeInsets.all(8.0),
                    child: const Text(
                      'Price',
                      style: TextStyle(fontWeight: FontWeight.bold,color: white),
                    ),
                  ),
                ),
              ],
            ),
            for (final item in detail)
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['productName']),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['quantity'].toString()),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(CommonUtils().cvIDRCurrency(item['price'])),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }



  void _loadDataTransactionDetails(int argsId) async {
    final dynamic transactionDetails =
    await _viewModel.getTransactionDetails(argsId);
    transaction = transactionDetails;
    if (transactionDetails is Map<String, dynamic>) {
      setState(() {
        transactionId = transactionDetails['transaction']['id'];
        tableNumber = transactionDetails['transaction']['tableNumber'];
        createdTime = DateFormat('dd MMM yyyy HH:mm:ss').format(
            DateTime.parse(transactionDetails['transaction']['createdTime']));
        nominalPayment = transactionDetails['transaction']['nominalPayment'];
        total = transactionDetails['transaction']['total'];
        discType = CommonUtils().convertToDiscType(
            transactionDetails['transaction']['discType']);
        discValue = transactionDetails['transaction']['discValue'].toString();
        discDisplay = CommonUtils().buildDiscountText(
            transactionDetails['transaction']['discType'],
            transactionDetails['transaction']['discValue']);
        detail = transactionDetails['details'];
      });
      print('Transaction ' + transaction.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load transaction details'),
        ),
      );
    }
  }


}
