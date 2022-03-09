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

export 'filters_config.dart';

abstract class Config {
  static const String appName = 'Dental Station';
  static const String appIconPath = 'lib/assets/images/app_icon.jpg';
  static const String currency = 'Egp';
  static const String currencySymbol = '\$';
  static const String placeholderImageUrl = 'https://via.placeholder.com/100';

  /// Path for the place holder image in the application assets directory
  static const String placeholderImageAssetPath =
      'lib/assets/images/placeholderImage.jpg';

  // Contact Us Page Information -
  //
  // [ENABLE]
  // If you want to enable an option then add the value for it.
  //
  // [DISABLE]
  // If you leave the option empty (For example: '') like this, then
  // the option will not be shown to the user.

  /// Must be a valid URL
  static const String contactUsUrl = 'https://www.example.com';

  /// This should be a valid phone number
  static const String contactUsPhone = '01553969051';

  /// Must be a valid email address
  static const String contactUsEmail = 'help@ecommercestore.com';

  /// Terms of service URL
  static const String termsOfServiceUrl = 'https://www.example.com';

  /// Privacy policy url
  static const String privacyPolicyUrl = 'https://www.example.com';

  /// Topic to send notifications to a group of users
  static const List<String> NOTIFICATION_TOPICS = [
    'NEW_APP_VERSION_AVAILABLE',
    'PROMOTIONS',
  ];

  //**********************************************************
  // Below is the information which you can change to either
  // show or hide the corresponding screens, widgets, else.
  //**********************************************************

  //**********************************************************
  // Home Page Settings
  //**********************************************************

  /// Setting to show or hide the notification or cart icon in
  /// home page app bar
  static const bool homePageAppBarShowNotificationIcon = true;
  static const bool homePageAppBarShowCartIcon = false;

  //**********************************************************
  // Categories settings.
  //
  // Flags to set the visibility of the categories in the home section,
  // filter modals and other places where categories are shown.
  //
  // Valid values: true | false
  //**********************************************************

  /// Possible values:
  /// • grid
  /// • list
  /// • list-child-categories-visible
  static const String categoriesScreenLayout = 'grid';

  /// Flag to set the number of columns of the categories in the
  /// Categories Screen in bottom tab bar
  ///
  /// Recommended value is 3
  static const int categoriesScreenGridLayoutCrossAxisCount = 3;

  /// Flag to set the visibility of the categories horizontal list
  /// in the home page
  static const bool showCategoriesInHome = true;

  /// Possible values:
  /// • grid
  /// • list-horizontal
  static const String categoriesHomeScreenLayout = 'list-horizontal';

  /// Flag to change the border radius of each item in the categories
  /// list in the home screen
  ///
  /// A value greater than or equal to 50 will make the item circular
  static const double categoriesHomeScreenItemBorderRadius = 10;

  /// Flag to set the number of columns of the categories in the
  /// Home Screen Categories List
  ///
  /// Recommended value is 5
  static const int categoriesHomeScreenGridLayoutCrossAxisCount = 5;

  /// Flag to set the visibility of the categories filter in
  /// search filter modal
  static const bool showCategoriesInSearchFilterModal = true;

  /// Flag to set the visibility of the categories filter in the
  /// all products filter modal.
  ///
  /// This filter modal is shown when the user clicks on the filter
  /// button when the user navigates to see all the products from a
  /// section in home screen.
  static const bool showCategoriesInAllProductsFilterModal = true;

  /// Flag to set the visibility of the categories horizontal list
  /// below the app bar in CategorisedProductsScreen
  ///
  /// If this flag is true, then the children categories list will be
  /// shown under the App Bar of the CategoriesProductsScreen which
  /// is the screen shown to the user when they select a category to
  /// sort the products.
  static const bool showCategoriesHorizontalListBelowCategorisedProductsAppBar =
      true;

  //**********************************************************
  // Product Screen
  //**********************************************************

  /// Set the type of layout you want for your product screen
  ///
  /// Available layout types
  /// • original
  /// • draggable-sheet
  /// • expandable
  static const productScreenLayout = 'expandable';

  /// Flag to show / hide short description section in
  /// product screen
  static const bool productScreenShowShortDescription = false;

  /// Change the layout of the button bar at the bottom in the
  /// product details screen
  ///
  /// Possible Values:
  /// • layout-1
  /// The original layout with bigger buy now button.
  /// This is the DEFAULT layout
  ///
  /// • layout-2
  /// 50-50 size distribution for buy now and add to cart
  ///
  /// • layout-3
  /// 50-50 size distribution for buy now and
  /// add to cart WITHOUT the cart icon
  static const String productScreenBottomButtonsLayout = 'layout-2';

  /// Flag to set if you want to allow users to add reviews from
  /// the product details page even if they have not purchased
  /// the order.
  static const bool productScreenAllowReviewsWithoutPurchase = false;

