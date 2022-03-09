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

import '../constants/config.dart';

///
/// `Description`
///
/// Render the price for the item cards.
/// Returns a currency symbol if it is not empty else returns
/// the currency code
///
@Deprecated('Use Utils.formatPrice instead')
String formatPrice(String amount, {bool forceShowCurrency = false}) {
  if (forceShowCurrency) {
    return Config.currency.toUpperCase() + ' $amount';
  }
  return Config.currencySymbol.isNotEmpty
      ? Config.currencySymbol + amount
      : Config.currency + ' $amount';
}
