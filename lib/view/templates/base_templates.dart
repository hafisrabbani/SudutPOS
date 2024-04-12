import 'package:flutter/material.dart';
import 'package:sudut_pos/view/themes/colors.dart';
import 'package:sudut_pos/view_model/template/bottom_nav.dart';

class BaseTemplate extends StatefulWidget {
  const BaseTemplate({super.key});

  @override
  State<BaseTemplate> createState() => _BaseTemplateState();
}

class _BaseTemplateState extends State<BaseTemplate> {
  int _selectedIndex = 0;
  final BottomNavViewModel _bottomNavViewModel = BottomNavViewModel();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudut POS',
            style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
        ),
        backgroundColor: white,
      ),
      body: _bottomNavViewModel.pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cashier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        iconSize: 30,
        selectedItemColor: primaryColor,
        unselectedItemColor: mutedColor,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
