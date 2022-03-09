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

import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:woocommerce/models/coupon.dart';
import 'package:woocommerce/woocommerce.dart';

import '../../../../constants/config.dart';
import '../../../../generated/l10n.dart';
import '../../../../locator.dart';
import 'layouts/default.dart';
import 'layouts/text_field_tile.dart';
import 'widgets/applied_coupon.dart';

class CartCoupon extends StatelessWidget {
  const CartCoupon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return ValueListenableBuilder<WooCoupon>(
      valueListenable: LocatorService.cartViewModel().selectedCoupon,
      builder: (context, selectedCoupon, w) {
        if (selectedCoupon.id > 0 && isNotBlank(selectedCoupon.code)) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${lang.applied} ${lang.coupon}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              AppliedCoupon(coupon: selectedCoupon),
            ],
          );
        }
        return w;
      },
      child: _renderLayout(),
    );
  }

  Widget _renderLayout() {
    switch (Config.cartCouponLayout) {
      case 'default':
        return const CouponDefaultTile();
        break;
      case 'text-field':
        return const CouponTextFieldTile();
      default:
        return const CouponDefaultTile();
    }
  }
}
