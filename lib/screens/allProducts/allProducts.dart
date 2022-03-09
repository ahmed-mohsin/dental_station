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

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/uiController.dart';
import '../../enums/enums.dart';
import '../../generated/l10n.dart';
import '../../locator.dart';
import '../../providers/utils/viewStateController.dart';
import '../../shared/itemCard.dart';
import '../../shared/widgets/error/noDataAvailable.dart';
import '../../shared/widgets/loadingIndicators/listLoadingIndicator.dart';
import '../../themes/theme.dart';
import '../home/viewModel/homeSection.viewModel.dart';
import 'viewModel/allProductsViewModel.dart';
import 'widgets/filterModal/allProductsFilterModal.dart';
import 'widgets/sort_bottom_sheet.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({
    Key key,
    @required this.homeSectionDataHolder,
  }) : super(key: key);
  final HomeSectionDataHolder homeSectionDataHolder;

  @override
  Widget build(BuildContext context) {
    HomeSectionViewModel provider = LocatorService.homeViewModel()
        .homeSectionsMap[homeSectionDataHolder.id];

    if (provider == null) {
      // Initiate the provider while showing a loading animation
      LocatorService.homeViewModel().addHomeSectionToMap(homeSectionDataHolder);

      final tempProvider = LocatorService.homeViewModel()
          .homeSectionsMap[homeSectionDataHolder.id];

      if (tempProvider != null) {
        provider = tempProvider;
      } else {
        return Scaffold(
          appBar: AppBar(),
          body: const NoDataAvailableImage(),
        );
      }
    }

    return ChangeNotifierProvider(
      create: (context) => AllProductsViewModel(provider),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final provider = Provider.of<AllProductsViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(provider?.getTitle() ?? lang.all + ' ' + lang.products),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: lang.sort,
            onPressed: () {
              UiController.modalBottomSheet(
                context: context,
                child: AllProductsSortBottomSheet(provider: provider),
              );
            },
          ),
          IconButton(
            tooltip: lang.filter,
            icon: const Icon(EvaIcons.optionsOutline),
            onPressed: () {
              UiController.showModal(
                context: context,
                child: AllProductsFilterModal(provider: provider),
              );
            },
          ),
        ],
      ),
      body: ViewStateController<AllProductsViewModel>(
        child: const _ListContainer(),
        fetchData: provider?.fetchData,
        // isDataAvailable: provider?.productsList?.isNotEmpty ?? false,
      ),
    );
  }
}

class _ListContainer extends StatefulWidget {
  const _ListContainer({Key key}) : super(key: key);

  @override
  __ListContainerState createState() => __ListContainerState();
}

class __ListContainerState extends State<_ListContainer> {
  AllProductsViewModel model;

  /// Page number to fetch the result for
  int page = 2;

  /// Controller for the grid view
  final ScrollController _scrollController = ScrollController();

  /// Flag to prevent concurrent requests
  bool isPerformingRequest = false;

  /// Flag to mark if the previous data request gave the last set of data
  /// available.
  bool isFinalDataSet = false;

  /// Flag to check if the error reload function should be shown to the
  /// user.
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model = Provider.of<AllProductsViewModel>(context);
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

      final result = await model.fetchMoreData(page: page);

      if (result == FetchActionResponse.Failed) {
        UiController.showNotification(
          context: context,
          title: S.of(context).somethingWentWrong,
          message: S.of(context).requestFailed,
          color: Colors.red,
        );
      }

      if (result == FetchActionResponse.LastData ||
          result == FetchActionResponse.NoDataAvailable) {
        UiController.showNotification(
          context: context,
          title: S.of(context).endOfList,
          message: S.of(context).noMoreDataAvailable,
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
    return Selector<AllProductsViewModel, List<String>>(
      selector: (context, d) => d.productsList,
      shouldRebuild: (a, b) => a.length != b.length,
      builder: (context, list, w) {
        if (list.isEmpty) {
          return const NoDataAvailableImage();
        }
        return Stack(
          children: [
            GridView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              padding: ThemeGuide.listPadding,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: ThemeGuide.productItemCardAspectRatio,
              ),
              itemCount: model.productsList.length,
              itemBuilder: (context, i) {
                return ItemCard(productId: model.productsList[i]);
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
      },
    );
  }
}
