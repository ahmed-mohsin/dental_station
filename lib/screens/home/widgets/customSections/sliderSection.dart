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

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../controllers/navigationController.dart';
import '../../../../shared/image/extendedCachedImage.dart';
import '../../models/customSectionData.dart';
import '../../models/homeSectionDataHolder.dart';

class SliderSectionProducts extends StatelessWidget {
  const SliderSectionProducts({
    Key key,
    @required this.sectionData,
  }) : super(key: key);

  final SliderSectionData sectionData;

  static final SwiperController swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    if (sectionData == null ||
        sectionData.items == null ||
        sectionData.items.isEmpty) {
      return const SizedBox();
    }
    final list = sectionData.items;
    return SizedBox(
      height: sectionData.height ?? 150.0,
      child: Swiper(
        controller: swiperController,
        physics: const BouncingScrollPhysics(),
        loop: false,
        autoplay: sectionData.autoPlay ?? false,
        autoplayDisableOnInteraction: true,
        duration: 500,
        scale: 0.7,
        itemCount: list.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.all(sectionData.margin ?? 0),
            child: _CardItem(
              item: list[i],
              borderRadius: sectionData.borderRadius,
            ),
          );
        },
        pagination: SwiperCustomPagination(
          builder: (context, config) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 20 + sectionData.margin * 2,
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                  controller: config.pageController,
                  count: config.itemCount,
                  effect: const WormEffect(
                    dotWidth: 20,
                    dotHeight: 3,
                    radius: 2,
                    dotColor: Color(0x35000000),
                    activeDotColor: Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  const _CardItem({
    Key key,
    @required this.item,
    this.borderRadius = 10,
  }) : super(key: key);

  final SliderSectionDataItem item;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final HomeSectionDataHolder dataHolder = HomeSectionDataHolder(
          wooProductTag: item.tag,
        );
        NavigationController.navigator.push(
          AllProductsRoute(homeSectionDataHolder: dataHolder),
        );
      },
      child: ExtendedCachedImage(
        imageUrl: item.imageUrl,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
