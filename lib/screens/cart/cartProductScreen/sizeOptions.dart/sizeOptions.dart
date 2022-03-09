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

import '../../../../themes/theme.dart';
import '../../../../utils/style.dart';

class SizeOptionsCart extends StatefulWidget {
  const SizeOptionsCart({Key key}) : super(key: key);

  @override
  _SizeOptionsCartState createState() => _SizeOptionsCartState();
}

class _SizeOptionsCartState extends State<SizeOptionsCart> {
  String _value = 'M';

  List<String> sizeList = [
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Wrap(
          children: List<Widget>.generate(
            0,
            (int index) {
              return Padding(
                padding: ThemeGuide.padding,
                child: ChoiceChip(
                  backgroundColor: Theme.of(context).backgroundColor,
                  selectedColor:
                      Theme.of(context).primaryColorLight.withAlpha(50),
                  labelStyle: Theme.of(context).textTheme.bodyText2,
                  padding: ThemeGuide.padding,
                  shape: const RoundedRectangleBorder(
                    borderRadius: ThemeGuide.borderRadius,
                  ),
                  label: Text(
                    sizeList[index],
                    style: TextStyle(
                      color: _value == sizeList[index]
                          ? Theme.of(context).primaryColorLight
                          : UIStyle.isDarkMode(context)
                              ? Colors.white54
                              : Colors.black26,
                    ),
                  ),
                  selected: _value == sizeList[index],
                  onSelected: (bool selected) {
                    setState(
                      () {
                        _value = selected ? sizeList[index] : null;
                        // provider.setProductSize(productId, sizeList[index]);
                      },
                    );
                  },
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
