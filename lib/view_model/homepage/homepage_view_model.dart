import 'package:sudut_pos/model/transaction.dart';
import 'package:sudut_pos/database/query/transaction_query.dart';
import 'package:sudut_pos/type/timeType.dart';

class HomePageViewModel{
  final Transaction _transaction = Transaction();
  Future<List<TransactionRecord>> getAllTransaction() async {
    final queryResult = await _transaction.selectAll();
    return List.generate(queryResult.length, (index) {
      return TransactionRecord.fromMap(queryResult[index]);
    });
  }

  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final Map<String, dynamic> statistics = await _transaction.statisticsTransaction(filterTimeType.WEEKLY);
      return statistics;
    } catch (e) {
      print('Error getting statistics: $e');
      return {
        'total': 0,
        'count': 0,
      };
    }
  }

}