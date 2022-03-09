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

import 'grid.dart';
import 'list.dart';

abstract class CHSLayoutUtils {
  /// Renders the layout for the Categories Screen
  static Widget renderLayout(String layoutName) {
    final CHSLayout layoutType = _convertStringToCHSLayoutType(layoutName);
    switch (layoutType) {
      case CHSLayout.listHorizontal:
        return const CHSHorizontalListLayout();
        break;
      case CHSLayout.grid:
        return const CHSGridLayout();
        break;
      default:
        return const CHSHorizontalListLayout();
    }
  }

  static CHSLayout _convertStringToCHSLayoutType(String value) {
    switch (value) {
      case 'list-horizontal':
        return CHSLayout.listHorizontal;
        break;
      case 'grid':
        return CHSLayout.grid;
        break;
      default:
        return CHSLayout.listHorizontal;
    }
  }
}

enum CHSLayout {
  grid,
  listHorizontal,
}
