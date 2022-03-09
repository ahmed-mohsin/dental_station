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
import '../../../utils/utils.dart';
import '../../home/viewModel/homeSection.viewModel.dart';

export '../../../services/woocommerce/woocommerce.service.dart';

class AllProductsViewModel extends BaseProvider with WooFiltersMixin {
  AllProductsViewModel(this.provider) {
    // Function Log
    Dev.debugFunction(
      functionName: 'AllProductsViewModel constructor',
      className: 'AllProductsViewModel',
      fileName: 'allProductsViewModel.dart',
      start: true,
    );
    // Get the list from tags provider list for a start
    _productsList = List.from(provider.productsList);
    state = provider.state;
    // Function Log
    Dev.debugFunction(
      functionName: 'AllProductsViewModel constructor',
      className: 'AllProductsViewModel',
      fileName: 'allProductsViewModel.dart',
      start: false,
    );
  }

  //**********************************************************
  //  Data Holders
  //**********************************************************

  /// The provider to get the data from
  HomeSectionViewModel provider;

  /// Hold the search list data
  List<String> _productsList = [];

  List<String> get productsList => _productsList;

  /// This getter depends on `CategoriesProvider` to get the categories
  /// for the Filter modal
  Map<WooProductCategory, List<WooProductCategory>> get categoriesMap =>
      _getCategoriesMap();

  /// Contains the product tags to choose while filtering.
  List<WooProductTag> _tags = LocatorService.tagsViewModel().tags;

  /// Getter for tags for filtering
  List<WooProductTag> get tags => _tags;

  //**********************************************************
  //  Public Functions
  //**********************************************************

  @override
  void dispose() {
    // Function Log
    Dev.debugFunction(
      functionName: 'dispose',
      className: 'AllProductsViewModel',
      fileName: 'allProductsViewModel.dart',
      start: true,
    );

    _productsList = null;
    filters = null;
    applyFilters = null;

    /// Set the state to loading for next access
    state = null;

    // Function Log
    Dev.debugFunction(
      functionName: 'dispose',
      className: 'AllProductsViewModel',
      fileName: 'allProductsViewModel.dart',
      start: false,
    );

    super.dispose();
  }

