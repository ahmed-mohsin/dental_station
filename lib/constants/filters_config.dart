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

abstract class FilterConfig {
  static const double defaultPriceRangeMin = 0;
  static const double defaultPriceRangeMax = 10000;
  static const int defaultPriceRangeDivisions = 10;

  //**********************************************************
  // All products
  //**********************************************************
  static const double allProductsPriceRangeMin = 0;
  static const double allProductsPriceRangeMax = 10000;
  static const int allProductsPriceRangeDivisions = 10;
  static const int allProductsSearchPerPage = 10;

  //**********************************************************
  // Categorised Products
  //**********************************************************
  static const double categorisedProductsPriceRangeMin = 0;
  static const double categorisedProductsPriceRangeMax = 10000;
  static const int categorisedProductsPriceRangeDivisions = 10;
  static const int categorisedProductsSearchPerPage = 10;

  //**********************************************************
  // Search Products
  //**********************************************************
  static const double searchProductsPriceRangeMin = 0;
  static const double searchProductsPriceRangeMax = 10000;
  static const int searchProductsPriceRangeDivisions = 10;
  static const int searchProductsSearchPerPage = 10;

  //**********************************************************
  // Tags Products
  //**********************************************************
  static const double tagProductsPriceRangeMin = 0;
  static const double tagProductsPriceRangeMax = 10000;
  static const int tagProductsPriceRangeDivisions = 10;
  static const int tagProductsSearchPerPage = 10;

  //**********************************************************
  // Vendor Products
  //**********************************************************
  static const double vendorProductsPriceRangeMin = 0;
  static const double vendorProductsPriceRangeMax = 10000;
  static const int vendorProductsPriceRangeDivisions = 10;
  static const int vendorProductsSearchPerPage = 10;
}
