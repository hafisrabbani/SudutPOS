import 'package:flutter/material.dart';
import 'package:sudut_pos/view/themes/colors.dart';
import 'package:sudut_pos/view/widgets/bottom_sheet.dart';
import 'package:sudut_pos/view/widgets/card_product.dart';
import 'package:sudut_pos/model/product.dart';
import 'package:sudut_pos/view/widgets/search_bar.dart';
import 'package:sudut_pos/view/widgets/text_field.dart';
import 'package:sudut_pos/view_model/product/product_view_model.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final ProductViewModel _productViewModel = ProductViewModel();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts({String? query}) async {
    List<Product> loadedProducts =
        await _productViewModel.fetchProducts(query: query);
    setState(() {
      products = loadedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      onSearch: () {
                        _loadProducts(query: _searchController.text);
                      }),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildProductGrid(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductBottomSheet(context);
        },
        backgroundColor: primaryColor,
        tooltip: 'Add Product',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddProductBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (context) {
        return CustomBottomSheet(
          isDismissible: false,
          child: Padding(
            padding: const EdgeInsets.all(10).copyWith(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  labelText: 'Product Name',
                  controller: _productNameController,
                  prefixIcon: Icons.shopping_bag,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Price',
                  controller: _priceController,
                  prefixIcon: Icons.money,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Stock',
                  controller: _stockController,
                  prefixIcon: Icons.shopping_cart,
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    _addProduct(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addProduct(BuildContext context) {
    Product product = Product(
      name: _productNameController.text,
      price: double.parse(_priceController.text),
      stock: int.parse(_stockController.text),
      createdTime: DateTime.now().toString(),
      updatedTime: DateTime.now().toString(),
    );
    _productViewModel.insertProduct(product).then((value) {
      if (value) {
        _loadProducts();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add product'),
          ),
        );
      }
    });
  }

  void _showDeleteConfirmation(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteProduct(context, product);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(BuildContext context, Product product) {
    final productId = product.id;
    if (productId != null) {
      _productViewModel.deleteProduct(productId).then((value) {
        if (value) {
          _loadProducts();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Success to add product')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete product'),
            ),
          );
        }
      });
    }
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
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ProductCard(
              product: products[index],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        _showEditProductBottomSheet(context, products[index]);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: dangerColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        _showDeleteConfirmation(context, products[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _showEditProductBottomSheet(BuildContext context, Product product) {
    _productNameController.text = product.name;
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (context) {
        return CustomBottomSheet(
          isDismissible: false,
          child: Padding(
            padding: const EdgeInsets.all(10).copyWith(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  labelText: 'Product Name',
                  controller: _productNameController,
                  prefixIcon: Icons.shopping_bag,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Price',
                  controller: _priceController,
                  prefixIcon: Icons.money,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Stock',
                  controller: _stockController,
                  prefixIcon: Icons.shopping_cart,
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    _editProduct(context, product);
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editProduct(BuildContext context, Product product) {
    Product updatedProduct = Product(
      id: product.id,
      name: _productNameController.text,
      price: double.parse(_priceController.text),
      stock: int.parse(_stockController.text),
      createdTime: product.createdTime,
      updatedTime: DateTime.now().toString(),
    );

    _productViewModel.updateProduct(updatedProduct).then((value) {
      if (value) {
        _loadProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Success to update product')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update product'),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
