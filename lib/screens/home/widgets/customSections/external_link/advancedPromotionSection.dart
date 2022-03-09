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

import '../../../../../shared/image/extendedCachedImage.dart';
import '../../../../../themes/theme.dart';
import '../../../models/customSectionData.dart';
import '../../../utils/homeUtils.dart';

class AdvancedPromotionExternalLinkSectionProducts extends StatelessWidget {
  const AdvancedPromotionExternalLinkSectionProducts({
    Key key,
    @required this.sectionData,
  }) : super(key: key);
  final AdvancedPromotionExternalLinkSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    if (sectionData.layout == SectionLayout.list) {
      return _List(sectionData: sectionData);
    } else if (sectionData.layout == SectionLayout.grid) {
      return _Grid(sectionData: sectionData);
    } else {
      return _List(sectionData: sectionData);
    }
  }
}

class _List extends StatelessWidget {
  const _List({Key key, this.sectionData}) : super(key: key);
  final AdvancedPromotionExternalLinkSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ThemeGuide.padding10,
      height: sectionData.height,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: sectionData.itemCount,
        itemBuilder: (context, i) {
          return _RowItem(
            sectionData: sectionData,
            item: sectionData.items[i],
            borderRadius: sectionData.borderRadius,
          );
        },
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({Key key, this.sectionData}) : super(key: key);
  final AdvancedPromotionExternalLinkSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: sectionData.columns,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      padding: ThemeGuide.padding10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sectionData.itemCount,
      itemBuilder: (context, i) {
        return _RowItem.grid(
          sectionData: sectionData,
          item: sectionData.items[i],
          borderRadius: sectionData.borderRadius,
        );
      },
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    Key key,
    @required this.item,
    this.sectionData,
    this.borderRadius = 10,
  })  : margin = ThemeGuide.marginH5,
        super(key: key);

  const _RowItem.grid({
    Key key,
    @required this.item,
    this.sectionData,
    this.borderRadius = 10,
  })  : margin = const EdgeInsets.all(0),
        super(key: key);

  final AdvancedPromotionExternalLinkSectionData sectionData;
  final AdvancedPromotionExternalLinkSectionDataItem item;
  final double borderRadius;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    final showLabel = sectionData != null && sectionData.showLabel;
    return GestureDetector(
      onTap: () {
        HomeUtils.handleExternalLinkNavigationEvent(
          context: context,
          externalLink: item.externalLink,
        );
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: margin,
          child: showLabel
              ? Column(
                  children: [
                    Expanded(
                      child: ExtendedCachedImage(
                        imageUrl: item?.imageUrl,
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (isNotBlank(item.label))
                      Text(
                        item.label,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                  ],
                )
              : ExtendedCachedImage(
                  imageUrl: item?.imageUrl,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
        ),
      ),
    );
  }
}
