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

import '../../constants/config.dart';
import '../../generated/l10n.dart';
import '../../locator.dart';
import '../../providers/utils/viewStateController.dart';
import 'layouts/utils.dart';
import 'viewModel/categories.provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If the data is available, then load the body directly
    // else create a ViewStateController to fetch the data
    final bool isDataAvailable =
        LocatorService.categoriesProvider().categoriesMap.isNotEmpty;

    final lang = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.categories),
      ),
      body: ChangeNotifierProvider<CategoriesProvider>.value(
        value: LocatorService.categoriesProvider(),
        child: isDataAvailable
            ? CSLayoutUtils.renderLayout(Config.categoriesScreenLayout)
            : const _BodyWithoutData(),
      ),
    );
  }
}

class _BodyWithoutData extends StatelessWidget {
  const _BodyWithoutData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateController<CategoriesProvider>(
      fetchData: LocatorService.categoriesProvider().getCategories,
      child: CSLayoutUtils.renderLayout(Config.categoriesScreenLayout),
    );
  }
}
