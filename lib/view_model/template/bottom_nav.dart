import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudut_pos/view/pages/cashier.dart';
import 'package:sudut_pos/view/pages/home.dart';
import 'package:sudut_pos/view/pages/inventory.dart';
import 'package:sudut_pos/view/pages/setting.dart';

//TODO: Change list of pages to your own pages

class BottomNavViewModel{
  final List<Widget> pages = [
    HomePage(),
    const CashierPage(),
    const InventoryPage(),
    SettingPage(),
  ];
}
