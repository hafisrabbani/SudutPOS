import 'package:flutter/material.dart';
import 'package:sudut_pos/model/product_cart.dart';

class CartProvider extends ChangeNotifier {
  final List<ProductCart> _carts = [];

  List<ProductCart> get carts => _carts;

  void addToCart(ProductCart productCart) {
    final index = _carts.indexWhere((cart) => cart.id == productCart.id);
    if (index == -1) {
      _carts.add(productCart);
    } else {
      _carts[index].qty += 1;
    }
    notifyListeners();
  }

  void decrementQuantity(int productId) {
    final index = _carts.indexWhere((cart) => cart.id == productId);
    if (_carts[index].qty > 1) {
      _carts[index].qty -= 1;
    } else {
      removeFromCart(productId);
    }

  }


  void removeFromCart(int productId) {
    _carts.removeWhere((cart) => cart.id == productId);
    notifyListeners();
  }
}
