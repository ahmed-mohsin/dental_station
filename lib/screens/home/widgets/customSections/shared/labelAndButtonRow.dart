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

import '../../../../../controllers/navigationController.dart';
import '../../../models/homeSectionDataHolder.dart';
import 'seeAllButton.dart';

class LabelAndButtonRow extends StatelessWidget {
  const LabelAndButtonRow({
    Key key,
    @required this.homeSectionDataHolder,
    @required this.title,
  }) : super(key: key);

  final HomeSectionDataHolder homeSectionDataHolder;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title ?? '',
            style: Theme.of(context).textTheme.headline6,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SeeAllButton(
          onPress: () {
            NavigationController.navigator.push(
              AllProductsRoute(homeSectionDataHolder: homeSectionDataHolder),
            );
          },
        ),
      ],
    );
  }
}
