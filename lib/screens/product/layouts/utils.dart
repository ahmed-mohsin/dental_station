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

import '../../../models/models.dart';
import 'draggableSheet.dart';
import 'expandable.dart';
import 'original.dart';

abstract class PSLayoutUtils {
  /// Renders the layout for the Categories Screen
  static Widget renderLayout(String layoutName, Product product) {
    final PSLayout layoutType = _convertStringToPSLayoutType(layoutName);
    switch (layoutType) {
      case PSLayout.original:
        return PSLayoutOriginal(product: product);
        break;
      case PSLayout.draggableSheet:
        return PSLayoutDraggableSheet(product: product);
        break;
      case PSLayout.expandable:
        return PSLayoutExpandable(product: product);
        break;
      default:
        return PSLayoutOriginal(product: product);
    }
  }

  static PSLayout _convertStringToPSLayoutType(String value) {
    switch (value) {
      case 'original':
        return PSLayout.original;
        break;
      case 'draggable-sheet':
        return PSLayout.draggableSheet;
        break;
      case 'expandable':
        return PSLayout.expandable;
        break;
      default:
        return PSLayout.original;
    }
  }
}

enum PSLayout {
  original,
  draggableSheet,
  expandable,
}
