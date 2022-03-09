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

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:quiver/strings.dart';
import 'package:woocommerce/models/product_variation.dart';

import '../constants/colors.dart';
import '../developer/dev.log.dart';
import '../services/woocommerce/woocommerce.service.dart';
import '../utils/colors.utils.dart';

class Product {
  Product({
    @required this.id,
    @required this.wooProduct,
    this.liked,
  }) {
    // Set the image list
    try {
      _imagesNotifier.value =
          wooProduct?.images?.map((e) => e.src)?.toList() ?? [];

      if (_imagesNotifier.value.isNotEmpty) {
        _displayImage = _imagesNotifier.value[0];
      }
    } catch (_) {
      _imagesNotifier.value = [];
    }

    inStock = wooProduct.stockStatus == 'instock' || false;
    averageRating = wooProduct.averageRating;
    ratingCount.value = wooProduct.ratingCount;

    // Call to create a selected data instance just after creating the product
    // model
    setSelectedProductData(this);
    setDefaultAttributes(wooProduct.defaultAttributes);
  }

  /// The unique ID of this product
  final String id;

  /// The associated wooProduct with this instance
  final WooProduct wooProduct;

  String averageRating = '0.0';
  final ValueNotifier<int> ratingCount = ValueNotifier(0);

  /// Liked and inStock status for the product
  bool liked = false, inStock = true;

  /// Number of items that can be bought
  int quantity = 1;

  /// List of images in a notifier
  final ValueNotifier<List<String>> _imagesNotifier = ValueNotifier(const []);

  /// Getter for image notifier in case to listen to updates
  ValueNotifier<List<String>> get imageNotifier => _imagesNotifier;

  /// List of all the image url related to this product
  List<String> get imageList => _imagesNotifier.value;

  /// Image to display on the ItemCard of the product
  String _displayImage;

  /// Getter for the display image
  String get displayImage => _displayImage;

  /// The variation which is selected
  WooProductVariation _selectedVariation;

  /// Getter for selected product variation
  WooProductVariation get selectedVariation => _selectedVariation;

  /// Holds information about the product variations
  Set<WooProductVariation> variations = {};

  /// Save the product selected data in a class which takes in account
  /// the different variations
  ProductSelectedData productSelectedData;

  Product.fromWooProduct(this.wooProduct) : id = wooProduct.id.toString() {
    _imagesNotifier.value =
        wooProduct?.images?.map((e) => e.src)?.toList() ?? [];
    if (_imagesNotifier.value.isNotEmpty) {
      _displayImage = _imagesNotifier.value[0];
    }
    inStock = wooProduct.stockStatus == 'instock' || false;
    averageRating = wooProduct.averageRating;
    ratingCount.value = wooProduct.ratingCount;

    // Call to create a selected data instance just after creating the product
    // model
    setSelectedProductData(this);
    setDefaultAttributes(wooProduct.defaultAttributes);
  }

  void updateRatingCount(int newValue) {
    ratingCount.value = newValue;
  }

  void toggleLikedStatus({bool status}) {
    liked = status ?? !liked;
  }

  // sets the quantity
  set setQuantity(int value) {
    quantity = value;
  }

  /// Set the display image for the product instance
  void setDisplayImage(String value) {
    _displayImage = value;
  }

  /// Adds more images to the product image list
  /// Usually used to add product variation images.
  void addProductImages(List<String> values) {
    final Set<String> tempList = <String>{...values, ..._imagesNotifier.value};
    _imagesNotifier.value = tempList.toList();
  }

  /// Set the given product variation as the selected product variation
  /// in the product
  void setSelectedProductVariation(WooProductVariation variation,
      {bool updateSelectedProductData = true}) {
    if (variation == null) {
      return;
    }
    _selectedVariation = variation;

    // Also add the images to the product images if the variation has any image
    if (variation.image != null && variation.image.src != null) {
      addProductImages([variation.image.src]);
    }

    if (updateSelectedProductData) {
      setSelectedProductData(this);
    }
  }

