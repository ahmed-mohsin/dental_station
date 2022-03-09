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

import '../../../constants/config.dart';
import '../../../developer/dev.log.dart';
import '../../../enums/enums.dart';
import '../../../locator.dart';
import '../../../models/productModel.dart';
import '../../../providers/utils/baseProvider.dart';
import '../../../services/woocommerce/woocommerce.service.dart';

export '../../../services/woocommerce/woocommerce.service.dart';

class VendorProductsViewModel extends BaseProvider with WooFiltersMixin {
  VendorProductsViewModel(this.vendor) {
    scrollController = ScrollController();
  }

  //**********************************************************
  //  Data Holders
  //**********************************************************

  final Vendor vendor;

  /// Error message state holder
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  /// Holds all the products' id from the tag selected.
  List<String> _productsList = [];

  List<String> get productsList => _productsList;

  /// Page to get the data for
  int pageNumber = 2;

  /// Flag to check if more data is available
  bool isFinalDataSet = false;

  /// The controller for the scroll view
  ScrollController scrollController;

  //**********************************************************
  //  Events
  //**********************************************************

  /// Loading event
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// Success flag to verify if data fetching event was successfully.
  bool _isSuccess = false;

  bool get isSuccess => _isSuccess;

  /// Error flag for any error while fetching
  bool _isError = false;

  bool get isError => _isError;

  /// Flag to check if there is data or not
  bool _hasData = false;

  bool get hasData => _hasData;

  //**********************************************************
  //  Functions
  //**********************************************************

  /// Fetch the product data for the tag chosen.
  Future<void> fetchData() async {
    Dev.debugFunction(
      functionName: 'fetchData',
      className: 'VendorProductsViewModel',
      fileName: 'VendorProductsViewModel',
      start: true,
    );

    try {
      reset();
      _onLoading(true);
      final _r = _processRawData(await _getDataFromBackend());

      if (_r.isEmpty) {
        _onSuccessful(isDataPresent: false);
      } else {
        _productsList = [..._r];
        _onSuccessful();
      }
      Dev.debugFunction(
        functionName: 'fetchData',
        className: 'VendorProductsViewModel',
        start: false,
        fileName: 'VendorProductsViewModel',
      );
    } catch (e, s) {
      Dev.error(e, stackTrace: s);
      _onError(e.toString());
    }
  }

  /// Fetch more product data for the tag chosen
  Future<FetchActionResponse> fetchMoreData() async {
    Dev.debugFunction(
      functionName: 'fetchMoreData',
      className: 'VendorProductsViewModel',
      start: true,
      fileName: 'VendorProductsViewModel',
    );

    try {
      final _r = _processRawData(await _getDataFromBackend(
        page: pageNumber,
      ));

      if (_r.isEmpty) {
        if (_productsList.isEmpty) {
          Dev.debugFunction(
            functionName: 'fetchMoreData',
            className: 'VendorProductsViewModel',
            start: false,
            fileName: 'VendorProductsViewModel',
          );
          isFinalDataSet = true;
          return FetchActionResponse.NoDataAvailable;
        } else {
          Dev.debugFunction(
            functionName: 'fetchMoreData',
            className: 'VendorProductsViewModel',
            start: false,
            fileName: 'VendorProductsViewModel',
          );
          isFinalDataSet = true;
          return FetchActionResponse.LastData;
        }
      } else {
        // add the data to the list
        _productsList.addAll(_r);
        notifyListeners();
        // if result is not empty then check if the length of list is less than
        // 20 to check if this was the last amount of data that was available.
        if (_r.length < 20) {
          Dev.debugFunction(
            functionName: 'fetchMoreData',
            className: 'VendorProductsViewModel',
            start: false,
            fileName: 'VendorProductsViewModel',
          );
          isFinalDataSet = true;
          return FetchActionResponse.LastData;
        } else {
          Dev.debugFunction(
            functionName: 'fetchMoreData',
            className: 'VendorProductsViewModel',
            start: false,
            fileName: 'VendorProductsViewModel',
          );
          pageNumber++;
          return FetchActionResponse.Successful;
        }
      }
    } catch (e, s) {
      Dev.error(e, stackTrace: s);
      return FetchActionResponse.Failed;
    }
  }

  /// Fetch the product data for the tag chosen with the new price range.
  Future<void> fetchDataWithNewPrice() async {
    Dev.debugFunction(
      functionName: 'fetchDataWithNewPrice',
      className: 'VendorProductsViewModel',
      start: true,
      fileName: 'VendorProductsViewModel',
    );

    try {
      // Reset the page and final data set info as a new price
      // is set
      reset();
      _onLoading(true);
      final _r = _processRawData(await _getDataFromBackend());

      if (_r.isEmpty) {
        _onSuccessful(isDataPresent: false);
      } else {
        _productsList = [..._r];
        _onSuccessful();
      }
      Dev.debugFunction(
        functionName: 'fetchDataWithNewPrice',
        className: 'VendorProductsViewModel',
        start: false,
        fileName: 'VendorProductsViewModel',
      );
    } catch (e, s) {
      Dev.error(e, stackTrace: s);
      _onError(e.toString());
    }
  }