  /// Returns the dynamic title for the View
  String getTitle() {
    try {
      if (provider != null) {
        if (provider.productTag != null &&
            provider.productTag.name != null &&
            provider.productTag.name.isNotEmpty) {
          return Utils.capitalize(provider.productTag.name);
        } else {
          if (provider.productCategory != null &&
              provider.productCategory.name != null &&
              provider.productCategory.name.isNotEmpty) {
            return Utils.capitalize(provider.productCategory.name);
          }
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  /// Fetch the data based on the search term
  Future<void> fetchData() async {
    // If the filters are to be applied, fetch data with filter function
    if (applyFilters) {
      await fetchDataWithFilter();
      return;
    }

    // Function Log
    Dev.debugFunction(
      functionName: 'fetchData',
      className: 'AllProductsViewModel',
      fileName: 'allProductsViewModel.dart',
      start: true,
    );

    try {
      notifyLoading();

      final result = await provider.fetchProducts();

      if (result == null) {
        notifyState(ViewState.NO_DATA_AVAILABLE);
      } else {
        if (result == FetchActionResponse.NoDataAvailable) {
          notifyState(ViewState.NO_DATA_AVAILABLE);
        } else {
          // If result is not empty then process the data
          _productsList = List.from(provider.productsList);
          notifyState(ViewState.DATA_AVAILABLE);
        }
      }

      // Function Log
      Dev.debugFunction(
        functionName: 'fetchData',
        className: 'AllProductsViewModel',
        fileName: 'allProductsViewModel.dart',
        start: false,
      );
    } catch (e) {
      Dev.error('Fetch data AllProductsViewModel error', error: e);
      if (_productsList.isEmpty) {
        notifyError(message: Utils.renderException(e));
      } else {
        notifyState(ViewState.DATA_AVAILABLE);
      }
    }
  }

  /// Fetch the data based on the search term
  Future<FetchActionResponse> fetchMoreData({int page = 2}) async {
    // If the filters are to be applied, fetch data with filter function
    if (applyFilters) {
      return await fetchMoreDataWithFilter(page: page);
    }

    // Function Log
    Dev.debugFunction(
      functionName: 'fetchMoreData',
      className: 'AllProductsViewModel',
      fileName: 'allProductsViewModel.dart',
      start: true,
    );

    try {
      final result = await LocatorService.wooService().wc.getProducts(
            perPage: FilterConfig.allProductsSearchPerPage,
            page: page,
            tag: provider.productTag != null
                ? provider.productTag.id.toString()
                : '',
            category: provider.productCategory != null
                ? provider.productCategory.id.toString()
                : '',
          );

      // Function Log
      Dev.debugFunction(
        functionName: 'fetchMoreData',
        className: 'AllProductsViewModel',
        fileName: 'allProductsViewModel.dart',
        start: false,
      );

      if (result == null) {
        return FetchActionResponse.Failed;
      } else {
        if (result.isEmpty) {
          return FetchActionResponse.NoDataAvailable;
        } else {
          // If result is not empty then process the data
          if (result.length < FilterConfig.allProductsSearchPerPage) {
            // If result is less than the requested length, then
            // this is the last lot of data.
            _productsList.addAll(_processRawData(result));
            return FetchActionResponse.LastData;
          } else {
            // If result is not empty then process the data
            _productsList.addAll(_processRawData(result));
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
    // Function Log
    Dev.debugFunction(
      functionName: 'fetchDataWithFilter',
      className: 'AllProductsViewModel',
      fileName: 'allProductsViewModel.dart',
      start: true,
    );
    try {
      String _category = '';
      if (filters.parentCategory != null && filters.parentCategory.id != null) {
        _category = filters.parentCategory.id.toString();
      }

      if (filters.childCategory != null && filters.childCategory.id != null) {
        _category = filters.childCategory.id.toString();
      }

      notifyLoading();

      final result = await LocatorService.wooService().wc.getProducts(
            category: _category ?? '',
            tag: provider.productTag != null
                ? provider.productTag.id.toString()
                : '',
            minPrice: filters.minPrice?.toString(),
            maxPrice: filters.maxPrice?.toString(),
            status: 'publish',
            page: 1,
            perPage: FilterConfig.allProductsSearchPerPage,
            stockStatus: filters.inStock ? 'instock' : null,
            onSale: filters.onSale ? filters.onSale : null,
            featured: filters.featured ? filters.featured : null,
            orderBy: WooUtils.convertSortOptionToString(filters.sortOption),
            order: WooUtils.setSortOrder(filters.sortOption),
            taxonomyQuery: await filters.buildTaxonomyQuery(),
          );

      if (result == null) {
        notifyError(message: null);
      } else {
        if (result.isEmpty) {
          notifyState(ViewState.NO_DATA_AVAILABLE);
        } else {
          // If result is not empty then process the data
          _productsList = _processRawData(result);
          notifyState(ViewState.DATA_AVAILABLE);
        }
      }
      // Function Log
      Dev.debugFunction(
        functionName: 'fetchDataWithFilter',
        className: 'AllProductsViewModel',
        fileName: 'allProductsViewModel.dart',
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
  Future<FetchActionResponse> fetchMoreDataWithFilter({int page = 2}) async {
    // Function Log
    Dev.debugFunction(
      functionName: 'fetchMoreDataWithFilter',
      className: 'AllProductsViewModel',
      fileName: 'allProductsViewModel.dart',
      start: true,
    );
    try {
      String _category = '';
      if (filters.parentCategory != null && filters.parentCategory.id != null) {
        _category = filters.parentCategory.id.toString();
      }

      if (filters.childCategory != null && filters.childCategory.id != null) {
        _category = filters.childCategory.id.toString();
      }

      final result = await LocatorService.wooService().wc.getProducts(
            category: _category ?? '',
            tag: provider.productTag != null
                ? provider.productTag.id.toString()
                : '',
            minPrice: filters.minPrice?.toString(),
            maxPrice: filters.maxPrice?.toString(),
            perPage: FilterConfig.allProductsSearchPerPage,
            page: page,
            status: 'publish',
            stockStatus: filters.inStock ? 'instock' : null,
            onSale: filters.onSale ? filters.onSale : null,
            featured: filters.featured ? filters.featured : null,
            orderBy: WooUtils.convertSortOptionToString(filters.sortOption),
            order: WooUtils.setSortOrder(filters.sortOption),
            taxonomyQuery: await filters.buildTaxonomyQuery(),
          );

      // Function Log
      Dev.debugFunction(
        functionName: 'fetchMoreDataWithFilter',
        className: 'AllProductsViewModel',
        fileName: 'allProductsViewModel.dart',
        start: false,
      );

      if (result == null) {
        return FetchActionResponse.Failed;
      } else {
        if (result.isEmpty) {
          return FetchActionResponse.NoDataAvailable;
        } else {
          // If result is not empty then process the data
          if (result.length < FilterConfig.allProductsSearchPerPage) {
            // If result is less than the requested length, then
            // this is the last lot of data.
            _productsList.addAll(_processRawData(result));
            return FetchActionResponse.LastData;
          } else {
            // If result is not empty then process the data
            _productsList.addAll(_processRawData(result));
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

  /// Set the tags list to the new provided list
  void setTagsList(List<WooProductTag> tagsList) {
    if (tagsList == null) {
      return;
    }
    _tags = tagsList;
  }

  //**********************************************************
  //  Helpers
  //**********************************************************

  /// Set the categories map based on the type of section data being displayed.
  /// Takes into account the selected [provider.productsCategory]
  Map<WooProductCategory, List<WooProductCategory>> _getCategoriesMap() {
    // Function Log
    Dev.debugFunction(
      functionName: '_getCategoriesMap',
      className: 'AllProductsViewModel',
      fileName: 'allProductsViewModel.dart',
      start: true,
    );

    var result = LocatorService.categoriesProvider().categoriesMap;

    if (provider != null) {
      if (provider.productCategory != null &&
          provider.productCategory.id != null) {
        // If the product category is present, then show only that category
        // as the selected category.

        // Find the matching category from the map
        if (result != null) {
          // If the target category a PARENT category
          final targetParentCategory = result.keys.firstWhere(
            (element) => element.id == provider.productCategory.id,
            orElse: () => null,
          );
          // If the target category is found then update the result category map
          if (targetParentCategory != null) {
            result = {targetParentCategory: result[targetParentCategory]};
            filters = filters.copyWith(parentCategory: targetParentCategory);
          } else {
            // If the target category is NOT found then set it as the only
            // category option available
            result = {provider.productCategory: const []};
            filters =
                filters.copyWith(parentCategory: provider.productCategory);
          }
        }
      }
    }
    // Function Log
    Dev.debugFunction(
      functionName: '_getCategoriesMap',
      className: 'AllProductsViewModel',
      fileName: 'allProductsViewModel.dart',
      start: false,
    );

    return result;
  }

  /// Process the product data list and returns a list of product's ids and adds
  /// them to the all products map in products provider for liking and other
  /// local stuff.
  @protected
  List<String> _processRawData(List<WooProduct> productsDataList) {
    // Function Log
    Dev.debugFunction(
      functionName: '_processRawData',
      className: 'AllProductsViewModel',
      fileName: 'allProductsViewModel.dart',
      start: true,
    );
    final List<String> result = [];
    if (productsDataList.isNotEmpty) {
      for (var i = 0; i < productsDataList.length; i++) {
        if (_productsList?.contains(productsDataList[i].id.toString()) ??
            false) {
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
      className: 'AllProductsViewModel',
      fileName: 'allProductsViewModel.dart',
      start: false,
    );
    return result;
  }
}
