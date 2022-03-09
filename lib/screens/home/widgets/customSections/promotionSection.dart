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
import '../../../../themes/theme.dart';
import '../../models/customSectionData.dart';
import '../../models/homeSectionDataHolder.dart';
import 'shared/imageList.dart';
import 'shared/labelAndButtonRow.dart';

class PromotionSectionProducts extends StatelessWidget {
  const PromotionSectionProducts({
    Key key,
    @required this.sectionData,
  }) : super(key: key);
  final PromotionSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    if (sectionData.imageCount > 0) {
      return Padding(
        padding: ThemeGuide.padding10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LabelAndButtonRow(
              title: sectionData.tag?.name ?? '',
              homeSectionDataHolder: HomeSectionDataHolder(
                wooProductTag: sectionData.tag,
              ),
            ),
            const SizedBox(height: 10),
            if (sectionData.layout == SectionLayout.list)
              GestureDetector(
                onTap: _navigate,
                child: ImageListContainer(images: sectionData.images),
              ),
            if (sectionData.layout == SectionLayout.grid ||
                sectionData.layout == SectionLayout.mediumGrid)
              GestureDetector(
                onTap: _navigate,
                child: ImageListContainer.grid(
                  images: sectionData.images,
                  columns: sectionData.columns,
                ),
              ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  void _navigate() {
    final HomeSectionDataHolder dataHolder = HomeSectionDataHolder(
      wooProductTag: sectionData.tag,
    );
    NavigationController.navigator.push(
      AllProductsRoute(homeSectionDataHolder: dataHolder),
    );
  }
}
