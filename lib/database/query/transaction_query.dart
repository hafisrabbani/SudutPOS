import 'package:sudut_pos/model/transaction.dart';
import 'package:sudut_pos/model/transaction_detail.dart';
import 'package:sudut_pos/database/main_database.dart';
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
}
