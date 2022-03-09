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

import '../../controllers/navigationController.dart';
import '../../generated/l10n.dart';
import '../../locator.dart';
import '../../providers/utils/viewStateController.dart';
import '../../themes/theme.dart';
import 'viewModel/view_model.dart';

class TagsScreen extends StatelessWidget {
  const TagsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If the data is available, then load the body directly
    // else create a ViewStateController to fetch the data
    final bool isDataAvailable = LocatorService.tagsViewModel().tags.isNotEmpty;

    final lang = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tags),
      ),
      body: isDataAvailable
          ? const _Body()
          : ChangeNotifierProvider<TagsViewModel>.value(
              value: LocatorService.tagsViewModel(),
              child: const _BodyWithoutData(),
            ),
    );
  }
}

class _BodyWithoutData extends StatelessWidget {
  const _BodyWithoutData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateController<TagsViewModel>(
      fetchData: LocatorService.tagsViewModel().getTags,
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: ThemeGuide.listPadding,
      physics: const BouncingScrollPhysics(),
      child: Wrap(
        spacing: 10,
        runSpacing: 16,
        children: LocatorService.tagsViewModel()
            .tags
            .map<Widget>((e) => _ListItem(tag: e))
            .toList(),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({Key key, this.tag}) : super(key: key);
  final WooProductTag tag;

  @override
  Widget build(BuildContext context) {
    if (tag?.name == null) {
      return const SizedBox();
    }
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: ThemeGuide.borderRadius,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      onPressed: () {
        NavigationController.navigator.push(TagProductsRoute(tag: tag));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 10,
        ),
        child: Text(tag.name),
      ),
    );
  }
}
