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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../constants/config.dart';
import '../../../developer/dev.log.dart';
import '../../../enums/enums.dart';
import '../../../locator.dart';
import '../../../models/models.dart';
import '../../../providers/utils/baseProvider.dart';
import '../../../services/woocommerce/woocommerce.service.dart';

export '../../../services/woocommerce/woocommerce.service.dart';

class SearchViewModel extends BaseProvider with WooFiltersMixin {
  SearchViewModel() {
    state = ViewState.CUSTOM_MESSAGE;
  }

  /// Reset the model for future use
  void reset() {
    // Function Log
    Dev.debugFunction(
      functionName: 'reset',
      className: 'SearchViewModel',
      fileName: 'searchViewModel.dart',
      start: true,
    );

    _searchProductsList = [];
    priceStart = FilterConfig.searchProductsPriceRangeMin;
    priceEnd = FilterConfig.searchProductsPriceRangeMax;
    searchFilters = const WooStoreFilters();
    applyFilters = false;

    /// Set the state to loading for next access
    state = ViewState.CUSTOM_MESSAGE;

    // Function Log
    Dev.debugFunction(
      functionName: 'reset',
      className: 'SearchViewModel',
      fileName: 'searchViewModel.dart',
      start: false,
    );
  }

  //**********************************************************
  //  Data Holders
  //**********************************************************

  /// Term to define what is being searched
  String _searchTerm = '';

  String get searchTerm => _searchTerm;

  set setSearchTerm(String value) {
    _searchTerm = value;
  }

  /// Hold the search list data
  List<String> _searchProductsList = [];

  List<String> get searchProductsList => _searchProductsList;

  /// This getter depends on `CategoriesProvider` to get the categories
  /// for the Filter modal
  Map<WooProductCategory, List<WooProductCategory>> get categoriesMap =>
      LocatorService.categoriesProvider().categoriesMap;

  /// Getter for tags for filtering
  List<WooProductTag> get tags => LocatorService.tagsViewModel().tags;

  /// The filters holder
  WooStoreFilters get searchFilters => filters;
  set searchFilters(WooStoreFilters newFilters) {
    filters = newFilters;
  }

  //**********************************************************
  //  Public Functions
  //**********************************************************

  /// Fetch the data based on the search term
  Future<void> fetchData() async {
    if (searchTerm == null || searchTerm.isEmpty) {
      return;
    }

    // If the filters are to be applied, fetch data with filter function
    if (applyFilters) {
      await fetchDataWithFilter();
      return;
    }

    // Function Log
    Dev.debugFunction(
      functionName: 'fetchData',
      className: 'SearchViewModel',
      fileName: 'searchProvider.dart',
      start: true,
    );

    try {
      notifyLoading();
      final result = await LocatorService.wooService().wc.getProducts(
            search: searchTerm,
            page: 1,
            perPage: FilterConfig.searchProductsSearchPerPage,
          );

      if (result == null) {
        notifyState(ViewState.NO_DATA_AVAILABLE);
      } else {
        if (result.isEmpty) {
          notifyState(ViewState.NO_DATA_AVAILABLE);
        } else {
          // If result is not empty then process the data
          _searchProductsList = _processRawData(result);
          notifyState(ViewState.DATA_AVAILABLE);
        }
      }

      // Function Log
      Dev.debugFunction(
        functionName: 'fetchData',
        className: 'SearchViewModel',
        fileName: 'searchProvider.dart',
        start: false,
      );
    } catch (e) {
      Dev.error('Fetch data SearchViewModel error', error: e);
      if (_searchProductsList.isEmpty) {
        notifyError();
      } else {
        notifyState(ViewState.DATA_AVAILABLE);
      }
    }
  }

  /// Fetch the data based on the search term
  Future<FetchActionResponse> fetchMoreData({
    int page = 2,
  }) async {
    // If the filters are to be applied, fetch data with filter function
    if (applyFilters) {
      return await fetchMoreDataWithFilter(
        page: page,
      );
    }

    // Function Log
    Dev.debugFunction(
      functionName: 'fetchMoreData',
      className: 'SearchViewModel',
      fileName: 'searchProvider.dart',
      start: true,
    );

    try {
      final result = await LocatorService.wooService().wc.getProducts(
            search: searchTerm,
            perPage: FilterConfig.searchProductsSearchPerPage,
            page: page,
          );

      // Function Log
      Dev.debugFunction(
        functionName: 'fetchMoreData',
        className: 'SearchViewModel',
        fileName: 'searchProvider.dart',
        start: false,
      );

      if (result == null) {
        return FetchActionResponse.Failed;
      } else {
        if (result.isEmpty) {
          return FetchActionResponse.NoDataAvailable;
        } else {
          // If result is not empty then process the data
          if (result.length < FilterConfig.searchProductsSearchPerPage) {
            // If result is less than the requested length, then
            // this is the last lot of data.
            _searchProductsList.addAll(_processRawData(result));
            return FetchActionResponse.LastData;
          } else {
            // If result is not empty then process the data
            _searchProductsList.addAll(_processRawData(result));
            return FetchActionResponse.Successful;
          }
        }
      }
    } catch (e, s) {
      Dev.error(
        'Fetch more data error',
        error: e,
        stackTrace: s,
      );
      return FetchActionResponse.Failed;
    }
  }

