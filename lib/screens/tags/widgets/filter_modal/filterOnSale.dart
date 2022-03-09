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
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../viewModel/tag_products_view_model.dart';

class FilterOnSale extends StatelessWidget {
  const FilterOnSale({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final provider = Provider.of<TagProductsViewModel>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lang.onSale,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Selector<TagProductsViewModel, bool>(
          selector: (context, d) => d.filters.onSale,
          builder: (context, value, _) {
            return Switch(
              value: value,
              onChanged: provider.toggleOnSaleFlag,
            );
          },
        ),
      ],
    );
  }
}
