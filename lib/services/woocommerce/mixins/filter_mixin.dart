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

import 'package:flutter/foundation.dart';
import 'package:quiver/strings.dart';

import '../../../constants/config.dart';
import '../../../developer/dev.log.dart';
import '../../../locator.dart';
import '../woocommerce.service.dart';

mixin WooFiltersMixin on ChangeNotifier {
  /// The filters holder
  WooStoreFilters filters = const WooStoreFilters();

  /// Flag to check if the filters are to be applied in the fetch requests
  bool applyFilters = false;

  /// The prices to start and end with
  double priceStart, priceEnd = 0.0;

  /// Clear all the filters selected
  void clearFilters() {
    filters = const WooStoreFilters();
    filters = filters.copyWith(
      minPrice: priceStart,
      maxPrice: priceEnd,
    );
    applyFilters = false;
    // notifyListeners();

    performAfterCategoryChangeActionsAndNotify();
  }

  /// Set the price range for the search and notifies the listener.
  void setPriceRange({
    @required double start,
    @required double end,
  }) {
    applyFilters = true;
    filters = filters.copyWith(minPrice: start, maxPrice: end);
    notifyListeners();
  }

  /// Select the parent and based on the choice populate the
  /// child list.
  void setParentCategory(WooProductCategory parentCategory) {
    if (parentCategory == null) {
      return;
    }
    filters = filters.copyWith(
      parentCategory: parentCategory,
      childCategory: const WooProductCategory(),
    );
    applyFilters = true;
    // notifyListeners();

    performAfterCategoryChangeActionsAndNotify();
  }

  /// Set the child category in the state and searchProvider
  void setChildCategory(WooProductCategory childCategory) {
    if (childCategory?.id == filters.childCategory?.id) {
      filters = filters.copyWith(childCategory: const WooProductCategory());
    } else {
      filters = filters.copyWith(childCategory: childCategory);
    }
    applyFilters = true;
    // notifyListeners();

    performAfterCategoryChangeActionsAndNotify();
  }

  /// Perform after category change functions
  void performAfterCategoryChangeActionsAndNotify() {
    fetchProductAttributes();
    fetchProductMinMaxPrices(buildSelectedCatIds().toList());
  }

  void setSortOption(SortOption option) {
    applyFilters = true;
    filters = filters.copyWith(sortOption: option);
    notifyListeners();
  }

  /// Apply the onSale flag as a filter
  void toggleOnSaleFlag(bool value) {
    if (value == null) {
      return;
    }
    applyFilters = true;
    filters = filters.copyWith(onSale: value);
    notifyListeners();
  }

  /// Apply the inStock flag as a filter
  void toggleInStockFlag(bool value) {
    if (value == null) {
      return;
    }
    applyFilters = true;
    filters = filters.copyWith(inStock: value);
    notifyListeners();
  }

  /// Apply the featured flag as a filter
  void toggleFeaturedFlag(bool value) {
    if (value == null) {
      return;
    }
    applyFilters = true;
    filters = filters.copyWith(featured: value);
    notifyListeners();
  }

  /// Set the tag passed as the filter tag option
  void setTag(WooProductTag tag) {
    if (tag == null) {
      return;
    }
    if (tag?.id == filters.tag?.id) {
      filters = filters.copyWith(tag: const WooProductTag());
    } else {
      filters = filters.copyWith(tag: tag);
    }

    applyFilters = true;
    notifyListeners();
  }

  /// Set the taxonomy query
  void setTaxonomyQuery(WooProductTaxonomyQuery query) {
    if (filters.taxonomyQueryList?.contains(query) ?? false) {
      // Check if the selected term.termId is available in the
      // query term list
      final temp = List<WooProductTaxonomyQuery>.from(filters.taxonomyQueryList)
        ..remove(query);
      filters = filters.copyWith(
        taxonomyQueryList: temp,
      );
    } else {
      filters = filters.copyWith(
        taxonomyQueryList: [...filters.taxonomyQueryList, query],
      );
    }
    applyFilters = true;
    // notifyListeners();

    performAfterCategoryChangeActionsAndNotify();
  }

  //**********************************************************
  // Core Functions
  //**********************************************************

  bool isPALoading = true;
  bool showPAOverlayLoading = false;
  bool isPAError = false;
  bool hasPAData = false;

  List<WooStoreProductAttribute> paList = const [];

  /// Fetch the product attributes based on the taxonomyQuery
  Future<List<WooStoreProductAttribute>> fetchProductAttributes(
      [String taxonomyQuery]) async {
    // Function Log
    Dev.debugFunction(
      functionName: 'fetchProductAttributes',
      className: 'WooFiltersMixin',
      fileName: 'filter_mixin.dart',
      start: true,
    );
    try {
      showPAOverlayLoading = true;
      notifyListeners();

      String endpoint = 'products/attributes';
      if (isNotBlank(taxonomyQuery)) {
        endpoint = endpoint + '?attrs=$taxonomyQuery';
      } else {
        final tempTaxonomyQuery = await filters.buildTaxonomyQuery();
        endpoint = endpoint + '?attrs=$tempTaxonomyQuery';
      }

      final response = await wooCommerce.get(endpoint);

      if (response == null) {
        isPALoading = false;
        showPAOverlayLoading = false;
        hasPAData = true;
        paList = const [];
        notifyListeners();
        return const [];
      }
      final List<WooStoreProductAttribute> result = [];
      for (final elem in response) {
        result.add(WooStoreProductAttribute.fromJson(elem));
      }

      // Function Log
      Dev.debugFunction(
        functionName: 'fetchProductAttributes',
        className: 'WooFiltersMixin',
        fileName: 'filter_mixin.dart',
        start: false,
      );

      isPALoading = false;
      showPAOverlayLoading = false;
      hasPAData = true;
      paList = result;
      notifyListeners();
      return result;
    } catch (e, s) {
      Dev.error('fetchProductAttributes', error: e, stackTrace: s);
      isPALoading = false;
      showPAOverlayLoading = false;
      hasPAData = false;
      isPAError = true;
      paList = const [];
      notifyListeners();
      return const [];
    }
  }

  bool isPMMPLoading = true;
  bool isPMMPError = false;
  bool hasPMMPData = false;

  /// Fetch the product attributes based on the taxonomyQuery
  Future<Map<String, dynamic>> fetchProductMinMaxPrices(
      List<String> categoryIds) async {
    // Function Log
    Dev.debugFunction(
      functionName: 'fetchProductMinMaxPrices',
      className: 'WooFiltersMixin',
      fileName: 'filter_mixin.dart',
      start: true,
    );
    try {
      isPMMPLoading = true;
      notifyListeners();

      final result = await LocatorService.wooService()
          .wc
          .getProductFilterMinMaxPrices(categoryIds);
      priceStart = double.tryParse(result['min_price']?.toString() ?? '0.0');
      priceEnd =
          double.tryParse(result['max_price']?.toString() ?? '10000000.0');

      if (filters.minPrice == null || filters.maxPrice == null) {
        filters = filters.copyWith(
          minPrice: priceStart,
          maxPrice: priceEnd,
        );
      }

      isPMMPLoading = false;
      isPMMPError = false;
      hasPMMPData = true;
      notifyListeners();
      return result;
    } catch (e, s) {
      Dev.error('fetchProductMinMaxPrices', error: e, stackTrace: s);
      priceStart = FilterConfig.defaultPriceRangeMin;
      priceEnd = FilterConfig.defaultPriceRangeMax;

      filters = filters.copyWith(
        minPrice: priceStart,
        maxPrice: priceEnd,
      );
      isPMMPLoading = false;
      isPMMPError = true;
      hasPMMPData = false;
      notifyListeners();
      return const {};
    }
  }

  int buildPriceRangeDivisions(double priceEnd, double priceStart) {
    try {
      return priceEnd ~/ priceStart;
    } catch (e, s) {
      Dev.error('Cannot build divisions', error: e, stackTrace: s);
      return FilterConfig.defaultPriceRangeDivisions;
    }
  }

  Set<String> buildSelectedCatIds() {
    final Set<String> catIds = {};

    if (filters.parentCategory?.id != null && filters.parentCategory.id > 0) {
      catIds.add(filters.parentCategory.id.toString());
    }

    if (filters.childCategory?.id != null && filters.childCategory.id > 0) {
      catIds.add(filters.childCategory.id.toString());
    }
    return catIds;
  }
}
