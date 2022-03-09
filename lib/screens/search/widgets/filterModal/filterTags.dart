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
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../developer/dev.log.dart';
import '../../../../generated/l10n.dart';
import '../../../../locator.dart';
import '../../../../shared/widgets/error/errorReload.dart';
import '../../viewModel/searchViewModel.dart';
import 'shared/listItem.dart';

/// Fetch the tags for the application to use as a filter in the
/// search field
class FilterTags extends StatefulWidget {
  const FilterTags({Key key}) : super(key: key);

  @override
  _FilterTagsState createState() => _FilterTagsState();
}

class _FilterTagsState extends State<FilterTags> {
  bool isLoading = true;
  bool hasData = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();

    // fetch the filters if not already present
    if (LocatorService.searchViewModel().tags.isEmpty) {
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
      final result = await LocatorService.tagsViewModel().getTags();
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
      Dev.error('Fetch tags error', error: e, stackTrace: s);
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

    return Center(
      child: Text(S.of(context).noDataAvailable),
    );
  }
}

class _ListContainer extends StatelessWidget {
  const _ListContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = LocatorService.searchViewModel().tags;

    if (list == null || list.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 40,
      child: Selector<SearchViewModel, WooStoreFilters>(
        selector: (context, d) => d.searchFilters,
        shouldRebuild: (a, b) => a.tag?.id != b.tag?.id,
        builder: (context, searchFilters, w) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context, i) {
              return HorizontalListTextItem(
                text: list[i].name,
                onTap: () => LocatorService.searchViewModel().setTag(list[i]),
                isSelected: list[i]?.id == searchFilters?.tag?.id ?? false,
              );
            },
          );
        },
      ),
    );
  }
}