  /// Fetch the product data for the category chosen with sort option
  /// filter
  Future<void> fetchWithSortOption() async {
    Dev.debugFunction(
      functionName: 'fetchWithSortOption',
      className: 'CategoryProductsProvider',
      fileName: 'CategoryProductsProvider',
      start: true,
    );

    try {
      // Reset the page and final data set info as a new price
      // is set
      reset();
      _onLoading(true);
      final _r = _processRawData(await _getDataFromBackend());

      if (_r.isEmpty) {
        _onSuccessful(isDataPresent: false);
      } else {
        _productsList = [..._r];
        _onSuccessful();
      }
      Dev.debugFunction(
        functionName: 'fetchWithSortOptions',
        className: 'VendorProductsViewModel',
        start: false,
        fileName: 'VendorProductsViewModel',
      );
    } catch (e, s) {
      Dev.error(e, stackTrace: s);
      _onError(e.toString());
    }
  }

  /// Gets the data from backend and returns a list of map of strings and dynamic
  /// values to process.
  @protected
  Future<List<WooProduct>> _getDataFromBackend({int page = 1}) async {
    Dev.debugFunction(
      functionName: '_getDataFromBackend',
      className: 'VendorProductsViewModel',
      start: true,
      fileName: 'VendorProductsViewModel',
    );

    // Get data from WooCommerce
    if (vendor == null) {
      Dev.error('Tag is empty...aborting fetch event');
      return const [];
    }

    try {
      final List<WooProduct> _result =
          await LocatorService.wooService().wc.getProducts(
        page: page,
        perPage: FilterConfig.vendorProductsSearchPerPage,
        minPrice: filters.minPrice.toString(),
        maxPrice: filters.maxPrice.toString(),
        stockStatus: filters.inStock ? 'instock' : null,
        onSale: filters.onSale ? filters.onSale : null,
        featured: filters.featured ? filters.featured : null,
        orderBy: WooUtils.convertSortOptionToString(filters.sortOption),
        order: WooUtils.setSortOrder(filters.sortOption),
        taxonomyQuery: await filters.buildTaxonomyQuery(),
        extraParams: {'vendor': vendor.id},
      );
      Dev.debugFunction(
        functionName: '_getDataFromBackend',
        className: 'VendorProductsViewModel',
        start: false,
        fileName: 'VendorProductsViewModel',
      );
      return _result;
    } catch (e) {
      Dev.error('End =====>> [_getDataFromBackend]', error: e);
      return const [];
    }
  }

  /// Process the product data list and returns a list of product's ids and adds
  /// them to the all products map in products provider for liking and other
  /// local stuff.
  @protected
  List<String> _processRawData(List<WooProduct> productsDataList) {
    // Function log
    Dev.debugFunction(
      functionName: '_processRawData',
      className: 'VendorProductsViewModel',
      start: true,
      fileName: 'VendorProductsViewModel',
    );
    final List<String> result = [];
    if (productsDataList.isNotEmpty) {
      for (var i = 0; i < productsDataList.length; i++) {
        if (_productsList.contains(productsDataList[i].id.toString())) {
          result.add(productsDataList[i].id.toString());
          continue;
        }
        final Product p = Product.fromWooProduct(productsDataList[i]);
        result.add(p.id.toString());
        LocatorService.productsProvider().addToMap(p);
      }
    }
    // Function log
    Dev.debugFunction(
      functionName: '_processRawData',
      className: 'VendorProductsViewModel',
      start: false,
      fileName: 'VendorProductsViewModel',
    );
    return result;
  }

  //**********************************************************
  //  Helper Functions
  //**********************************************************

  /// Changes the flags to reflect loading event and notify the listeners.
  void _onLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Changes the flags to reflect success and notify the listeners.
  void _onSuccessful({bool isDataPresent = true}) {
    _isLoading = false;
    _isSuccess = true;
    _isError = false;
    _hasData = isDataPresent;
    notifyListeners();
  }

  void _onError(String message) {
    _isLoading = false;
    _isSuccess = false;
    _isError = true;
    _errorMessage = message;
    notifyListeners();
  }

  /// Cleans the resources when the `categorisedProducts` screen is disposed
  /// for the next session
  void cleanUp() {
    _productsList = [];
    _errorMessage = '';
    filters = const WooStoreFilters();
  }

  void reset() {
    pageNumber = 2;
    isFinalDataSet = false;
  }
}
