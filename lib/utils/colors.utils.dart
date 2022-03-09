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

import 'dart:ui';

import '../constants/colors.dart';
import '../developer/dev.log.dart';

class HexColor extends Color {
  HexColor(final String hexString) : super(_getColorFromHex(hexString));
  HexColor.fromDynamicString(String hexString)
      : super(_getValueFromDynamicString(hexString));

  static int _getColorFromHex(String value) {
    String colorValue;
    if (colorNameToHex.containsKey(value)) {
      colorValue = colorNameToHex[value];
    } else {
      Dev.warn(
          'Color Value for $value could not be found. Please check that hex value for $value is present in colors.dart');
      return int.parse('FF000000', radix: 16);
    }
    try {
      colorValue = colorValue.toUpperCase().replaceAll('#', '');
      if (colorValue.length == 6) {
        colorValue = 'FF' + colorValue;
      }
      return int.parse(colorValue, radix: 16);
    } catch (e, s) {
      Dev.error('Error _getColorFromHex', error: e, stackTrace: s);
      return int.parse('FF000000', radix: 16);
    }
  }

  static int _getValueFromDynamicString(String value) {
    if (value == null) {
      Dev.warn('Dynamic Color Value is null');
      return int.parse('FF000000', radix: 16);
    }
    try {
      String colorValue = value.toUpperCase().replaceAll('#', '');
      if (colorValue.length == 6) {
        colorValue = 'FF' + colorValue;
      }
      return int.parse(colorValue, radix: 16);
    } catch (e, s) {
      Dev.error('Error _getValueFromDynamicString', error: e, stackTrace: s);
      return int.parse('FF000000', radix: 16);
    }
  }
}
