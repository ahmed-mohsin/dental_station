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
import '../../../../locator.dart';
import '../../viewModel/searchViewModel.dart';

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
              Selector<SearchViewModel, double>(
                selector: (context, d) => d.priceStart,
                builder: (context, startValue, widget) {
                  return Text(
                      Config.currency + ' ' + startValue.toInt().toString());
                },
              ),
              const Spacer(),
              Selector<SearchViewModel, double>(
                selector: (context, d) => d.priceEnd,
                builder: (context, endValue, widget) {
                  return Text(
                      Config.currency + ' ' + endValue.toInt().toString());
                },
              ),
            ],
          ),
        ),
        Consumer<SearchViewModel>(
          builder: (context, provider, _) {
            return RangeSlider(
              values: RangeValues(provider.priceStart, provider.priceEnd),
              min: FilterConfig.searchProductsPriceRangeMin,
              max: FilterConfig.searchProductsPriceRangeMax,
              divisions: FilterConfig.searchProductsPriceRangeDivisions,
              onChangeEnd: _updateProvider,
              onChanged: _updateProvider,
            );
          },
        ),
      ],
    );
  }

  void _updateProvider(RangeValues values) {
    // Update the provider with the values.
    LocatorService.searchViewModel().setPriceRange(
      start: values.start.floor().toDouble(),
      end: values.end.floor().toDouble(),
    );
  }
}
