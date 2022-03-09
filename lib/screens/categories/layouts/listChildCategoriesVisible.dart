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

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../../controllers/navigationController.dart';
import '../../../generated/l10n.dart';
import '../../../locator.dart';
import '../../../services/woocommerce/woocommerce.service.dart';
import '../../../shared/image/extendedCachedImage.dart';
import '../../../shared/widgets/error/noDataAvailable.dart';
import '../../../themes/theme.dart';
import '../../../themes/themeGuide.dart';
import '../models/ParentChildCategoryModel.dart';

class CSListChildCategoriesVisibleLayout extends StatelessWidget {
  const CSListChildCategoriesVisibleLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = LocatorService.categoriesProvider().getCategoriesAsModels();

    if (list == null || list.isEmpty) {
      return const NoDataAvailableImage();
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: ThemeGuide.listPadding,
      itemCount: list.length,
      itemBuilder: (context, i) {
        return _ListItem(model: list[i]);
      },
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    Key key,
    @required this.model,
  }) : super(key: key);

  final ParentChildCategoryModel model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: ThemeGuide.padding10,
      margin: ThemeGuide.marginV10,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: ThemeGuide.borderRadius10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              NavigationController.navigator.push(
                CategorisedProductsRoute(
                  category: model.parentCategory,
                  searchCategory: model.parentCategory,
                  childrenCategoryList: model.childrenCategories,
                ),
              );
            },
            child: Container(
              padding: ThemeGuide.padding10,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: ThemeGuide.borderRadius10,
              ),
              child: Row(
                children: [
                  Container(
                    margin: ThemeGuide.margin10,
                    height: 50,
                    width: 50,
                    child: ExtendedCachedImage(
                      imageUrl: model?.parentCategory?.image?.src,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      model?.parentCategory?.name ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (model.childrenCategories != null &&
              model.childrenCategories.isNotEmpty)
            const SizedBox(height: 10),
          if (model.childrenCategories != null &&
              model.childrenCategories.isNotEmpty)
            ExpandablePanel(
              theme: ThemeGuide.isDarkMode(context)
                  ? const ExpandableThemeData(
                      hasIcon: true,
                      iconColor: Colors.white,
                    )
                  : const ExpandableThemeData(
                      hasIcon: true,
                      iconColor: Colors.black,
                    ),
              collapsed: const SizedBox(),
              header: Container(
                height: 40,
                padding: ThemeGuide.marginH10,
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).categories,
                  style: TextStyle(
                    color: ThemeGuide.isDarkMode(context)
                        ? Colors.white70
                        : Colors.black45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              expanded: SingleChildScrollView(
                padding: ThemeGuide.marginV10,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: model.childrenCategories
                      .map((e) => _GridChildListItem(category: e, model: model))
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GridChildListItem extends StatelessWidget {
  const _GridChildListItem({
    Key key,
    @required this.category,
    @required this.model,
  }) : super(key: key);

  final WooProductCategory category;
  final ParentChildCategoryModel model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        NavigationController.navigator.push(
          CategorisedProductsRoute(
            category: model.parentCategory,
            childrenCategoryList: model.childrenCategories,
            searchCategory: category,
          ),
        );
      },
      child: Container(
        height: 100,
        width: 100,
        padding: ThemeGuide.padding10,
        margin: ThemeGuide.marginH5,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: ThemeGuide.borderRadius10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: ExtendedCachedImage(
                imageUrl: category?.image?.src,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Text(
                category?.name ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
