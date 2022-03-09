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

import '../../../controllers/navigationController.dart';
import '../../../locator.dart';
import '../../../shared/image/extendedCachedImage.dart';
import '../../../shared/widgets/error/noDataAvailable.dart';
import '../../../themes/theme.dart';
import '../models/ParentChildCategoryModel.dart';

class CSLayoutList extends StatelessWidget {
  const CSLayoutList({Key key}) : super(key: key);

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
    return GestureDetector(
      onTap: () {
        NavigationController.navigator.push(
          CategorisedProductsRoute(
            category: model.parentCategory,
            childrenCategoryList: model.childrenCategories,
          ),
        );
      },
      child: Container(
        padding: ThemeGuide.padding10,
        margin: ThemeGuide.marginV5,
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: ThemeGuide.borderRadius10,
        ),
        child: Row(
          children: [
            Container(
              margin: ThemeGuide.margin10,
              height: 60,
              width: 60,
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
