import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudut_pos/view/pages/inventory.dart';

//TODO: Change list of pages to your own pages

class BottomNavViewModel{
  final List<Widget> pages = [
    const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('Business'),
      ),
    ),
    const InventoryPage(),
    const Scaffold(
      body: Center(
        child: Text('Setting'),
      ),
    ),
  ];
}