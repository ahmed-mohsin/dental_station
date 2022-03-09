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

import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/config.dart';
import '../../../../controllers/navigationController.dart';
import '../../../../controllers/uiController.dart';
import '../../../../generated/l10n.dart';
import '../../../../locator.dart';
import '../../../../models/models.dart';
import '../../../../shared/animatedButton.dart';
import '../../../../shared/gradientButton/gradientButton.dart';
import '../../../../themes/theme.dart';
import '../../viewModel/productViewModel.dart';

class BuyNowContainer extends StatefulWidget {
  const BuyNowContainer({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _BuyNowContainerState createState() => _BuyNowContainerState();
}

class _BuyNowContainerState extends State<BuyNowContainer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.5,
          1.0,
          curve: Curves.easeInOutBack,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.stop();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return SlideTransition(
      position: _offsetAnimation,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: _isExternalProduct(widget.product?.wooProduct?.type)
                ? _ExternalProductButton(product: widget.product)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Consumer<ProductViewModel>(
                        builder: (context, pvm, child) {
                          if (pvm.noVariationFoundError != null) {
                            return child;
                          }
                          // return if variation is in stock
                          if (pvm.selectedVariation != null) {
                            // ignore: avoid_bool_literals_in_conditional_expressions
                            if (pvm.selectedVariation.stockStatus != null
                                ? pvm.selectedVariation.stockStatus == 'instock'
                                : false) {
                              if (pvm.selectedVariation.price != null) {
                                if (pvm.selectedVariation.price.isNotEmpty) {
                                  // UI
                                  if (Config.productScreenBottomButtonsLayout ==
                                      'layout-1') {
                                    return _AddToCartButton.withoutText(
                                      productId: widget.product.id,
                                    );
                                  } else if (Config
                                          .productScreenBottomButtonsLayout ==
                                      'layout-2') {
                                    return Expanded(
                                      child: _AddToCartButton(
                                        productId: widget.product.id,
                                      ),
                                    );
                                  } else if (Config
                                          .productScreenBottomButtonsLayout ==
                                      'layout-3') {
                                    return Expanded(
                                      child: _AddToCartButton.withoutIcon(
                                        productId: widget.product.id,
                                      ),
                                    );
                                  } else {
                                    return _AddToCartButton.withoutText(
                                      productId: widget.product.id,
                                    );
                                  }
                                } else {
                                  return child;
                                }
                              } else {
                                return child;
                              }
                            }
                          } else {
                            // return if there is no variation for the product
                            if (pvm.currentProduct.inStock) {
                              if (pvm.currentProduct.productSelectedData
                                      .price !=
                                  null) {
                                if (pvm.currentProduct.productSelectedData.price
                                    .isNotEmpty) {
                                  if (Config.productScreenBottomButtonsLayout ==
                                      'layout-1') {
                                    return _AddToCartButton.withoutText(
                                      productId: widget.product.id,
                                    );
                                  } else if (Config
                                          .productScreenBottomButtonsLayout ==
                                      'layout-2') {
                                    return Expanded(
                                      child: _AddToCartButton(
                                        productId: widget.product.id,
                                      ),
                                    );
                                  } else if (Config
                                          .productScreenBottomButtonsLayout ==
                                      'layout-3') {
                                    return Expanded(
                                      child: _AddToCartButton.withoutIcon(
                                        productId: widget.product.id,
                                      ),
                                    );
                                  } else {
                                    return _AddToCartButton.withoutText(
                                      productId: widget.product.id,
                                    );
                                  }
                                } else {
                                  return child;
                                }
                              } else {
                                return child;
                              }
                            }
                          }

                          // else return the disabled button
                          return child;
                        },
                        child: const _AddToCartButton.disabled(),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Consumer<ProductViewModel>(
                          builder: (context, pvm, child) {
                            if (pvm.noVariationFoundError != null) {
                              return child;
                            }

                            // return if variation is in stock
                            if (pvm.selectedVariation != null) {
                              // ignore: avoid_bool_literals_in_conditional_expressions
                              if (pvm.selectedVariation.stockStatus != null
                                  ? pvm.selectedVariation.stockStatus ==
                                      'instock'
                                  : false) {
                                if (pvm.selectedVariation.price != null) {
                                  if (pvm.selectedVariation.price.isNotEmpty) {
                                    return _BuyNowButton(
                                        productId: widget.product.id);
                                  } else {
                                    return child;
                                  }
                                } else {
                                  return child;
                                }
                              }
                            } else {
                              // return if there is no variation for the product
                              if (pvm.currentProduct.inStock) {
                                if (pvm.currentProduct.productSelectedData
                                        .price !=
                                    null) {
                                  if (pvm.currentProduct.productSelectedData
                                      .price.isNotEmpty) {
                                    return _BuyNowButton(
                                      productId: widget.product.id,
                                    );
                                  } else {
                                    return child;
                                  }
                                } else {
                                  return child;
                                }
                              }
                            }

                            // else return the disabled button
                            return child;
                          },
                          child: const _BuyNowButton.disabled(),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Check if the product is external or affiliated
  bool _isExternalProduct(String value) {
    if (value == null) {
      return false;
    }
    if (value == 'external' || value == 'affiliate') {
      return true;
    }
    return false;
  }
}

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({
    Key key,
    @required this.productId,
  })  : showIcon = true,
        showText = true,
        super(key: key);

  const _AddToCartButton.withoutIcon({
    Key key,
    @required this.productId,
  })  : showIcon = false,
        showText = true,
        super(key: key);

  const _AddToCartButton.withoutText({
    Key key,
    @required this.productId,
  })  : showIcon = true,
        showText = false,
        super(key: key);

  const _AddToCartButton.disabled({Key key, this.productId})
      : showIcon = true,
        showText = true,
        super(key: key);

  final String productId;
  final bool showIcon;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    if (productId == null) {
      return const SizedBox();
    }
    return AnimButton(
      onTap: () {
        LocatorService.cartViewModel().addToCart(productId);
        UiController.itemAddedNotification(context: context);
      },
      child: Container(
        padding: ThemeGuide.padding16,
        decoration: BoxDecoration(
          color: _theme.backgroundColor,
          borderRadius: ThemeGuide.borderRadius10,
        ),
        child: _buildButton(context),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    if (showIcon && showText) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(EvaIcons.shoppingCartOutline),
          const SizedBox(width: 10),
          Text(
            S.of(context).addToCart,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else if (showIcon && !showText) {
      return const Icon(EvaIcons.shoppingCartOutline);
    } else if (!showIcon && showText) {
      return Text(
        S.of(context).addToCart,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      );
    } else {
      return const Icon(EvaIcons.shoppingCartOutline);
    }
  }
}

class _BuyNowButton extends StatelessWidget {
  const _BuyNowButton({
    Key key,
    @required this.productId,
  }) : super(key: key);

  const _BuyNowButton.disabled({this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = S.of(context);
    if (productId == null) {
      return Container(
        padding: ThemeGuide.padding16,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(80),
          borderRadius: ThemeGuide.borderRadius,
        ),
        child: Text(
          lang.outOfStock,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return GradientButton(
      onPress: () {
        LocatorService.cartViewModel().addToCart(productId);
        NavigationController.navigator
            .popUntilRouteWithName(TabbarNavigationRoute.name);
        LocatorService.tabbarController().jumpToCart();
      },
      gradient: ThemeGuide.isDarkMode(context)
          ? AppGradients.mainGradientDarkMode
          : AppGradients.mainGradient,
      child: Text(
        lang.buyNow,
        textAlign: TextAlign.center,
        style: _theme.textTheme.subtitle1.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ExternalProductButton extends StatelessWidget {
  const _ExternalProductButton({Key key, this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GradientButton(
        onPress: () async {
          final url = product?.wooProduct?.externalUrl;
          if (url != null) {
            if (await canLaunch(url)) {
              launch(url);
            } else {
              final lang = S.of(context);
              UiController.showErrorNotification(
                context: context,
                title: lang.couldNotLaunch,
                message: lang.errorLaunchUrl,
              );
            }
          } else {
            final lang = S.of(context);
            UiController.showErrorNotification(
              context: context,
              title: '${lang.no} ${lang.url} ${lang.found}',
              message: lang.errorNoUrl,
            );
          }
        },
        gradient: ThemeGuide.isDarkMode(context)
            ? AppGradients.mainGradientDarkMode
            : AppGradients.mainGradient,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              product.wooProduct.buttonText ?? S.of(context).buyNow,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(width: 10),
            const Icon(EvaIcons.externalLinkOutline, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
