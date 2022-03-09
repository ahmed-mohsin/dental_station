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
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../controllers/uiController.dart';
import '../../enums/enums.dart';
import '../../generated/l10n.dart';
import '../../shared/customLoader.dart';
import '../../shared/itemCard.dart';
import '../../shared/widgets/error/noDataAvailable.dart';
import '../../shared/widgets/loadingIndicators/listLoadingIndicator.dart';
import '../../themes/themeGuide.dart';
import 'viewModel/tag_products_view_model.dart';
import 'widgets/filter_modal/tag_products_filter_modal.dart';
import 'widgets/sort_bottom_sheet.dart';

class TagProducts extends StatefulWidget {
  const TagProducts({
    Key key,
    @required this.tag,
  }) : super(key: key);
  final WooProductTag tag;

  @override
  _TagProductsState createState() => _TagProductsState();
}

class _TagProductsState extends State<TagProducts> {
  TagProductsViewModel provider;

  @override
  void initState() {
    super.initState();

    // Initiate the provider
    provider = TagProductsViewModel(widget.tag);
    provider.fetchData();
  }

  @override
  void dispose() {
    // Clean the provider resources
    provider?.cleanUp();
    provider?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return ChangeNotifierProvider<TagProductsViewModel>.value(
      value: provider,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<TagProductsViewModel>(
            builder: (context, p, w) {
              return Text(
                p.tag?.name ?? lang.products,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              tooltip: lang.sort,
              onPressed: () {
                UiController.modalBottomSheet(
                  context: context,
                  child: TagProductsSortBottomSheet(provider: provider),
                );
              },
              icon: const Icon(Icons.filter_list_rounded),
            ),
            IconButton(
              tooltip: lang.filter,
              onPressed: () {
                UiController.showModal(
                  context: context,
                  child: TagProductsFilterModal(provider: provider),
                );
              },
              icon: const Icon(EvaIcons.optionsOutline),
            ),
          ],
        ),
        body: _Body(provider: provider),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key key, this.provider}) : super(key: key);
  final TagProductsViewModel provider;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  S lang;

  /// Controller for the grid view
  final ScrollController _scrollController = ScrollController();

  /// Flag to prevent concurrent requests
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      lang = S.of(context);
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    lang = null;
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    widget.provider?.cleanUp();
    widget.provider?.reset();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _getMoreData();
    }
  }

  Future<void> _getMoreData() async {
    if (widget.provider.isFinalDataSet) {
      return;
    }
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);

      final result = await widget.provider.fetchMoreData();

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<TagProductsViewModel>(
          builder: (context, provider, widget) {
            if (provider.isLoading) {
              return const _ViewPort(
                child: Center(child: CustomLoader()),
              );
            }
            if (provider.isError) {
              return const _ViewPort(child: _ErrorContainer());
            }
            if (provider.isSuccess) {
              if (provider.hasData) {
                return Selector<TagProductsViewModel, List>(
                  selector: (context, d) => d.tagProductsList,
                  shouldRebuild: (a, b) => true,
                  builder: (context, list, _) {
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: ThemeGuide.productItemCardAspectRatio,
                      ),
                      padding: ThemeGuide.listPadding,
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        return ItemCard(productId: list[i]);
                      },
                    );
                  },
                );
              } else {
                return const _ViewPort(
                  child: Center(child: NoDataAvailableImage()),
                );
              }
            }
            return const _ViewPort(child: Center(child: CustomLoader()));
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

class _ViewPort extends StatelessWidget {
  const _ViewPort({Key key, @required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height - height / 2.5,
      child: child,
    );
  }
}

class _ErrorContainer extends StatelessWidget {
  const _ErrorContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TagProductsViewModel, String>(
      selector: (context, d) => d.errorMessage,
      builder: (context, message, widget) {
        return Container(
          padding: ThemeGuide.padding20,
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