  /// Flag to enable or disable the vendor information display
  /// in the product screen.
  static const bool productScreenShowVendorTile = false;

  /// Flag to set the layout of the vendor tile in product screen
  ///
  /// Allowed values:
  /// 1. original
  /// 2. card
  /// 3. withoutBackgroundImage
  static const String productScreenVendorLayout = 'original';
  static const double productScreenVendorOriginalLayoutAspectRatio = 2;

  //**********************************************************
  // Cart Screen Settings
  //**********************************************************

  static const bool cartEnableNativeCheckout = true;

  /// This will work only with the native checkout feature
  static const bool cartEnableCoupon = true;

  /// Setting to set the coupon tile layout in cart.
  ///
  /// Available Options:
  /// 1. default
  /// 2. text-field
  static const String cartCouponLayout = 'default';

  /// This will work only with the native checkout feature
  static const bool cartEnableCustomerNote = true;

  //**********************************************************
  // Coupon Item card settings
  //**********************************************************

  static const bool couponShowUsageLimit = true;
  static const bool couponShowUsageCount = true;
  static const bool couponShowCouponType = true;
  static const bool couponShowMinimumSpend = true;
  static const bool couponShowMaximumSpend = true;

  //**********************************************************
  // My Orders Screen
  //**********************************************************

  /// Flag to show the add review button in products
  /// in my orders
  static const bool myOrdersShowAddReviewButtonForCompletedOrders = true;

  //**********************************************************
  // Tags settings.
  //
  // Flags to set the visibility of the tags in the filter modals and
  // other places where tags are shown.
  //
  // Valid values: true | false
  //**********************************************************

  /// Flag to set the visibility of the tags horizontal list in
  /// the search filter modal
  static const bool showTagsInSearchFilterModal = true;

  /// Flag to set the visibility of the tags horizontal list in
  /// the All products filter modal
  static const bool showTagsInAllProductsFilterModal = true;

  //**********************************************************
  // Virtual and Downloadable products settings
  //**********************************************************

  /// Flag to show / hide the customers downloadable or virtual
  /// products.
  static const bool showCustomerDownloadsListTile = true;

  //**********************************************************
  // WooCommerce Points and Rewards plugin configuration
  //
  // Set the following FLAGS value according to your use case.
  // The default values for all is 'true'
  //
  // Valid values: true | false
  //**********************************************************

  /// Whether to enable the WooCommerce Points and Rewards plugin
  /// support in the application
  static const bool enablePointsAndRewardsSupport = true;

  /// Flag for `My Points` list tile in the `Account Settings`
  /// If the value is set to true, then the list tile
  /// will be shown in the application otherwise not.
  static const bool showPointsListTile = true;

  /// Flag to decide whether points will be displayed in the Product's
  /// screen
  static const bool showPointsInProductScreen = false;

  //**********************************************************
  // Variation Swatches for WooCommerce Settings
  //**********************************************************

  /// Flag to check if variation swatches should be enabled
  static const bool enabledVariationSwatchesForWooCommerce = true;

  //**********************************************************
  // Settings to control share app feature
  //**********************************************************

  /// Flag to enable / disable the sharing feature for the whole
  /// application.
  static const bool enabledShareApp = true;

  /// Link to be shared
  static const String shareAppLink = 'https://www.example.com';

  /// Image to be displayed with the link
  static const String shareAppImageUrl = 'https://via.placeholder.com/300';

  /// If you enable this then you need to make sure that you have
  /// completed the setup steps for Firebase Dynamic Links and have
  /// added the appropriate values in the `FirebaseDynamicLinksConfig`
  /// class below
  static const bool enableShareAppThroughFirebaseDynamicLinks = true;

  /// Flag to check if the link shared should show a title.
  static const bool enableShareAppFirebaseDynamicLinksTitle = true;

  /// Flag to enable or disable otp based login
  static const bool enableOTPLogin = true;
}

abstract class FirebaseDynamicLinksConfig {
  /// The URI Prefix from your Firebase Dynamic Link console.
  /// This will also be added in the `AndroidManifest.xml` file
  /// to allow your application to be opened from the link.
  /// Please make sure that this is correct.
  static const String uriPrefix = 'https://woostorepro.page.link';

  /// The following package name and bundle id are the same as you
  /// used while setting up your ios and android apps on firebase.
  static const String androidPackageName = 'com.aniketmalik.ecommerce_store';
  static const String iOSBundleId = 'com.aniketmalik.ecommerceStore';

  /// Your app store id
  static const String appStoreId = '123456789';

  /// Flag to enable / disable firebase dynamic links share features
  /// for products
  static const bool isEnabledForSharingProducts = true;

  /// Flags to show extra social data in the shareable links
  static const bool shareProductTitle = true;
  static const bool shareProductDescription = true;
  static const bool shareProductImage = true;
}
