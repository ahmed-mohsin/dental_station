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

///
/// ## Description
///
/// Holds information about the WooCommerce API configuration which is
/// final and cannot be changed at run time
///
abstract class WooConfig {
  /// Your wordpress url
  static const String wordPressUrl = 'https://dentalstation.net/';

  // PLEASE ADD KEYS WITH ONLY READ PERMISSION
  static const String consumerKey = 'ck_66824d2306c7425f1f1ebf597322654c4f442662';
  static const String consumerSecret = 'cs_31e7355c007434299b49bfcc8a441e77b028e861';
}
