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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../../locator.dart';
import '../../viewModel/searchViewModel.dart';

class FilterOnSale extends StatelessWidget {
  const FilterOnSale({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).onSale,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Selector<SearchViewModel, bool>(
          selector: (context, d) => d.searchFilters.onSale,
          builder: (context, value, _) {
            return CupertinoSwitch(
              activeColor: Theme.of(context).colorScheme.secondary,
              value: value,
              onChanged: LocatorService.searchViewModel().toggleOnSaleFlag,
            );
          },
        ),
      ],
    );
  }
}

class FilterInStock extends StatelessWidget {
  const FilterInStock({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).inStock,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Selector<SearchViewModel, bool>(
          selector: (context, d) => d.searchFilters.inStock,
          builder: (context, value, _) {
            return CupertinoSwitch(
              activeColor: Theme.of(context).colorScheme.secondary,
              value: value,
              onChanged: LocatorService.searchViewModel().toggleInStockFlag,
            );
          },
        ),
      ],
    );
  }
}

class FilterFeatured extends StatelessWidget {
  const FilterFeatured({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).featured,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Selector<SearchViewModel, bool>(
          selector: (context, d) => d.searchFilters.featured,
          builder: (context, value, _) {
            return CupertinoSwitch(
              activeColor: Theme.of(context).colorScheme.secondary,
              value: value,
              onChanged: LocatorService.searchViewModel().toggleFeaturedFlag,
            );
          },
        ),
      ],
    );
  }
}
