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
import 'package:provider/provider.dart';
import 'package:woocommerce/woocommerce.dart';

import '../../../../../constants/config.dart';
import '../../../../../controllers/navigationController.dart';
import '../../../../../controllers/uiController.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../locator.dart';
import '../../../../../providers/utils/viewStateController.dart';
import '../../../../../shared/image/extendedCachedImage.dart';
import '../../../../../themes/theme.dart';
import '../../../viewModel/categories.provider.dart';

/// Name: Categories Home Screen Horizontal Layout
/// Horizontal list for categories in the Home screen
class CHSGridLayout extends StatelessWidget {
  const CHSGridLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: LocatorService.categoriesProvider(),
      child: SliverViewStateController<CategoriesProvider>(
        fetchData: LocatorService.categoriesProvider().getCategories,
        builder: () {
          return Selector<CategoriesProvider,
              Map<WooProductCategory, List<WooProductCategory>>>(
            selector: (context, d) => d.categoriesMap,
            builder: (context, value, w) {
              final List<Widget> childrenList = [];

              value.forEach((key, value) {
                childrenList.add(_RowItem(
                  category: key,
                  children: value,
                ));
              });

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                sliver: SliverGrid.count(
                  crossAxisCount:
                      Config.categoriesHomeScreenGridLayoutCrossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                  children: childrenList,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    Key key,
    @required this.category,
    @required this.children,
  }) : super(key: key);

  final WooProductCategory category;
  final List<WooProductCategory> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final lang = S.of(context);
    return GestureDetector(
      onTap: () {
        if (category?.id == null) {
          UiController.showNotification(
            context: context,
            title: lang.noCategoryFound,
            message: lang.noCategoryFoundMessage,
          );
          return;
        }
        NavigationController.navigator.push(
          CategorisedProductsRoute(
            category: category,
            childrenCategoryList: children ?? [],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(
            Config.categoriesHomeScreenItemBorderRadius ?? 8,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 35,
              width: 35,
              child: ExtendedCachedImage(
                imageUrl: category?.image?.src,
                borderRadius: ThemeGuide.borderRadius5,
              ),
            ),
            const Flexible(child: SizedBox(height: 10)),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  category?.name ?? '',
                  style: theme.textTheme.caption
                      .copyWith(fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
