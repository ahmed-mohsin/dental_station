// Copyright (c) 2020 Aniket Malik [aniketmalikwork@gmail.com]
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

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/config.dart';
import '../../../../controllers/navigationController.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/filter_modal/filter_modal.dart';
import '../../../../shared/gradientButton/gradientButton.dart';
import '../../../../themes/gradients.dart';
import '../../../../themes/themeGuide.dart';
import '../../viewModel/allProductsViewModel.dart';
import 'filterCategories.dart';
import 'filterTags.dart';

// import 'filter_attributes.dart';
// import 'filter_toggles.dart';
// import 'priceRangeSlider.dart';

class AllProductsFilterModal extends StatelessWidget {
  const AllProductsFilterModal({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final AllProductsViewModel provider;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    return ChangeNotifierProvider<AllProductsViewModel>.value(
      value: provider,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(lang.filter),
          actions: const [CloseButton()],
        ),
        body: Padding(
          padding: ThemeGuide.padding20,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              const FilterOnSale<AllProductsViewModel>(),
              const Divider(),
              const FilterInStock<AllProductsViewModel>(),
              const Divider(),
              const FilterFeatured<AllProductsViewModel>(),
              const Divider(),
              if (Config.showCategoriesInAllProductsFilterModal)
                ExpandablePanel(
                  theme: theme.brightness == Brightness.dark
                      ? const ExpandableThemeData(
                          hasIcon: true,
                          iconColor: Colors.white,
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                        )
                      : const ExpandableThemeData(
                          hasIcon: true,
                          iconColor: Colors.black,
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                        ),
                  header: _Heading(text: lang.categories),
                  collapsed: const SizedBox(),
                  expanded: Column(
                    children: const [
                      SizedBox(height: 10),
                      FilterCategories(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              if (Config.showTagsInAllProductsFilterModal) const Divider(),
              if (Config.showTagsInAllProductsFilterModal)
                ExpandablePanel(
                  theme: theme.brightness == Brightness.dark
                      ? const ExpandableThemeData(
                          hasIcon: true,
                          iconColor: Colors.white,
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                        )
                      : const ExpandableThemeData(
                          hasIcon: true,
                          iconColor: Colors.black,
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                        ),
                  header: _Heading(text: lang.tags),
                  collapsed: const SizedBox(),
                  expanded: Column(
                    children: const [
                      SizedBox(height: 10),
                      FilterTags(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              if (Config.showTagsInAllProductsFilterModal) const Divider(),
              ExpandablePanel(
                theme: theme.brightness == Brightness.dark
                    ? const ExpandableThemeData(
                        hasIcon: true,
                        iconColor: Colors.white,
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                      )
                    : const ExpandableThemeData(
                        hasIcon: true,
                        iconColor: Colors.black,
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                      ),
                header: _Heading(text: lang.price),
                collapsed: const SizedBox(),
                expanded: const FilterPriceRangeSlider<AllProductsViewModel>(),
              ),
              const Divider(),
              const FilterAttributes<AllProductsViewModel>(),
              const SizedBox(height: 20),
              const _ApplyFilterButton(),
              const _ClearFilters(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({Key key, this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ClearFilters extends StatelessWidget {
  const _ClearFilters({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return GestureDetector(
      onTap: Provider.of<AllProductsViewModel>(context, listen: false)
          .clearFilters,
      child: Container(
        padding: ThemeGuide.padding20,
        child: Center(child: Text(lang.clearFilters)),
      ),
    );
  }
}

class _ApplyFilterButton extends StatelessWidget {
  const _ApplyFilterButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return SafeArea(
      bottom: true,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: GradientButton(
          gradient: ThemeGuide.isDarkMode(context)
              ? AppGradients.mainGradientDarkMode
              : AppGradients.mainGradient,
          onPress: () {
            Provider.of<AllProductsViewModel>(context, listen: false)
                .fetchDataWithFilter();
            NavigationController.navigator.pop();
          },
          child: Text(
            lang.apply,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
