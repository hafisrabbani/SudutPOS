import 'package:flutter/material.dart';

class ProductCart {
  final int id;
  final String name;
  final double price;
  final String createdTime;
  final String updatedTime;
  final int stock;
  int qty;

  ProductCart({
    required this.id,
    required this.name,
    required this.price,
    required this.createdTime,
    required this.updatedTime,
    required this.stock,
    required this.qty,
  });

  ProductCart copyWith({
    int? id,
    String? name,
    double? price,
    String? createdTime,
    String? updatedTime,
    int? stock,
    int? qty,
  }) {
    return ProductCart(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      createdTime: createdTime ?? this.createdTime,
      updatedTime: updatedTime ?? this.updatedTime,
      stock: stock ?? this.stock,
      qty: qty ?? this.qty,
    );
  }
}
