import 'package:sudut_pos/model/transaction.dart';
import 'package:sudut_pos/model/transaction_detail.dart';
import 'package:sudut_pos/database/main_database.dart';
import 'package:sudut_pos/type/timeType.dart';
import 'package:sudut_pos/utility/filter_time.dart';
import 'base_query.dart';

class Transaction extends BaseQuery {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  String get tableName => 'TransactionRecord';

  Future<bool> saveTransaction(TransactionRecord transactionRecord,
      List<TransactionDetail> transactionDetails) async {
    try {
      final db = await _databaseHelper.database;
      await db.transaction((txn) async {
        int transactionId =
            await txn.insert(tableName, transactionRecord.toMap());
        for (TransactionDetail detail in transactionDetails) {
          detail.transactionId = transactionId;
          await txn.insert('TransactionDetail', detail.toMap());

          final product = await txn
              .query('Product', where: 'id = ?', whereArgs: [detail.productId]);
          if (product.isNotEmpty) {
            final Map<String, dynamic> productData = product.first;
            final int stock = productData['stock'];
            await txn.update(
                'Product',
                {
                  'stock': stock - detail.quantity,
                },
                where: 'id = ?',
                whereArgs: [detail.productId]);
          }
        }
      });
      return true;
    } catch (e) {
      print('Error saving transaction: $e');
      return false;
    }
  }

  Future<List<TransactionDetail>> getTransactionDetails(
      int transactionId) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> detailMaps = await db.query(
        'TransactionDetail',
        where: 'transactionId = ?',
        whereArgs: [transactionId],
      );
      return List.generate(detailMaps.length, (index) {
        return TransactionDetail.fromMap(detailMaps[index]);
      });
    } catch (e) {
      print('Error getting transaction details: $e');
      return [];
    }
  }

  Future<double> sumTotalTransaction(DateTime? startDate, DateTime? endDate) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> totalMaps = await db.rawQuery(
        'SELECT SUM(total) as total FROM $tableName WHERE createdTime BETWEEN ? AND ?',
        [startDate!.toIso8601String(), endDate!.toIso8601String()],
      );
      return totalMaps.first['total'] ?? 0;
    } catch (e) {
      print('Error sum total transaction: $e');
      return 0;
    }
  }

  Future<List<TransactionRecord>> getTransactions(DateTime? startDate, DateTime? endDate) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> transactionMaps = await db.query(
        tableName,
        where: 'createdTime BETWEEN ? AND ?',
        whereArgs: [startDate!.toIso8601String(), endDate!.toIso8601String()],
      );
      return List.generate(transactionMaps.length, (index) {
        return TransactionRecord.fromMap(transactionMaps[index]);
      });
    } catch (e) {
      print('Error getting transactions: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> statisticsTransaction(filterTimeType filterTime) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> totalMaps = await db.rawQuery(
        'SELECT SUM(total) as total FROM $tableName WHERE createdTime BETWEEN ? AND ?',
        [FilterTimeUtils.getStartDate(filterTime).toIso8601String(), FilterTimeUtils.getEndDate(filterTime).toIso8601String()],
      );
      final List<Map<String, dynamic>> countMaps = await db.rawQuery(
        'SELECT COUNT(id) as count FROM $tableName WHERE createdTime BETWEEN ? AND ?',
        [FilterTimeUtils.getStartDate(filterTime).toIso8601String(), FilterTimeUtils.getEndDate(filterTime).toIso8601String()],
      );
      return {
        'total': totalMaps.first['total'] ?? 0,
        'count': countMaps.first['count'] ?? 0,
      };
    } catch (e) {
      print('Error statistics transaction: $e');
      return {
        'total': 0,
        'count': 0,
      };
    }

  }
}
