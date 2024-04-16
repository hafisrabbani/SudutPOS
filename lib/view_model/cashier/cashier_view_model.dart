import 'package:sudut_pos/model/product.dart';
import 'package:sudut_pos/view_model/product/product_view_model.dart';

class CashierViewModel {
  final ProductViewModel _productViewModel = ProductViewModel();

  Future<List<Product>> fetchProducts({String? query}) async {
    return _productViewModel.fetchProducts(query: query);
  }
}