  /// Set the data for the selected product in a class based on the
  /// variation chosen
  void setSelectedProductData(Product product) {
    productSelectedData = ProductSelectedData.fromProduct(product);
  }

  /// Copy the data with the new product data
  Product copyWith(Product product) {
    final p = Product(
      id: product.id,
      wooProduct: product.wooProduct,
      liked: product.liked,
    );

    if (product.selectedVariation != null) {
      p.setSelectedProductVariation(
        product.selectedVariation,
        updateSelectedProductData: false,
      );
    }

    p.productSelectedData = product.productSelectedData;

    p.quantity = product.quantity;

    return p;
  }

  /// Copy the data with the new product data
  Product copyWithWooProduct(WooProduct wooProduct) {
    final p = Product(
      id: wooProduct.id.toString(),
      wooProduct: wooProduct,
      liked: liked,
    );

    if (selectedVariation != null) {
      p.setSelectedProductVariation(
        selectedVariation,
        updateSelectedProductData: false,
      );
    }

    p.productSelectedData = productSelectedData;

    p.quantity = quantity;

    return p;
  }

  ValueNotifier<Map> selectedAttributesNotifier = ValueNotifier({});

  void updateSelectedAttributes(Map updatedMap) {
    selectedAttributesNotifier.value.addAll(updatedMap);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    selectedAttributesNotifier.notifyListeners();
  }

  void setDefaultAttributes(List<WooProductDefaultAttribute> defAttr) {
    for (final elem in defAttr) {
      selectedAttributesNotifier.value.addAll({elem.name: elem.option});
    }
  }

  /// Creates the key for the `selectedAttributes` of the product
  static String attributeKey(String value) {
    if (isBlank(value)) {
      return 'NA';
    }
    return value.toString().toLowerCase();
  }

  /// Creates the value for the `selectedAttributes` of the product
  static String attributeValue(String value) {
    if (isBlank(value)) {
      return 'NA';
    }
    return value.toString().toLowerCase();
  }
}

/// Holds the information about the selected choices of the product
/// variation
@immutable
class ProductSelectedData {
  final String image;
  final String price;
  final bool onSale;
  final Map selectedAttributes;

//<editor-fold desc="Data Methods" defaultState="collapsed">

  const ProductSelectedData({
    this.image,
    this.price,
    this.onSale,
    this.selectedAttributes,
  });

  factory ProductSelectedData.fromMap(Map<String, dynamic> map) {
    return ProductSelectedData(
      image: map['image'] as String,
      price: map['price'] as String,
      onSale: map['onSale'] as bool,
      selectedAttributes: map['selectedAttributes'] as Map,
    );
  }

  factory ProductSelectedData.fromProduct(Product product) {
    String image;
    String price;
    bool onSale;
    Map selectedAttributes;

    final variation = product.selectedVariation;

    if (variation != null) {
      // Set the image
      if (variation.image != null) {
        image = variation.image.src;
      }

      // Set the price
      price = variation.onSale ? variation.salePrice : variation.regularPrice;
      onSale = variation.onSale ?? false;
    } else {
      try {
        image = product.imageList.first;
      } catch (e) {
        image = null;
      }
      price = product.wooProduct.onSale == true
          ? product.wooProduct.salePrice
          : product.wooProduct.regularPrice;
      onSale = product.wooProduct.onSale;
      selectedAttributes = product.selectedAttributesNotifier.value;
    }

    return ProductSelectedData(
      image: image,
      price: price,
      onSale: onSale,
      selectedAttributes: selectedAttributes,
    );
  }

  ProductSelectedData copyWith({
    String image,
    String price,
    bool onSale,
    Map selectedAttributes,
  }) {
    if ((image == null || identical(image, this.image)) &&
        (price == null || identical(price, this.price)) &&
        (onSale == null || identical(onSale, this.onSale)) &&
        (selectedAttributes == null ||
            identical(selectedAttributes, this.selectedAttributes))) {
      return this;
    }

    return ProductSelectedData(
      image: image ?? this.image,
      price: price ?? this.price,
      onSale: onSale ?? this.onSale,
      selectedAttributes: selectedAttributes ?? this.selectedAttributes,
    );
  }

