import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudut_pos/model/product_cart.dart';
import 'package:sudut_pos/view/themes/colors.dart';
import 'package:sudut_pos/view/widgets/alert.dart';
import 'package:sudut_pos/view/widgets/search_bar.dart';
import 'package:sudut_pos/model/product.dart';
import 'package:sudut_pos/view/widgets/card_product.dart';
import 'package:sudut_pos/view/widgets/shopping_cart.dart';
import 'package:sudut_pos/view/widgets/single_cart_button.dart';
import 'package:sudut_pos/view/widgets/counter_cart_button.dart';
import 'package:sudut_pos/provider/cart_provider.dart';
import 'package:sudut_pos/view_model/cashier/cashier_view_model.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final CashierViewModel _cashierViewModel = CashierViewModel();
  final TextEditingController _searchController = TextEditingController();

  late CartProvider _cartProvider;

  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts({String? query}) async {
    List<Product> loadedProducts =
        await _cashierViewModel.fetchProducts(query: query);
    setState(() {
      products = loadedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    _cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                      controller: _searchController,
                      hintText: 'Search...',
                      onChanged: (value) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          _loadProducts(query: value);
                        });
                      },
                      onClear: () {
                        _searchController.clear();
                        _loadProducts(query: null);
                      },
                      child: ShoppingCartButton(
                          itemCount: _cartProvider.carts.length,
                          onPressed: () {
                            if (_cartProvider.carts.isEmpty) {
                              CustomAlert.show(
                                context,
                                'Empty Cart',
                                'Please add some products to the cart.',
                              );
                            } else {
                              Navigator.pushNamed(context, '/checkout',
                                  arguments: _cartProvider.carts);
                            }
                          })),
                ),
              ],
            ),
          ),
          Expanded(child: _buildProductGrid()),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products available',
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 2
                  : 3,
          childAspectRatio:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 0.8
                  : 1.5,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final isInCart =
              _cartProvider.carts.any((cart) => cart.id == product.id);

          return Padding(
            padding: const EdgeInsets.all(8),
            child: ProductCard(
              product: product,
              child: isInCart
                  ? CounterCartButton(
                      product: _cartProvider.carts
                          .firstWhere((cart) => cart.id == product.id),
                      stock: product.stock,
                      onIncrement: (cart) {
                        _onIncrement(cart);
                      },
                      onDecrement: (cart) {
                        _onDecrement(cart);
                      },
                    )
                  : SingleCartButton(
                      product: ProductCart(
                        id: product.id ?? 0,
                        name: product.name,
                        price: product.price,
                        createdTime: product.createdTime,
                        updatedTime: product.updatedTime,
                        stock: product.stock,
                        qty: 0,
                      ),
                      onPressed: (productCart) {
                        if (productCart.stock > 0) {
                          _addToCart(productCart);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Out of stock'),
                                duration: Duration(seconds: 1)),
                          );
                        }
                      },
                    ),
            ),
          );
        },
      );
    }
  }

  void _addToCart(ProductCart productCart) {
    final int availableStock =
        productCart.stock - _getProductQtyInCart(productCart.id);
    if (availableStock > 0) {
      _cartProvider.addToCart(productCart.copyWith(qty: 1));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          CustomAlert.show(
            context,
            'Out of Stock',
            'The selected product is out of stock.',
          );
          return const SizedBox();
        },
      );
    }
  }

  void _onIncrement(ProductCart productCart) {
    final int availableStock =
        productCart.stock - _getProductQtyInCart(productCart.id);
    if (availableStock > 0) {
      _cartProvider.addToCart(productCart.copyWith(qty: productCart.qty + 1));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          CustomAlert.show(
            context,
            'Out of Stock',
            'The selected product is out of stock.',
          );
          return const SizedBox();
        },
      );
    }
  }

  void _onDecrement(ProductCart productCart) {
    if (productCart.qty > 0) {
      _cartProvider.decrementQuantity(productCart.id);
    } else {
      _cartProvider.removeFromCart(productCart.id);
    }
  }

  int _getProductQtyInCart(int productId) {
    int productQtyInCart = 0;
    for (var cart in _cartProvider.carts) {
      if (cart.id == productId) {
        productQtyInCart += cart.qty;
      }
    }
    return productQtyInCart;
  }
}
