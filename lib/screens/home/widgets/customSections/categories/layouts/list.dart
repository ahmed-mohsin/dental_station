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
import 'package:woocommerce/woocommerce.dart';

import '../../../../../../controllers/navigationController.dart';
import '../../../../../../controllers/uiController.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../../shared/image/extendedCachedImage.dart';
import '../../../../../../themes/theme.dart';
import '../../../../models/customSectionData.dart';

/// Name: Categories Home Screen Horizontal Layout
/// Horizontal list for categories in the Home screen
class CategoriesSectionHomeListLayout extends StatelessWidget {
  const CategoriesSectionHomeListLayout({Key key, this.sectionData})
      : super(key: key);
  final CategoriesSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    if (sectionData?.fullResponseCategories == null ||
        sectionData.fullResponseCategories.isEmpty) {
      return const SizedBox();
    }
    return SizedBox(
      height: sectionData.height,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: sectionData.fullResponseCategories.length ?? 0,
        itemBuilder: (context, i) {
          return _RowItem(
            category: sectionData.fullResponseCategories[i],
            borderRadius: sectionData.borderRadius,
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
    this.borderRadius = 8,
  }) : super(key: key);

  final WooProductCategory category;
  final double borderRadius;

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
          CategorisedProductsRoute(category: category),
        );
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: ThemeGuide.padding10,
          margin: ThemeGuide.margin5,
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 3,
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
      ),
    );
  }
}
