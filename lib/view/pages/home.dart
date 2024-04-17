import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sudut_pos/model/transaction.dart';
import 'package:sudut_pos/view/pages/success_page.dart';
import 'package:sudut_pos/view_model/homepage/homepage_view_model.dart';
import 'package:sudut_pos/view/themes/colors.dart';
import 'package:sudut_pos/utility/common.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageViewModel _homePageViewModel = HomePageViewModel();
  late Future<List<TransactionRecord>> _transactionFuture;
  Map<String, dynamic> _statistics = {};
  @override
  void initState() {
    super.initState();
    _transactionFuture = _homePageViewModel.getAllTransaction();
    _loadStatistics();
    print(_transactionFuture);
  }

  void _loadStatistics() async {
    final statistics = await _homePageViewModel.getStatistics();
    print(statistics);
    setState(() {
      _statistics = statistics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: _buildCard(),
              ),
          ),
          const SizedBox(height: 32),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'History Transaction',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          FutureBuilder<List<TransactionRecord>>(
            future: _transactionFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final transactions = snapshot.data!;
                return Column(
                  children: transactions
                      .map((transaction) => _buildTransactionCard(transaction))
                      .toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(){
    return Card(
      color: primaryColor,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 24,
                color: white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      'Total Transaction',
                      style: TextStyle(
                        fontSize: 14,
                        color: white,
                      ),
                    ),
                    Text(
                      _statistics.containsKey('count')
                          ? _statistics['count'].toString()
                          : '0',
                      style: const TextStyle(
                        fontSize: 24,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Total Revenue',
                      style: TextStyle(
                        fontSize: 14,
                        color: white,
                      ),
                    ),
                    Text(
                      _statistics.containsKey('total')
                          ? CommonUtils().cvIDRCurrency(
                          _statistics['total'] as double)
                          : '0',
                      style: const TextStyle(
                        fontSize: 20,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(TransactionRecord transaction) {
    int? idTransaction = transaction.id;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SuccessPage(transactionId: idTransaction ?? 0); 
        }));
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(children: [
          Icon(Icons.monetization_on_outlined, color: primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trx ID: ${transaction.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MMM/yyyy HH:mm').format(
                          DateTime.parse(transaction.createdTime)),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Table ${transaction.tableNumber}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      CommonUtils().cvIDRCurrency(transaction.total),
                      style: const TextStyle(
                        fontSize: 14,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
