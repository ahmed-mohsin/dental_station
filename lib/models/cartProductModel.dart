// Copyright (c) 2020 Aniket Malik [aniketmalikwork@gmail.com]
// All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the
// property of Aniket Malik. The intellectual and technical concepts
// contained herein are proprietary to Aniket Malik and are protected
// by trade secret or copyright law.
//
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained from
// Aniket Malik.

import 'package:flutter/foundation.dart';

import '../services/woocommerce/woocommerce.service.dart';
import 'productModel.dart';

class CartProduct {
  CartProduct({
    @required this.id,
    @required this.product,
    this.productId,
    this.variationId,
    this.price,
    this.name,
    this.quantity = 1,
    this.isVariable,
    this.displayImage,
    this.attributes,
  }) : assert(id != null);

  /// If variation id is greater than 0, it means that this is a
  /// variable product and the variation must be the main product
  /// hence the unique [id] should be the variation id. If variation id
  /// is less than or equal to 0 then the product is simple and
  /// only the product id must be the unique [id] of this data class
  String id;

  /// The associated product
  String productId;

  /// The associated product variation
  String variationId;

  String name, price, displayImage;
  int quantity = 1;
  Product product;

  /// The selected attributes of the product
  Map attributes;

  bool isVariable;

  // sets the size selected
  // set setSize(String sizeValue) {
  //   size = sizeValue;
  // }

  // sets the quantity
  set setQuantity(int value) {
    if (value <= 0) {
      quantity = 1;
      return;
    }
    quantity = value;
  }

  // sets the color
  // set setColor(Color value) {
  //   color = value;
  // }

  /// Increase the quantity of the product by 1
  bool increaseQuantity() {
    if (product == null || product.wooProduct.soldIndividually) {
      return false;
    }
    quantity++;
    return true;
  }

  /// Decrease the quantity of the product by 1
  bool decreaseQuantity() {
    if (quantity == 1) {
      return false;
    }
    quantity--;
    return true;
  }

  factory CartProduct.fromProduct(Product p) {
    String id = p.id.toString();

    // Here check if the product is simple or variable product
    final bool isVariableProduct = p.selectedVariation != null || false;

    // if the product is variable then change the cartProduct id to
    // the variation id
    if (isVariableProduct) {
      if (p.selectedVariation.id != null &&
          p.selectedVariation.id.toString().isNotEmpty) {
        id = p.selectedVariation.id.toString();
      }
    }

    String _price = p.wooProduct.price;

    if (p.productSelectedData.price != null &&
        p.productSelectedData.price.isNotEmpty) {
      _price = p.productSelectedData.price;
    }
    final _attr = Map.from(p.selectedAttributesNotifier.value);
    final product = CartProduct(
      id: id,
      productId: p.id.toString(),
      variationId: p.selectedVariation != null
          ? p.selectedVariation.id.toString()
          : null,
      isVariable: isVariableProduct,
      product: p,
      name: p.wooProduct.name,
      price: _price,
      displayImage: p.productSelectedData.image,
      quantity: p.quantity,
      attributes: _attr,
    );

    return product;
  }

  /// Used only to update product image in the cart item.
  void updateWith({WooProductVariation newVariation, Product newProduct}) {
    String _displayImage;

    // Updates the product and display image with the newProduct
    if (newProduct != null) {
      product = newProduct;
      if (newProduct.displayImage != null) {
        _displayImage = newProduct.displayImage;
      }
    }

    // Updates the variation in product and display image with variation
    // if not already present
    if (newVariation != null) {
      // Update the variation in the product if not already present
      if (product != null) {
        product.variations.add(newVariation);
      }
      if (newVariation.image != null &&
          newVariation.image.src != null &&
          newVariation.image.src.isNotEmpty) {
        _displayImage = newVariation.image.src;
      }
    }

    displayImage = _displayImage;
  }

  /// Create a CartProduct from CoCart item to show in application
  /// after get cart data request.
  CartProduct.fromCoCartProductItem(CoCartProductItem p, {Product ref}) {
    id = p.id.toString();
    productId = p.productId.toString();
    variationId = p.variationId.toString();
    isVariable = p.isVariable;
    product = ref;
    name = p.name;
    price = p.price;
    displayImage = ref != null ? ref.displayImage : displayImage;
    quantity = p.quantity;
    attributes = p.variationData;
  }

  /// Copies the updated data from CoCartProductItem to the
  /// instance
  CartProduct updateWithCoCartProductItem(CoCartProductItem newItem) {
    final newCp = CartProduct(
      id: newItem.id.toString(),
      productId: newItem.productId.toString(),
      variationId: newItem.variationId != null
          ? newItem.variationId.toString()
          : variationId,
      product: product,
      name: newItem.name,
      isVariable: newItem.isVariable,
      price: newItem.price,
      displayImage: displayImage,
      quantity: newItem.quantity,
      attributes: newItem.variationData,
    );

    print('Copied from CIP');
    print(product);

    return newCp;
  }

  @override
  String toString() {
    return 'CartProduct{id: $id, productId: $productId, variationId: $variationId, price: $price, attributes: $attributes}';
  }
}