  /// Fetch the data based on the filter and search term
  Future<void> fetchDataWithFilter() async {
    if (searchTerm == null || searchTerm.isEmpty) {
      return;
    }

    // Function Log
    Dev.debugFunction(
      functionName: 'fetchDataWithFilter',
      className: 'SearchViewModel',
      fileName: 'searchViewModel.dart',
      start: true,
    );
    try {
      String _category = '';
      if (searchFilters.parentCategory != null &&
          searchFilters.parentCategory.id != null) {
        _category = searchFilters.parentCategory.id.toString();
      }

      if (searchFilters.childCategory != null &&
          searchFilters.childCategory.id != null) {
        _category = searchFilters.childCategory.id.toString();
      }

      notifyLoading();

      final result = await LocatorService.wooService().wc.getProducts(
            search: searchTerm,
            category: _category ?? '',
            tag: searchFilters.tag != null && searchFilters.tag.id != null
                ? searchFilters.tag.id.toString()
                : '',
            minPrice: priceStart.toString(),
            maxPrice: priceEnd.toString(),
            status: 'publish',
            stockStatus: searchFilters.inStock ? 'instock' : null,
            onSale: searchFilters.onSale ? searchFilters.onSale : null,
            featured: searchFilters.featured ? searchFilters.featured : null,
            orderBy:
                WooUtils.convertSortOptionToString(searchFilters.sortOption),
            order: WooUtils.setSortOrder(searchFilters.sortOption),
            taxonomyQuery: await searchFilters.buildTaxonomyQuery(),
          );

      if (result == null) {
        notifyError();
      } else {
        if (result.isEmpty) {
          notifyState(ViewState.NO_DATA_AVAILABLE);
        } else {
          // If result is not empty then process the data
          _searchProductsList = _processRawData(result);
          notifyState(ViewState.DATA_AVAILABLE);
        }
      }
      // Function Log
      Dev.debugFunction(
        functionName: 'fetchDataWithFilter',
        className: 'SearchViewModel',
        fileName: 'searchViewModel.dart',
        start: false,
      );
    } catch (e, s) {
      Dev.error(
        'Fetch Data with filters',
        error: e,
        stackTrace: s,
      );
      notifyError(message: e.toString());
    }
  }

  /// Fetch more data based on the filter and search term
  Future<FetchActionResponse> fetchMoreDataWithFilter({
    int page = 1,
  }) async {
    // Function Log
    Dev.debugFunction(
      functionName: 'fetchMoreDataWithFilter',
      className: 'SearchViewModel',
      fileName: 'searchViewModel.dart',
      start: true,
    );
    try {
      String _category = '';
      if (searchFilters.parentCategory != null &&
          searchFilters.parentCategory.id != null) {
        _category = searchFilters.parentCategory.id.toString();
      }

      if (searchFilters.childCategory != null &&
          searchFilters.childCategory.id != null) {
        _category = searchFilters.childCategory.id.toString();
      }

      final result = await LocatorService.wooService().wc.getProducts(
            search: searchTerm,
            category: _category ?? '',
            tag: searchFilters.tag != null && searchFilters.tag.id != null
                ? searchFilters.tag.id.toString()
                : '',
            minPrice: priceStart.toString(),
            maxPrice: priceEnd.toString(),
            perPage: FilterConfig.searchProductsSearchPerPage,
            page: page,
            status: 'publish',
            stockStatus: searchFilters.inStock ? 'instock' : null,
            onSale: searchFilters.onSale ? searchFilters.onSale : null,
            featured: searchFilters.featured ? searchFilters.featured : null,
            orderBy:
                WooUtils.convertSortOptionToString(searchFilters.sortOption),
            order: WooUtils.setSortOrder(searchFilters.sortOption),
            taxonomyQuery: await searchFilters.buildTaxonomyQuery(),
          );

      // Function Log
      Dev.debugFunction(
        functionName: 'fetchMoreDataWithFilter',
        className: 'SearchViewModel',
        fileName: 'searchViewModel.dart',
        start: false,
      );

      if (result == null) {
        return FetchActionResponse.Failed;
      } else {
        if (result.isEmpty) {
          return FetchActionResponse.NoDataAvailable;
        } else {
          // If result is not empty then process the data
          if (result.length < FilterConfig.searchProductsSearchPerPage) {
            // If result is less than the requested length, then
            // this is the last lot of data.
            _searchProductsList.addAll(_processRawData(result));
            return FetchActionResponse.LastData;
          } else {
            // If result is not empty then process the data
            _searchProductsList.addAll(_processRawData(result));
            return FetchActionResponse.Successful;
          }
        }
      }
    } catch (e, s) {
      Dev.error(
        'Fetch More data with filters',
        error: e,
        stackTrace: s,
      );
      return FetchActionResponse.Failed;
    }
  }

  //**********************************************************
  //  Helpers
  //**********************************************************

  /// Process the product data list and returns a list of product's ids and adds
  /// them to the all products map in products provider for liking and other
  /// local stuff.
  @protected
  List<String> _processRawData(List<WooProduct> productsDataList) {
    // Function Log
    Dev.debugFunction(
      functionName: '_processRawData',
      className: 'SearchViewModel',
      fileName: 'searchProvider.dart',
      start: true,
    );
    final List<String> result = [];
    if (productsDataList.isNotEmpty) {
      for (var i = 0; i < productsDataList.length; i++) {
        if (_searchProductsList.contains(productsDataList[i].id.toString())) {
          result.add(productsDataList[i].id.toString());
          continue;
        }
        final Product p = Product.fromWooProduct(productsDataList[i]);
        result.add(p.id.toString());
        LocatorService.productsProvider().addToMap(p);
      }
    }
    // Function Log
    Dev.debugFunction(
      functionName: '_processRawData',
      className: 'SearchViewModel',
      fileName: 'searchProvider.dart',
      start: false,
    );
    return result;
  }
}
