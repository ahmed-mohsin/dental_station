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
import 'package:quiver/strings.dart';
import 'package:woocommerce/woocommerce.dart';

import '../../../../../developer/dev.log.dart';
import '../../../../../locator.dart';
import '../../../../../shared/customLoader.dart';
import '../../../../../shared/widgets/error/errorReload.dart';
import '../../../../../utils/utils.dart';
import '../../../models/customSectionData.dart';
import 'layouts/grid.dart';
import 'layouts/list.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({Key key, this.sectionData}) : super(key: key);
  final CategoriesSectionData sectionData;

  @override
  _CategoriesSectionState createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  List<WooProductCategory> list = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    if (widget.sectionData.fullResponseCategories != null &&
        widget.sectionData.fullResponseCategories.isNotEmpty) {
      isLoading = false;
      error = '';
      list = widget.sectionData.fullResponseCategories;
    } else {
      _getCategoryList();
    }
  }

  /// Get the full response of the product categories
  Future<void> _getCategoryList() async {
    try {
      if (mounted) {
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
        }
      }

      final List<int> value =
          widget.sectionData.categories.map((e) => e.id).toList();

      final result = await LocatorService.wooService()
          .wc
          .getProductCategories(include: value);

      if (result == null || result.isEmpty) {
        Dev.warn('Get full category response list is null or empty');
        if (mounted) {
          setState(() {
            isLoading = false;
            error = '';
          });
        }
      }

      widget.sectionData.update(result);
      if (mounted) {
        setState(() {
          list = result;
          isLoading = false;
          error = '';
        });
      }
    } catch (e, s) {
      Dev.error('Get full category list', error: e, stackTrace: s);
      if (mounted) {
        setState(() {
          isLoading = false;
          error = Utils.renderException(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LimitedBox(
        maxHeight: 100,
        child: Center(
          child: CustomLoader(),
        ),
      );
    }

    if (isNotBlank(error)) {
      return ErrorReload(
        errorMessage: error,
        reloadFunction: _getCategoryList,
      );
    }

    if (list.isEmpty) {
      return const SizedBox();
    }

    if (widget.sectionData.layout == SectionLayout.grid) {
      return CategoriesSectionHomeGridLayout(sectionData: widget.sectionData);
    }

    if (widget.sectionData.layout == SectionLayout.list) {
      return CategoriesSectionHomeListLayout(sectionData: widget.sectionData);
    }

    return CategoriesSectionHomeListLayout(sectionData: widget.sectionData);
  }
}
