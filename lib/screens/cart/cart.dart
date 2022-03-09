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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';

import '../../constants/config.dart';
import '../../generated/l10n.dart';
import '../../locator.dart';
import 'checkoutContainer.dart';
import 'listItems/cartItem.dart';
import 'viewModel/states.dart';
import 'viewModel/viewModel.dart';
import 'widgets/coupon/coupon_tile.dart';
import 'widgets/customer_note.dart';

class Cart extends StatelessWidget {
  const Cart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return ChangeNotifierProvider<CartViewModel>.value(
      value: LocatorService.cartViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(lang.cart),
          actions: const [_RefreshButton()],
          bottom: const _ProgressIndicator(),
        ),
        body: WillPopScope(
          onWillPop: () =>
              LocatorService.tabbarController().handleTabBackEvent(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Expanded(child: _CartListContainer()),
              CheckOutContainer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartViewModel provider =
        Provider.of<CartViewModel>(context, listen: false);
    if (provider == null) {
      return const SizedBox();
    }
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: provider.getCart,
    );
  }
}

class _ProgressIndicator extends StatelessWidget with PreferredSizeWidget {
  const _ProgressIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<CartViewModel, bool>(
      selector: (context, d) => d.isLoading,
      builder: (context, loading, child) {
        if (loading) {
          return child;
        } else {
          return const SizedBox();
        }
      },
      child: const LinearProgressIndicator(minHeight: 2),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(2);
}

class _CartListContainer extends StatelessWidget {
  const _CartListContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Consumer<CartViewModel>(
      builder: (context, provider, _) {
        if (provider.productsMap.isNotEmpty) {
          if (provider.isSuccess && provider.hasData) {
            final productsList = provider.productsMap.values.toList();
            return CustomScrollView(
              primary: true,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, int i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: CartItem(cartProduct: productsList[i]),
                      );
                    },
                    childCount: productsList.length,
                  ),
                ),
                const SliverToBoxAdapter(child: _ExtraData()),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          }
        }

        if (isNotBlank(provider.errorMessage)) {
          if (provider.cartErrorState != null) {
            if (provider.cartErrorState is CartGeneralErrorState) {
              return _GeneralError(extra: provider.errorMessage);
            } else if (provider.cartErrorState is CartEmptyState) {
              return const _EmptyCart();
            } else if (provider.cartErrorState is CartUserEmptyState) {
              return Center(
                child: Text('${lang.no} ${lang.user}\n${lang.loginAgain}'),
              );
            } else if (provider.cartErrorState is CartLoginMessageState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${provider.errorMessage}\n\n${lang.loginAgain}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                provider.errorMessage ?? lang.somethingWentWrong,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        } else {
          if (provider.cartErrorState != null) {
            if (provider.cartErrorState is CartGeneralErrorState) {
              return const _GeneralError();
            } else if (provider.cartErrorState is CartEmptyState) {
              return const _EmptyCart();
            } else if (provider.cartErrorState is CartUserEmptyState) {
              return Center(
                child: Text('${lang.no} ${lang.user}\n${lang.loginAgain}'),
              );
            } else if (provider.cartErrorState is CartLoginMessageState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${provider.errorMessage}\n\n${lang.loginAgain}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
          }
        }
        return const _EmptyCart();
      },
    );
  }
}

class _GeneralError extends StatelessWidget {
  const _GeneralError({Key key, this.extra = ''}) : super(key: key);
  final String extra;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Center(
      child: Text('${lang.somethingWentWrong}\n$extra'),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'lib/assets/svg/sad-bag-icon.svg',
            height: 200,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white60
                : Colors.black12,
          ),
          const SizedBox(height: 20),
          Text(lang.cartEmpty),
        ],
      ),
    );
  }
}

/// Container for Coupons and Customer Note if any.
class _ExtraData extends StatelessWidget {
  const _ExtraData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<CartViewModel, int>(
      selector: (context, d) => d.totalItems,
      builder: (context, totalItems, child) {
        if (totalItems > 0) {
          return child;
        } else {
          return const SizedBox.shrink();
        }
      },
      child: Column(
        children: const [
          if (Config.cartEnableCoupon) Divider(),
          if (Config.cartEnableCoupon)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: CartCoupon(),
            ),
          if (Config.cartEnableCustomerNote) Divider(),
          if (Config.cartEnableCustomerNote)
            Padding(
              padding: EdgeInsets.all(10),
              child: CartCustomerNote(),
            ),
          if (Config.cartEnableCustomerNote) SizedBox(height: 20),
        ],
      ),
    );
  }
}
