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

import '../../../../constants/config.dart';
import '../../viewModel/view_model.dart';

class PriceRangeSliderFilter extends StatelessWidget {
  const PriceRangeSliderFilter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Selector<VendorProductsViewModel, double>(
                selector: (context, d) => d.priceStart,
                builder: (context, startValue, widget) {
                  return Text(
                      Config.currency + ' ' + startValue.toInt().toString());
                },
              ),
              const Spacer(),
              Selector<VendorProductsViewModel, double>(
                selector: (context, d) => d.priceEnd,
                builder: (context, endValue, widget) {
                  return Text(
                      Config.currency + ' ' + endValue.toInt().toString());
                },
              ),
            ],
          ),
        ),
        Consumer<VendorProductsViewModel>(
          builder: (context, provider, _) {
            return RangeSlider(
              values: RangeValues(provider.priceStart, provider.priceEnd),
              min: FilterConfig.vendorProductsPriceRangeMin,
              max: FilterConfig.vendorProductsPriceRangeMax,
              divisions: FilterConfig.vendorProductsPriceRangeDivisions,
              onChangeEnd: (values) {
                // Update the provider with the values.
                provider.setPriceRange(
                  start: values.start.floor().toDouble(),
                  end: values.end.floor().toDouble(),
                );
              },
              onChanged: (values) {
                // Update the provider with the values.
                provider.setPriceRange(
                  start: values.start.floor().toDouble(),
                  end: values.end.floor().toDouble(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
