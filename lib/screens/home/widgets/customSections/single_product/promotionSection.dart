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

import '../../../../../controllers/navigationController.dart';
import '../../../../../developer/dev.log.dart';
import '../../../../../themes/theme.dart';
import '../../../models/customSectionData.dart';
import '../shared/imageList.dart';

class PromotionSingleProductSectionProducts extends StatelessWidget {
  const PromotionSingleProductSectionProducts({
    Key key,
    @required this.sectionData,
  }) : super(key: key);
  final PromotionSingleProductSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    if (sectionData.imageCount > 0) {
      return Padding(
        padding: ThemeGuide.padding10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (isNotBlank(sectionData.title))
              Text(
                sectionData.title,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
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

  Future<void> _navigate() async {
    if (isBlank(sectionData.productId)) {
      Dev.warn('Banner Single Product Section product Id is blank!');
    } else {
      NavigationController.navigator
          .push(ProductScreenRoute(id: sectionData.productId));
    }
  }
}
