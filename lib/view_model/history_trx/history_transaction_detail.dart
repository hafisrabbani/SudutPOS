import 'package:sudut_pos/database/query/transaction_query.dart';
import 'package:sudut_pos/model/transaction_detail.dart';
import 'package:sudut_pos/database/query/product_query.dart';

class HistoryTransactionDetailViewModel {
  final Transaction _transactionQuery = Transaction();
  final ProductQuery _productQuery = ProductQuery();

  Future<Map<String, dynamic>> getTransactionDetails(int transactionId) async {
    final Map<String, dynamic> result = {};
    Map<String, dynamic> transactionItems = {};

    Map<String, dynamic> transaction =
        await _transactionQuery.selectById(transactionId);
    final List<TransactionDetail> transactionDetails =
        await _transactionQuery.getTransactionDetails(transactionId);
    result['transaction'] = transaction;
    for (TransactionDetail detail in transactionDetails) {
      final Map<String, dynamic> product =
          await _productQuery.selectById(detail.productId);
      transactionItems = {
        'id': detail.id,
        'productId': detail.productId,
        'productName': product['name'],
        'quantity': detail.quantity,
        'price': detail.price,
      };

      result['details'] = transactionItems;
    }

    return result;
  }
}
