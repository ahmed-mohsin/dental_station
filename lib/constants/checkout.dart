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

abstract class CheckoutConfig {
  /// Flag for native checkout
  static const bool enableNativeCheckout = true;

  /// The checkout endpoint for order received
  static const String orderReceivedCheckoutEndpoint = 'order-received';

  /// Intercept the error pages for the web-views.
  static const String webviewErrorInvalidOrder = 'invalid-order';
  static const String webviewErrorJwtAuthBadConfig = 'jwt-auth-bad-config';
  static const String webviewErrorInvalidUserToken = 'invalid-user-token';
}
