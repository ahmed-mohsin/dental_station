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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/config.dart';
import '../../locator.dart';
import 'layouts/utils.dart';
import 'productNotFound.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({
    Key key,
    @required this.id,
  }) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    final productData = LocatorService.productsProvider().productsMap[id];
    if (productData == null) {
      return ProductNotFound(productId: id);
    }
    return PSLayoutUtils.renderLayout(
      Config.productScreenLayout,
      productData,
    );
  }
}