  @override
  String toString() {
    return 'ProductSelectedData{image: $image, price: $price, selectedAttributes: $selectedAttributes, onSale: $onSale}';
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'image': image,
      'price': price,
      'onSale': onSale,
      'selectedAttributes': selectedAttributes,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

/// Product Attribute which holds information about the sizes for the products
@immutable
class SizeProductAttribute {
  final List<String> sizeList;
  final String defaultSize;
  final String selectedSize;

  const SizeProductAttribute({
    @required this.sizeList,
    @required this.defaultSize,
    @required this.selectedSize,
  });

  const SizeProductAttribute.empty({
    this.sizeList = const [],
    this.defaultSize = '',
    this.selectedSize = '',
  });

  factory SizeProductAttribute.fromMap(Map<String, dynamic> map) {
    return SizeProductAttribute(
      sizeList: map['sizeList'] as List<String> ?? [],
      defaultSize: map['defaultSize'] as String ?? '',
      selectedSize: map['selectedSize'] as String ?? '',
    );
  }

  factory SizeProductAttribute.fromWooProductItemAttributes(
    List<WooProductItemAttribute> attributes,
    List<WooProductDefaultAttribute> defaultAttributes,
  ) {
    try {
      // create size attribute
      final sizeAttr = attributes.firstWhere(
        (element) => element != null && element.name.toLowerCase() == 'size',
        orElse: () => null,
      );

      // Find the default size attribute
      final defaultSizeAttr = defaultAttributes.firstWhere(
        (element) => element != null && element.name.toLowerCase() == 'size',
        orElse: () => null,
      );

      if (sizeAttr == null) {
        return const SizeProductAttribute.empty();
      }

      if (sizeAttr.options == null || sizeAttr.options.isEmpty) {
        return const SizeProductAttribute.empty();
      }

      return SizeProductAttribute(
        sizeList: sizeAttr.options,
        defaultSize: defaultSizeAttr != null
            ? defaultSizeAttr.option
            : sizeAttr.options[0],
        selectedSize: defaultSizeAttr != null
            ? defaultSizeAttr.option
            : sizeAttr.options[0],
      );
    } catch (e) {
      Dev.error('', error: e);
      return const SizeProductAttribute.empty();
    }
  }

  factory SizeProductAttribute.fromWooProductVariationAttribute(
    List<WooProductVariationAttribute> attributes,
  ) {
    try {
      // create size attribute
      final sizeAttr = attributes.firstWhere(
        (element) => element != null && element.name.toLowerCase() == 'size',
        orElse: () => null,
      );

      if (sizeAttr == null) {
        return const SizeProductAttribute.empty();
      }

      if (sizeAttr.option == null || sizeAttr.option.isEmpty) {
        return const SizeProductAttribute.empty();
      }

      return SizeProductAttribute(
        sizeList: const [],
        defaultSize: sizeAttr.option,
        selectedSize: sizeAttr.option,
      );
    } catch (e) {
      Dev.error('', error: e);
      return const SizeProductAttribute.empty();
    }
  }

  SizeProductAttribute copyWith({
    List<String> sizeList,
    String defaultSize,
    String selectedSize,
  }) {
    if ((sizeList == null || identical(sizeList, this.sizeList)) &&
        (defaultSize == null || identical(defaultSize, this.defaultSize)) &&
        (selectedSize == null || identical(selectedSize, this.selectedSize))) {
      return this;
    }

    return SizeProductAttribute(
      sizeList: sizeList ?? this.sizeList,
      defaultSize: defaultSize ?? this.defaultSize,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'sizeList': sizeList,
      'defaultSize': defaultSize,
      'selectedSize': selectedSize,
    } as Map<String, dynamic>;
  }
}

/// Product Attribute which holds information about the color for the products
@immutable
class ColorProductAttribute {
  final List<Color> colorList;
  final Color defaultColor;
  final Color selectedColor;

  const ColorProductAttribute({
    @required this.colorList,
    @required this.defaultColor,
    @required this.selectedColor,
  });

  const ColorProductAttribute.empty({
    this.colorList = const [],
    this.defaultColor,
    this.selectedColor,
  });

  factory ColorProductAttribute.fromMap(Map<String, dynamic> map) {
    return ColorProductAttribute(
      colorList: map['colorList'] as List<Color> ?? [],
      defaultColor: map['defaultColor'] as Color,
      selectedColor: map['selectedColor'] as Color,
    );
  }

  factory ColorProductAttribute.fromWooProductItemAttributes(
    List<WooProductItemAttribute> attributes,
    List<WooProductDefaultAttribute> defaultAttributes,
  ) {
    try {
      final colorAttr = attributes.firstWhere(
        (element) =>
            element != null && element.name.toLowerCase() == 'color' ||
            element.name.toLowerCase() == 'colour',
        orElse: () => null,
      );

      // Find the default size attribute
      final defaultColorAttr = defaultAttributes.firstWhere(
        (element) =>
            element != null && element.name.toLowerCase() == 'color' ||
            element.name.toLowerCase() == 'colour',
        orElse: () => null,
      );

      if (colorAttr == null) {
        return const ColorProductAttribute.empty();
      }

      if (colorAttr.options == null || colorAttr.options.isEmpty) {
        return const ColorProductAttribute.empty();
      }

      final _colorList = _getColorList(colorAttr.options);
      Color _defaultColor;

      if (defaultColorAttr != null) {
        _defaultColor = HexColor(colorNameToHex[
            defaultColorAttr.option.toLowerCase().replaceAll(' ', '')]);
      } else {
        _defaultColor = _colorList[0];
      }

      return ColorProductAttribute(
        colorList: _colorList,
        defaultColor: _defaultColor,
        selectedColor: _defaultColor,
      );
    } catch (e) {
      Dev.error('', error: e);
      return const ColorProductAttribute.empty();
    }
  }

  factory ColorProductAttribute.fromWooProductVariationAttribute(
    List<WooProductVariationAttribute> attributes,
  ) {
    try {
      final colorAttr = attributes.firstWhere(
        (element) =>
            element != null && element.name.toLowerCase() == 'color' ||
            element.name.toLowerCase() == 'colour',
        orElse: () => null,
      );

      if (colorAttr == null) {
        return const ColorProductAttribute.empty();
      }

      if (colorAttr.option == null || colorAttr.option.isEmpty) {
        return const ColorProductAttribute.empty();
      }

      final Color _defaultColor = HexColor(
          colorNameToHex[colorAttr.option.toLowerCase().replaceAll(' ', '')]);

      return ColorProductAttribute(
        colorList: const [],
        defaultColor: _defaultColor,
        selectedColor: _defaultColor,
      );
    } catch (e) {
      Dev.error('', error: e);
      return const ColorProductAttribute.empty();
    }
  }

  ColorProductAttribute copyWith({
    List<Color> colorList,
    Color defaultColor,
    Color selectedColor,
  }) {
    if ((colorList == null || identical(colorList, this.colorList)) &&
        (defaultColor == null || identical(defaultColor, this.defaultColor)) &&
        (selectedColor == null ||
            identical(selectedColor, this.selectedColor))) {
      return this;
    }

    return ColorProductAttribute(
      colorList: colorList ?? this.colorList,
      defaultColor: defaultColor ?? this.defaultColor,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  static List<Color> _getColorList(List<String> iterable) {
    final List<Color> tempList = [];
    for (final item in iterable) {
      final String hexString =
          colorNameToHex[item.toLowerCase().replaceAll(' ', '')];

      if (hexString == null) {
        continue;
      }

      final Color c = HexColor(hexString);
      tempList.add(c);
    }
    return tempList;
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'colorList': colorList.cast<String>(),
      'defaultColor': defaultColor.toString(),
      'selectedColor': selectedColor.toString(),
    } as Map<String, dynamic>;
  }
}
