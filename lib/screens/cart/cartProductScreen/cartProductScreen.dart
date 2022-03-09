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

import '../../../locator.dart';
import '../../../themes/themeGuide.dart';
import '../viewModel/viewModel.dart';
import 'buttons/buttons.dart';
import 'quantity/quantity.dart';

class CartProductScreen extends StatelessWidget {
  const CartProductScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return SafeArea(
      top: true,
      bottom: true,
      child: ChangeNotifierProvider<CartViewModel>.value(
        value: LocatorService.cartViewModel(),
        child: Padding(
          padding: ThemeGuide.padding20,
          child: Column(
            children: <Widget>[
              const Expanded(
                child: SizedBox.expand(),
              ),
              const RemoveButton(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: ThemeGuide.borderRadius,
                  color: _theme.backgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    // SubHeading(title: AppStrings.selectSize),
                    // SizeOptionsCart(),
                    // CustomDivider(),
                    QuantityCart(),
                    // CustomDivider(),
                    // SubHeading(title: AppStrings.color),
                    // ColorOptionsCart(),
                  ],
                ),
              ),
              const CancelButton(),
            ],
          ),
        ),
      ),
    );
  }
}
