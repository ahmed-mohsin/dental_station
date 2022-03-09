// Copyright (c) 2021 Aniket Malik [aniketmalikwork@gmail.com]
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

import '../../models/models.dart';
import '../../services/woocommerce/woocommerce.service.dart';

enum OrderStatus {
  all,
  pending,
  processing,
  completed,
  cancelled,
  refunded,
  failed,
  undefined,
}

class Order {
  int id;
  WooOrder wooOrder;
  Map<String, Product> products;
  Map<int, WooProductVariation> productVariations;
  OrderStatus status;
  AdvancedShipmentTracking shipmentTracking;

  Order({
    @required this.id,
    @required this.wooOrder,
    this.products,
    this.productVariations,
    this.status,
    this.shipmentTracking,
  });

  factory Order.fromWooOrder(WooOrder value) {
    return Order(
      id: value.id,
      wooOrder: value,
      products: {},
      productVariations: {},
      status: _createOrderStatus(value.status.toString()),
    );
  }

  void updateVariations(WooProductVariation variation) {
    productVariations.addAll({variation.id: variation});
  }

  void updateProducts(Product product) {
    products.addAll({product.id: product});
  }

  void updateShipmentTracking(AdvancedShipmentTracking ast) {
    shipmentTracking = ast;
  }

  /// Create the order status for the wooOrder
  static OrderStatus _createOrderStatus(String value) {
    switch (value.toLowerCase()) {
      case 'completed':
        return OrderStatus.completed;
        break;

      case 'processing':
        return OrderStatus.processing;
        break;

      case 'cancelled':
        return OrderStatus.cancelled;
        break;

      case 'pending':
        return OrderStatus.pending;
        break;

      case 'refunded':
        return OrderStatus.refunded;
        break;
      case 'failed':
        return OrderStatus.failed;
        break;
      default:
        return OrderStatus.undefined;
    }
  }
}
