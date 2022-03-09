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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../../locator.dart';
import '../../../../shared/widgets/quantityButtons/quantityButtons.dart';
import '../../viewModel/viewModel.dart';

class QuantityCart extends StatelessWidget {
  const QuantityCart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final CartViewModel provider = LocatorService.cartViewModel();
    final String productId = LocatorService.cartViewModel().currentProduct.id;
    final lang = S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            lang.quantity,
            style: _theme.textTheme.subtitle1,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              QuantityButtonNegative(
                productId: productId,
                onPressed: provider.decreaseProductQuantity,
              ),
              Selector<CartViewModel, int>(
                selector: (context, d) => d.productsMap[productId].quantity,
                builder: (context, quantity, _) {
                  return Text(
                    '$quantity',
                    style: _theme.textTheme.subtitle1,
                  );
                },
              ),
              QuantityButtonPositive(
                productId: productId,
                onPressed: provider.increaseProductQuantity,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
