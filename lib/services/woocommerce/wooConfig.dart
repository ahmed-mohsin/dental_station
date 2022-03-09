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
  static const String wordPressUrl = 'https://example.com';

  // PLEASE ADD KEYS WITH ONLY READ PERMISSION
  static const String consumerKey = 'YOUR CONSUMER KEY';
  static const String consumerSecret = 'YOUR CONSUMER SECRET KEY';
}
