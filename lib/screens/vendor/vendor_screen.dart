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

import '../../controllers/uiController.dart';
import '../../enums/enums.dart';
import '../../generated/l10n.dart';
import '../../models/models.dart';
import '../../shared/customLoader.dart';
import '../../shared/itemCard.dart';
import '../../shared/widgets/error/noDataAvailable.dart';
import '../../shared/widgets/loadingIndicators/listLoadingIndicator.dart';
import '../../themes/theme.dart';
import 'viewModel/view_model.dart';
import 'widgets/app_bar.dart';

class VendorScreen extends StatelessWidget {
  const VendorScreen({
    Key key,
    @required this.product,
  }) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    if (product?.wooProduct?.vendor == null) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
    final Vendor vendor = product.wooProduct.vendor;
    return ChangeNotifierProvider<VendorProductsViewModel>(
      create: (context) => VendorProductsViewModel(vendor),
      builder: (context, w) => w,
      child: Scaffold(
        body: Builder(
          builder: (context) {
            return CustomScrollView(
              controller: Provider.of<VendorProductsViewModel>(
                context,
                listen: false,
              ).scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                VendorAppBar(vendor: vendor),
                const SliverToBoxAdapter(child: _Body())
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key key}) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  VendorProductsViewModel provider;
  S lang;

  /// Controller for the grid view
  ScrollController _scrollController;

  /// Flag to prevent concurrent requests
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<VendorProductsViewModel>(context, listen: false);
    _scrollController = provider.scrollController;
    _scrollController.addListener(_scrollListener);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      lang = S.of(context);
      provider.fetchData();
    });
  }

  @override
  void dispose() {
    lang = null;
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    provider?.cleanUp();
    provider?.reset();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _getMoreData();
    }
  }

  Future<void> _getMoreData() async {
    if (provider.isFinalDataSet) {
      return;
    }
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);

      final result = await provider.fetchMoreData();

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
        Consumer<VendorProductsViewModel>(
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
                return Selector<VendorProductsViewModel, List>(
                  selector: (context, d) => d.productsList,
                  shouldRebuild: (a, b) => true,
                  builder: (context, list, _) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
    return Selector<VendorProductsViewModel, String>(
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
