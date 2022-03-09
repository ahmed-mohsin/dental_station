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

import '../../../../../shared/image/extendedCachedImage.dart';
import '../../../models/customSectionData.dart';
import '../../../utils/homeUtils.dart';

class BannerExternalLinkSectionProducts extends StatelessWidget {
  const BannerExternalLinkSectionProducts({
    Key key,
    @required this.sectionData,
  }) : super(key: key);

  final BannerExternalLinkSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    if (sectionData == null) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
        HomeUtils.handleExternalLinkNavigationEvent(
          context: context,
          externalLink: sectionData.externalLink,
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sectionData.margin),
        child: ExtendedCachedImage(
          borderRadius: BorderRadius.circular(sectionData.borderRadius),
          imageUrl: sectionData.imageUrl,
        ),
      ),
    );
  }
}
