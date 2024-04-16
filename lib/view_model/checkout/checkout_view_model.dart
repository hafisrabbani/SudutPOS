import 'package:sudut_pos/provider/cart_provider.dart';
import 'package:sudut_pos/database/query/transaction_query.dart';
import 'package:sudut_pos/model/transaction_detail.dart';
import 'package:sudut_pos/model/transaction.dart';

class CheckOutViewModel {
  final CartProvider _cartProvider = CartProvider();
  final Transaction _transaction = Transaction();

  double calculateTotal() {
    double total = 0;
    for (var cart in _cartProvider.carts) {
      total += cart.price * cart.qty;
    }
    return total;
  }

  Future<bool> processTransaction(TransactionRecord transactionRecord,List<TransactionDetail> transactionDetails) async {
    try {
      bool success = await _transaction.saveTransaction(transactionRecord, transactionDetails);
      return success ? true : false;
    } catch (e) {
      print('Error processing transaction: $e');
      return false;
    }
  }
}
