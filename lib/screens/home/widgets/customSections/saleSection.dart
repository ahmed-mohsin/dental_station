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
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/navigationController.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/sectionGenerator.dart';
import '../../../../shared/widgets/error/errorReload.dart';
import '../../../../themes/theme.dart';
import '../../models/customSectionData.dart';
import '../../viewModel/homeSection.viewModel.dart';
import 'shared/imageList.dart';
import 'shared/seeAllButton.dart';

class SaleSectionProducts extends StatelessWidget {
  const SaleSectionProducts({
    Key key,
    @required this.sectionData,
  }) : super(key: key);
  final SaleSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (sectionData.showPromotionalImages) {
      return _PromotionalImages(
        sectionData: sectionData,
        theme: theme,
      );
    } else {
      return _ProductsContainer(sectionData: sectionData);
    }
  }
}

class _Title extends StatelessWidget {
  const _Title({Key key, this.sectionData}) : super(key: key);
  final SaleSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LimitedBox(
      maxHeight: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              sectionData.tag?.name ?? '',
              style: theme.textTheme.headline6,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          _SaleEndTimer(
            saleEndTime: sectionData.saleEndTime,
            theme: theme,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        ],
      ),
    );
  }
}

class _ProductsContainer extends StatelessWidget {
  const _ProductsContainer({
    Key key,
    @required this.sectionData,
  }) : super(key: key);
  final SaleSectionData sectionData;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final dataHolder = HomeSectionDataHolder(wooProductTag: sectionData.tag);
    return RenderHomeSectionProducts(
      homeSectionDataHolder: dataHolder,
      child: Selector<HomeSectionViewModel, List<String>>(
        selector: (context, d) => d.smallProductsList,
        builder: (context, data, w) {
          if (data.isEmpty) {
            return ErrorReload(
              errorMessage: lang.noDataAvailable,
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
              return SectionGenerator(
                data: data,
                titleWidget: _Title(sectionData: sectionData),
                showMore: () {
                  final HomeSectionDataHolder dataHolder =
                      HomeSectionDataHolder(
                    wooProductTag: sectionData.tag,
                  );
                  NavigationController.navigator.push(
                    AllProductsRoute(homeSectionDataHolder: dataHolder),
                  );
                },
              );
              break;

            case SectionLayout.grid:
              return SectionGenerator.grid(
                data: data,
                titleWidget: _Title(sectionData: sectionData),
                showMore: () {
                  final HomeSectionDataHolder dataHolder =
                      HomeSectionDataHolder(
                    wooProductTag: sectionData.tag,
                  );
                  NavigationController.navigator.push(
                    AllProductsRoute(homeSectionDataHolder: dataHolder),
                  );
                },
              );
              break;

            case SectionLayout.mediumGrid:
              return SectionGenerator.mediumGrid(
                data: data,
                titleWidget: _Title(sectionData: sectionData),
                showMore: () {
                  final HomeSectionDataHolder dataHolder =
                      HomeSectionDataHolder(
                    wooProductTag: sectionData.tag,
                  );
                  NavigationController.navigator.push(
                    AllProductsRoute(homeSectionDataHolder: dataHolder),
                  );
                },
              );
              break;
            default:
              return SectionGenerator(
                data: data,
                titleWidget: _Title(sectionData: sectionData),
                showMore: () {
                  final HomeSectionDataHolder dataHolder =
                      HomeSectionDataHolder(
                    wooProductTag: sectionData.tag,
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

class _PromotionalImages extends StatelessWidget {
  const _PromotionalImages({
    Key key,
    @required this.sectionData,
    this.theme,
  }) : super(key: key);

  final SaleSectionData sectionData;

  /// Send the theme from parent widget so save an inherited widget lookup.
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 8,
      ),
      margin: ThemeGuide.padding,
      decoration: BoxDecoration(
        color: theme != null
            ? theme.backgroundColor
            : Theme.of(context).backgroundColor,
        borderRadius: ThemeGuide.borderRadius16,
      ),
      child: Column(
        children: <Widget>[
          Text(
            sectionData.tag?.name ?? lang.sale,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          if (sectionData.showTimer)
            _SaleEndTimer(
              saleEndTime: sectionData.saleEndTime,
              theme: theme,
            ),
          const SizedBox(height: 16),
          if (sectionData.layout == SectionLayout.list)
            GestureDetector(
              onTap: _navigate,
              child: ImageListContainer(images: sectionData.images),
            )
          else if (sectionData.layout == SectionLayout.grid)
            GestureDetector(
              onTap: _navigate,
              child: ImageListContainer.grid(
                images: sectionData.images,
                columns: 2,
              ),
            )
          else if (sectionData.layout == SectionLayout.mediumGrid)
            GestureDetector(
              onTap: _navigate,
              child: ImageListContainer.grid(
                images: sectionData.images,
                columns: 3,
              ),
            ),
          const SizedBox(height: 16),
          SeeAllButton(onPress: _navigate),
        ],
      ),
    );
  }

  void _navigate() {
    final HomeSectionDataHolder dataHolder =
        HomeSectionDataHolder(wooProductTag: sectionData.tag);
    NavigationController.navigator.push(
      AllProductsRoute(homeSectionDataHolder: dataHolder),
    );
  }
}

class _SaleEndTimer extends StatelessWidget {
  const _SaleEndTimer({
    Key key,
    this.saleEndTime,
    this.theme,
    this.mainAxisAlignment = MainAxisAlignment.center,
  }) : super(key: key);

  final String saleEndTime;

  /// Send the theme from parent widget so save an inherited widget lookup.
  final ThemeData theme;

  /// Alignment for the row which holds timer and text
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final int now = DateTime.now().millisecondsSinceEpoch;
    final int endTime = DateTime.parse(saleEndTime).millisecondsSinceEpoch;
    final remainingSeconds = endTime - now;

    if (remainingSeconds < 0) {
      return Text(
        lang.saleEnded,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: (theme != null
                      ? theme.brightness
                      : Theme.of(context).brightness) ==
                  Brightness.light
              ? const Color(0xFF616161)
              : const Color(0xFFBDBDBD),
        ),
      );
    }

    if (remainingSeconds != null && remainingSeconds > 0) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Text(lang.endsIn),
          const SizedBox(width: 10),
          CountdownTimer(
            endTime: endTime,
            endWidget: Text(
              lang.saleEnded,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: (theme != null
                            ? theme.brightness
                            : Theme.of(context).brightness) ==
                        Brightness.light
                    ? const Color(0xFF616161)
                    : const Color(0xFFBDBDBD),
              ),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: (theme != null
                          ? theme.brightness
                          : Theme.of(context).brightness) ==
                      Brightness.light
                  ? const Color(0xFF616161)
                  : const Color(0xFFBDBDBD),
            ),
          ),
        ],
      );
    } else {
      return Text(
        lang.saleEnd + ': ' + saleEndTime,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      );
    }
  }
}
