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

part of 'models.dart';

/// A data object class for search filters for the woocommerce
/// store
@immutable
class WooStoreFilters {
  /// Category which has sub categories
  final WooProductCategory parentCategory;

  /// Category which has a parent category
  final WooProductCategory childCategory;
  final WooProductTag tag;
  final bool onSale;
  final bool inStock;
  final bool featured;
  final SortOption sortOption;
  final List<WooProductTaxonomyQuery> taxonomyQueryList;
  final double minPrice, maxPrice;

  const WooStoreFilters({
    this.parentCategory,
    this.childCategory,
    this.tag,
    this.onSale = false,
    this.inStock = false,
    this.featured = false,
    this.sortOption = SortOption.latest,
    this.taxonomyQueryList = const [],
    this.minPrice,
    this.maxPrice,
  });

  /// Builds the Taxonomy query for the search filters
  Future<String> buildTaxonomyQuery() async {
    final Map<String, List<int>> tempMap = {};
    for (final e in taxonomyQueryList) {
      if (tempMap.containsKey(e.taxonomySlug)) {
        // add the new term id to the list of taxonomy slug
        final List<int> termIds = tempMap[e.taxonomySlug];
        // if the term id is already present then remove it
        // else add it to the list
        if (termIds.contains(e.termId)) {
          termIds.remove(e.termId);
          // If the list is empty then remove the taxonomy entry
          // altogether
          if (termIds.isEmpty) {
            tempMap.remove(e.taxonomySlug);
          }
        } else {
          termIds.add(e.termId);
        }
      } else {
        tempMap.addAll({
          e.taxonomySlug: [e.termId]
        });
      }
    }

    final List<Map<String, dynamic>> resultQueryList = [];
    tempMap.forEach((key, value) {
      resultQueryList.add({
        'taxonomy': key,
        'terms': value,
        'field': 'term_id',
      });
    });

    if (parentCategory != null || childCategory != null) {
      final List<int> _catIds = [];

      if (parentCategory.id != null && parentCategory.id > 0) {
        _catIds.add(parentCategory.id);
      }

      if (childCategory.id != null && childCategory.id > 0) {
        _catIds.add(childCategory.id);
      }

      resultQueryList.add({
        'taxonomy': 'product_cat',
        'field': 'cat_id',
        'terms': _catIds,
      });
    }

    return await compute(jsonEncode, resultQueryList);
  }

  WooStoreFilters copyWith({
    WooProductCategory parentCategory,
    WooProductCategory childCategory,
    WooProductTag tag,
    bool onSale,
    bool inStock,
    bool featured,
    SortOption sortOption,
    List<WooProductTaxonomyQuery> taxonomyQueryList,
    double minPrice,
    double maxPrice,
  }) {
    return WooStoreFilters(
      parentCategory: parentCategory ?? this.parentCategory,
      childCategory: childCategory ?? this.childCategory,
      tag: tag ?? this.tag,
      onSale: onSale ?? this.onSale,
      inStock: inStock ?? this.inStock,
      featured: featured ?? this.featured,
      sortOption: sortOption ?? this.sortOption,
      taxonomyQueryList: taxonomyQueryList ?? this.taxonomyQueryList,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentCategory': parentCategory,
      'childCategory': childCategory,
      'tag': tag,
      'onSale': onSale,
      'inStock': inStock,
      'featured': featured,
      'sortOption': sortOption,
      'taxonomyQueryList': taxonomyQueryList,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
    };
  }
}
