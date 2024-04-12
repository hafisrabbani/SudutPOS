import 'package:flutter/material.dart';
import 'package:sudut_pos/model/product_cart.dart';

class CartProvider extends ChangeNotifier {
  final List<ProductCart> _carts = [];

  List<ProductCart> get carts => _carts;

  void addToCart(ProductCart productCart) {
    _carts.add(productCart);
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _carts.removeWhere((cart) => cart.id == productId);
    notifyListeners();
  }
}
