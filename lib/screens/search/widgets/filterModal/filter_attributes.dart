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

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../developer/dev.log.dart';
import '../../../../generated/l10n.dart';
import '../../../../locator.dart';
import '../../../../shared/image/extendedCachedImage.dart';
import '../../../../shared/widgets/error/errorReload.dart';
import '../../../../themes/theme.dart';
import '../../../../utils/colors.utils.dart';
import '../../viewModel/searchViewModel.dart';

class FilterAttributes extends StatefulWidget {
  const FilterAttributes({Key key}) : super(key: key);

  @override
  _FilterAttributesState createState() => _FilterAttributesState();
}

class _FilterAttributesState extends State<FilterAttributes> {
  bool isLoading = true;
  bool hasData = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();

    // fetch the filters if not already present
    if (LocatorService.wooService().productAttributes.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _fetch();
      });
    } else {
      isLoading = false;
      hasData = true;
      isError = false;
    }
  }

  /// Fetch the wooProduct tags from backend and store them for
  /// future reference
  Future<void> _fetch() async {
    try {
      final result = await LocatorService.wooService().fetchProductAttributes();
      if (result == null) {
        // show error
        if (mounted) {
          setState(() {
            isError = true;
            isLoading = false;
          });
        }
        return;
      }

      if (result.isEmpty) {
        // show no data available
        if (mounted) {
          setState(() {
            isError = false;
            isLoading = false;
            hasData = false;
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          isError = false;
          isLoading = false;
          hasData = true;
        });
      }
    } catch (e, s) {
      Dev.error('Fetch filter attributes error', error: e, stackTrace: s);
      if (mounted) {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LinearProgressIndicator(minHeight: 2);
    }

    if (isError) {
      return ErrorReload(
        errorMessage: S.of(context).somethingWentWrong,
        reloadFunction: _fetch,
      );
    }

    if (hasData) {
      return const _ListContainer();
    }

    return const SizedBox();
  }
}

class _ListContainer extends StatelessWidget {
  const _ListContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = LocatorService.wooService().productAttributes;

    if (list == null || list.isEmpty) {
      return const SizedBox();
    }

    final theme = Theme.of(context);
    return ListView.separated(
      separatorBuilder: (context, i) {
        return const Divider();
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, i) {
        if (list[i] == null || list[i].terms == null || list[i].terms.isEmpty) {
          Dev.warn(
              'Attribute ${list[i].name} does not have any terms, it will be hidden');
          return const SizedBox();
        }
        return _AttributeItem(attribute: list[i], theme: theme);
      },
    );
  }
}

class _AttributeItem extends StatelessWidget {
  const _AttributeItem({Key key, this.attribute, this.theme}) : super(key: key);
  final WooStoreProductAttribute attribute;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    bool shouldExpand = false;
    for (final obj in Provider.of<SearchViewModel>(context, listen: false)
        .searchFilters
        .taxonomyQueryList) {
      if (obj.taxonomySlug == attribute.slug) {
        shouldExpand = true;
      }
    }
    return ExpandablePanel(
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
      controller: ExpandableController(initialExpanded: shouldExpand),
      header: Text(
        attribute.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      collapsed: const SizedBox(),
      expanded: ListView.builder(
        itemCount: attribute.terms.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return _AttributeItemTerm(
            attribute: attribute,
            term: attribute.terms[i],
            theme: theme,
          );
        },
      ),
    );
  }
}

class _AttributeItemTerm extends StatelessWidget {
  const _AttributeItemTerm({
    Key key,
    this.attribute,
    this.term,
    this.theme,
  }) : super(key: key);
  final WooStoreProductAttributeTerm term;
  final ThemeData theme;
  final WooStoreProductAttribute attribute;

  @override
  Widget build(BuildContext context) {
    if (attribute.type == WooStoreProductAttributeType.color) {
      return _buildSelector(_buildColor());
    }

    if (attribute.type == WooStoreProductAttributeType.image) {
      return _buildSelector(_buildImage());
    }

    return _buildSelector(_buildDefault());
  }

  Widget _buildSelector(Widget child) {
    return GestureDetector(
      onTap: () {
        LocatorService.searchViewModel().setTaxonomyQuery(
          WooProductTaxonomyQuery(
            attribute.slug,
            term.termId,
          ),
        );
      },
      child: Selector<SearchViewModel, WooStoreFilters>(
        selector: (context, d) => d.searchFilters,
        builder: (context, filters, w) {
          bool isTermSelected = false;

          for (final taxObject in filters.taxonomyQueryList) {
            if (taxObject.termId == term.termId) {
              isTermSelected = true;
            }
          }

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                AnimatedContainer(
                  width: isTermSelected ? 50 : 0,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: isTermSelected
                      ? Icon(
                          Icons.radio_button_checked_rounded,
                          color: theme.colorScheme.secondary,
                        )
                      : const SizedBox(),
                ),
                Expanded(child: w),
              ],
            ),
          );
        },
        child: child,
      ),
    );
  }

  Widget _buildDefault() {
    return Container(
      padding: ThemeGuide.padding16,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: ThemeGuide.borderRadius10,
      ),
      child:
          Text('${term.name} ${term.count != null ? '(${term.count})' : '0'}'),
    );
  }

  Widget _buildColor() {
    if (term.value == null) {
      return _buildDefault();
    }
    return Container(
      padding: ThemeGuide.padding16,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: ThemeGuide.borderRadius10,
      ),
      child: Row(
        children: [
          Text('${term.name} ${term.count != null ? '(${term.count})' : '0'}'),
          const Spacer(),
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: HexColor.fromDynamicString(term.value),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (term.value == null) {
      return _buildDefault();
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: ThemeGuide.borderRadius10,
      ),
      child: Row(
        children: [
          Text('${term.name} ${term.count != null ? '(${term.count})' : '0'}'),
          const Spacer(),
          SizedBox(
            height: 40,
            width: 40,
            child: ExtendedCachedImage(imageUrl: term.value),
          ),
        ],
      ),
    );
  }
}
