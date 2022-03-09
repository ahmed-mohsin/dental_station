import 'package:flutter/material.dart';

///
/// ## `Description`
///
/// Creates the base product properties that all products should have
/// such that it can work with the application
///
class BaseProduct {
  BaseProduct({
    @required this.id,
    @required this.price,
    @required this.name,
    this.description,
    this.imageUrl,
    this.color,
    this.reviewCount,
  })  : assert(id != null),
        assert(name != null),
        assert(price != null);

  String id;
  String name, seller, description, price, reviewCount;
  bool liked = false;
  int quantity = 1, size = 32;
  Color color;
  List<String> imageUrl;

  void toggleLikedStatus() {
    liked = !liked;
  }

  // sets the size selected
  set setSize(int sizeValue) {
    size = sizeValue;
  }

  // sets the quantity
  set setQuantity(int value) {
    quantity = value;
  }

  // sets the color
  set setColor(Color value) {
    color = value;
  }

  BaseProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString() ?? id;
    name = json['name'] ?? name;
    price = json['price'] ?? price;
    seller = json['seller'] ?? seller;
    description = json['description'] ?? description;
    imageUrl = json['imageUrl'] ?? imageUrl;
    reviewCount = json['reviewCount'] ?? reviewCount;
    quantity = json['quantity'] as int ?? quantity;
    size = json['size'] as int ?? size;
    color = json['color'] as Color ?? color;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'seller': seller,
      'description': description,
      'imageUrl': imageUrl,
      'reviewCount': reviewCount,
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }
}
