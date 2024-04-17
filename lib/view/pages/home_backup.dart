import 'package:flutter/material.dart';
import 'package:sudut_pos/type/timeType.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sudut_pos/view/themes/colors.dart';
import 'package:sudut_pos/database/query/transaction_query.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Transaction _transaction = Transaction();
  late Future<Map<String, dynamic>> _statisticsFuture;

  @override
  void initState() {
    super.initState();
    _statisticsFuture = _transaction.statisticsTransaction(filterTimeType.WEEKLY);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _statisticsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final total = snapshot.data!['total'] ?? 0;
            final count = snapshot.data!['count'] ?? 0;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildChart(total, count),
                SizedBox(height: 20),
                _buildTransactionCard(total, count),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildChart(double total, int count) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: total,
          minY: 0,
          groupsSpace: 12,
          barTouchData: BarTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: total, color: primaryColor),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: total, color: primaryColor),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: total, color: primaryColor),
            ]),
            BarChartGroupData(x: 3, barRods: [
              BarChartRodData(toY: total, color: primaryColor),
            ]),
            BarChartGroupData(x: 4, barRods: [
              BarChartRodData(toY: total, color: primaryColor),
            ]),
            BarChartGroupData(x: 5, barRods: [
              BarChartRodData(toY: total, color: primaryColor),
            ]),
            BarChartGroupData(x: 6, barRods: [
              BarChartRodData(toY: total, color: primaryColor),
            ]),
          ],
        ),
      ),
    );
  }


  Widget _buildTransactionCard(double total, int count) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Divider(),
            SizedBox(height: 10),
            Text('Total Transactions: $count', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Total Amount: $total', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
