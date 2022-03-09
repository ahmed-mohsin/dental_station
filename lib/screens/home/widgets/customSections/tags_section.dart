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

import '../../../../controllers/navigationController.dart';
import '../../../../services/woocommerce/woocommerce.service.dart';
import '../../../../themes/theme.dart';
import '../../models/customSectionData.dart';

class TagsSection extends StatelessWidget {
  const TagsSection({Key key, this.sectionData}) : super(key: key);
  final TagsSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    if (sectionData.tags == null || sectionData.tags.isEmpty) {
      return const SizedBox();
    }
    switch (sectionData.layout) {
      case SectionLayout.list:
        return _ListLayout(sectionData: sectionData);
        break;
      case SectionLayout.grid:
        return _GridLayout(sectionData: sectionData);
        break;
      case SectionLayout.wrap:
        return _WrapLayout(sectionData: sectionData);
        break;
      default:
        return _ListLayout(sectionData: sectionData);
    }
  }
}

class _ListLayout extends StatelessWidget {
  const _ListLayout({Key key, this.sectionData}) : super(key: key);
  final TagsSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: ThemeGuide.marginH5,
      height: sectionData.height,
      child: ListView.builder(
        itemCount: sectionData.tags.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: _RowItem(
              tag: sectionData.tags[i],
              theme: theme,
              borderRadius: sectionData.borderRadius,
            ),
          );
        },
      ),
    );
  }
}

class _GridLayout extends StatelessWidget {
  const _GridLayout({Key key, this.sectionData}) : super(key: key);
  final TagsSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.count(
      crossAxisCount: sectionData.columns,
      physics: const NeverScrollableScrollPhysics(),
      padding: ThemeGuide.padding,
      shrinkWrap: true,
      childAspectRatio: 3,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: sectionData.tags
          .map((e) => _RowItem(
                tag: e,
                borderRadius: sectionData.borderRadius,
                theme: theme,
              ))
          .toList(),
    );
  }
}

class _WrapLayout extends StatelessWidget {
  const _WrapLayout({Key key, this.sectionData}) : super(key: key);
  final TagsSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: ThemeGuide.marginH5,
      child: Wrap(
        spacing: 5,
        children: sectionData.tags
            .map((e) => _RowItem(
                  tag: e,
                  borderRadius: sectionData.borderRadius,
                  theme: theme,
                ))
            .toList(),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    Key key,
    this.tag,
    this.borderRadius,
    this.theme,
  }) : super(key: key);
  final WooProductTag tag;
  final double borderRadius;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: theme.backgroundColor,
        padding: ThemeGuide.padding10,
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: () {
        NavigationController.navigator.push(TagProductsRoute(tag: tag));
      },
      child: Text(
        tag?.name ?? '',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
