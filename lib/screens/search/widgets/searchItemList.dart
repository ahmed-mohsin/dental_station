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

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../controllers/uiController.dart';
import '../../../enums/enums.dart';
import '../../../generated/l10n.dart';
import '../../../locator.dart';
import '../../../shared/itemCard.dart';
import '../../../shared/widgets/loadingIndicators/listLoadingIndicator.dart';
import '../../../themes/theme.dart';
import '../viewModel/searchViewModel.dart';

class SearchItemList extends StatefulWidget {
  const SearchItemList({Key key}) : super(key: key);

  @override
  _SearchItemListState createState() => _SearchItemListState();
}

class _SearchItemListState extends State<SearchItemList> {
  S lang;

  /// Page number to fetch the result for
  int page = 2;

  /// Controller for the grid view
  final ScrollController _scrollController = ScrollController();

  /// Flag to prevent concurrent requests
  bool isPerformingRequest = false;

  /// Flag to mark if the previous data request gave the last set of data
  /// available.
  bool isFinalDataSet = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      lang = S.of(context);
    });
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _getMoreData();
    }
  }

  Future<void> _getMoreData() async {
    if (isFinalDataSet) {
      return;
    }
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);

      final result =
          await LocatorService.searchViewModel().fetchMoreData(page: page);

      if (result == FetchActionResponse.Failed) {
        UiController.showNotification(
          context: context,
          title: lang.somethingWentWrong,
          message: lang.requestFailed,
          color: Colors.red,
        );
      }

      if (result == FetchActionResponse.LastData ||
          result == FetchActionResponse.NoDataAvailable) {
        UiController.showNotification(
          context: context,
          title: lang.endOfList,
          message: lang.noMoreDataAvailable,
          position: FlushbarPosition.BOTTOM,
        );
      }

      setState(() {
        isPerformingRequest = false;
        page++;
        isFinalDataSet = result == FetchActionResponse.LastData ||
            result == FetchActionResponse.NoDataAvailable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Selector<SearchViewModel, List>(
          selector: (context, d) => d.searchProductsList,
          // shouldRebuild: (previous, next) => true,
          builder: (context, list, _) {
            if (list.isNotEmpty) {
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                padding: ThemeGuide.listPadding,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1.1 / 2,
                ),
                itemCount: list.length,
                itemBuilder: (context, int i) {
                  return ItemCard(productId: list[i]);
                },
              );
            } else {
              return Center(child: Text(lang.noDataAvailable));
            }
          },
        ),
        if (isPerformingRequest)
          const Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Center(child: ListLoadingIndicator()),
          ),
      ],
    );
  }
}
