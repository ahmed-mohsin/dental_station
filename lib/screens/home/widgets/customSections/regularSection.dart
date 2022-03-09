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

import '../../../../controllers/navigationController.dart';
import '../../../../shared/sectionGenerator.dart';
import '../../../../shared/widgets/error/errorReload.dart';
import '../../models/customSectionData.dart';
import '../../viewModel/homeSection.viewModel.dart';

class RegularSectionProducts extends StatelessWidget {
  const RegularSectionProducts({
    Key key,
    @required this.sectionData,
  }) : super(key: key);
  final RegularSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    final dataHolder = HomeSectionDataHolder(
      wooProductCategory: sectionData.category,
      wooProductTag: sectionData.tag,
    );
    return RenderHomeSectionProducts(
      homeSectionDataHolder: dataHolder,
      child: Selector<HomeSectionViewModel, List<String>>(
        selector: (context, d) => d.smallProductsList,
        builder: (context, data, w) {
          if (data.isEmpty) {
            return ErrorReload(
              errorMessage: 'No Products Available',
              reloadFunction: () {
                Provider.of<HomeSectionViewModel>(
                  context,
                  listen: false,
                ).fetchProducts();
              },
            );
          }

          switch (sectionData.layout) {
            case SectionLayout.list:
              final title =
                  (sectionData?.tag?.name ?? sectionData?.category?.name) ?? '';
              return SectionGenerator(
                data: data,
                title: title,
                showMore: () {
                  final HomeSectionDataHolder dataHolder =
                      HomeSectionDataHolder(
                    wooProductTag: sectionData.tag,
                    wooProductCategory: sectionData.category,
                  );
                  NavigationController.navigator.push(
                    AllProductsRoute(homeSectionDataHolder: dataHolder),
                  );
                },
              );
              break;

            case SectionLayout.grid:
              final title =
                  (sectionData?.tag?.name ?? sectionData?.category?.name) ?? '';
              return SectionGenerator.grid(
                data: data,
                title: title,
                showMore: () {
                  final HomeSectionDataHolder dataHolder =
                      HomeSectionDataHolder(
                    wooProductTag: sectionData.tag,
                    wooProductCategory: sectionData.category,
                  );
                  NavigationController.navigator.push(
                    AllProductsRoute(homeSectionDataHolder: dataHolder),
                  );
                },
              );
              break;

            case SectionLayout.mediumGrid:
              final title =
                  (sectionData?.tag?.name ?? sectionData?.category?.name) ?? '';
              return SectionGenerator.mediumGrid(
                data: data,
                title: title,
                showMore: () {
                  final HomeSectionDataHolder dataHolder =
                      HomeSectionDataHolder(
                    wooProductTag: sectionData.tag,
                    wooProductCategory: sectionData.category,
                  );
                  NavigationController.navigator.push(
                    AllProductsRoute(homeSectionDataHolder: dataHolder),
                  );
                },
              );
              break;
            default:
              final title =
                  (sectionData?.tag?.name ?? sectionData?.category?.name) ?? '';
              return SectionGenerator(
                data: data,
                title: title,
                showMore: () {
                  final HomeSectionDataHolder dataHolder =
                      HomeSectionDataHolder(
                    wooProductTag: sectionData.tag,
                    wooProductCategory: sectionData.category,
                  );
                  NavigationController.navigator.push(
                    AllProductsRoute(homeSectionDataHolder: dataHolder),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
