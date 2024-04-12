import 'package:sudut_pos/model/product.dart';
import 'package:sudut_pos/database/query/product_query.dart';
class ProductViewModel {
  final ProductQuery _productQuery = ProductQuery();

  Future<bool> insertProduct(Product product) async {
    final Map<String, dynamic> data = product.toMap();
    final int result = await _productQuery.insert(data);
    return result != 0;
  }

  Future<List<Product>> fetchProducts({String? query}) async {
    List<Map<String, dynamic>> result;
    if (query != null) {
      result = await _productQuery.selectWhere('name LIKE ?', ['%$query%']);
    } else {
      result = await _productQuery.selectAll();
    }
    return result.map((data) => Product.fromMap(data)).toList();
  }


  Future<Product> getProductById(int id) async {
    final Map<String, dynamic> result = await _productQuery.selectById(id);
    return Product.fromMap(result);
  }

  Future<bool> updateProduct(Product product) async {
    final Map<String, dynamic> data = product.toMap();
    final int result = await _productQuery.update(data, 'id = ?', [product.id]);
    return result != 0;
  }

  Future<bool> deleteProduct(int id) async {
    final int result = await _productQuery.delete(id);
    return result != 0;
  }

}
