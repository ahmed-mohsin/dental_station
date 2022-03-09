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
import 'listChildCategoriesVisible.dart';

abstract class CSLayoutUtils {
  /// Renders the layout for the Categories Screen
  static Widget renderLayout(String layoutName) {
    final CSLayout layoutType = _convertStringToCSLayoutType(layoutName);
    switch (layoutType) {
      case CSLayout.grid:
        return const CSLayoutGrid();
        break;
      case CSLayout.list:
        return const CSLayoutList();
        break;
      case CSLayout.listChildCategoriesVisible:
        return const CSListChildCategoriesVisibleLayout();
        break;
      default:
        return const CSLayoutGrid();
    }
  }

  static CSLayout _convertStringToCSLayoutType(String value) {
    switch (value) {
      case 'grid':
        return CSLayout.grid;
        break;
      case 'list':
        return CSLayout.list;
        break;
      case 'list-child-categories-visible':
        return CSLayout.listChildCategoriesVisible;
        break;
      default:
        return CSLayout.grid;
    }
  }
}

enum CSLayout {
  grid,
  list,
  listChildCategoriesVisible,
}
