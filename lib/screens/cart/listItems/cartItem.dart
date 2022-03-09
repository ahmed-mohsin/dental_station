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

import '../../../controllers/navigationController.dart';
import '../../../generated/l10n.dart';
import '../../../locator.dart';
import '../../../models/models.dart';
import '../../../shared/image/extendedCachedImage.dart';
import '../../../shared/widgets/itemAttributes.dart';
import '../../../themes/theme.dart';
import '../../../utils/style.dart';
import '../../../utils/utils.dart';

class CartItem extends StatefulWidget {
  const CartItem({
    Key key,
    @required this.cartProduct,
  }) : super(key: key);

  final CartProduct cartProduct;

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  /// Check if the cart product is 'simple' or 'variable' type.
  /// In simple product type if the [cartProduct.product] is empty
  /// then fetch the product details using the `products Provider` and
  /// add that product to this [cartProduct] instance.
  ///
  /// In variation product, if the [cartProduct.product] is empty then
  /// fetch the product and the selected variation as well else only
  /// fetch the product variation and add it to the
  /// [cartProduct.product.variationList] and update the widget.
  Future<void> init() async {
    if (widget.cartProduct.isVariable) {
      // perform variable product tasks
      if (widget.cartProduct.product == null) {
        // fetch the product data as well as variation in a single request
        _fetchProductAndVariation();
      } else {
        // only get the variation data as the product is already available
        _fetchProductVariation();
      }
    } else {
      // perform simple products tasks
      if (widget.cartProduct.product == null) {
        _fetchProduct();
      }
    }
  }

  /// Fetch the product variation only
  Future<void> _fetchProductVariation() async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
        });
      }

      final int productId = int.parse(widget.cartProduct.productId);
      final int variationId = int.parse(widget.cartProduct.variationId);

      final resultOfVariation = await LocatorService.productsProvider()
          .fetchProductVariation(productId, variationId);

      if (resultOfVariation != null) {
        widget.cartProduct.updateWith(newVariation: resultOfVariation);
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  /// Fetch the product and variation together
  Future<void> _fetchProductAndVariation() async {
    try {
      // fetch the product data
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
      final int productId = int.parse(widget.cartProduct.productId);
      final int variationId = int.parse(widget.cartProduct.variationId);

      final resultOfProduct =
          await LocatorService.productsProvider().fetchProductsById(
        [productId],
      );

      if (resultOfProduct.isNotEmpty) {
        widget.cartProduct.updateWith(newProduct: resultOfProduct.first);
        if (mounted) {
          setState(() {});
        }
      }

      final resultOfVariation = await LocatorService.productsProvider()
          .fetchProductVariation(productId, variationId);

      if (resultOfVariation != null) {
        widget.cartProduct.updateWith(newVariation: resultOfVariation);
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  /// Fetch the simple product
  Future<void> _fetchProduct() async {
    // fetch the product data
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    final result = await LocatorService.productsProvider().fetchProductsById(
      [int.parse(widget.cartProduct.productId)],
    );

    if (result.isNotEmpty) {
      widget.cartProduct.updateWith(newProduct: result.first);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Column(
        children: [
          _CartItemBody(cartProduct: widget.cartProduct),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: LinearProgressIndicator(minHeight: 2),
          )
        ],
      );
    } else {
      return _CartItemBody(cartProduct: widget.cartProduct);
    }
  }
}

class _CartItemBody extends StatelessWidget {
  const _CartItemBody({
    Key key,
    @required this.cartProduct,
  }) : super(key: key);

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        NavigationController.navigator.push(
          ProductScreenRoute(id: cartProduct.productId),
        );
      },
      child: Container(
        padding: ThemeGuide.padding,
        decoration: BoxDecoration(
          color: _theme.backgroundColor,
          borderRadius: ThemeGuide.borderRadius,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child:
                      ExtendedCachedImage(imageUrl: cartProduct.displayImage),
                ),
                Expanded(child: _InfoContainer(cartProduct: cartProduct)),
              ],
            ),
            const SizedBox(height: 10),
            _PriceAndRemoveButton(theme: _theme, cartProduct: cartProduct),
          ],
        ),
      ),
    );
  }
}

class ReviewCartItem extends StatelessWidget {
  const ReviewCartItem({
    Key key,
    @required this.cartProduct,
  }) : super(key: key);

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      padding: ThemeGuide.padding,
      decoration: BoxDecoration(
        color: _theme.backgroundColor,
        borderRadius: ThemeGuide.borderRadius,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: ExtendedCachedImage(imageUrl: cartProduct.displayImage),
              ),
              Expanded(
                child: _InfoContainer.review(cartProduct: cartProduct),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: ThemeGuide.padding10,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _theme.disabledColor.withAlpha(10),
              borderRadius: ThemeGuide.borderRadius,
            ),
            child: Text(
              Utils.formatPrice(cartProduct.price),
              style: _theme.textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoContainer extends StatelessWidget {
  const _InfoContainer({
    Key key,
    @required this.cartProduct,
  })  : showQuantityControls = true,
        super(key: key);

  // ignore: unused_element
  const _InfoContainer.review({
    Key key,
    @required this.cartProduct,
  })  : showQuantityControls = false,
        super(key: key);

  final CartProduct cartProduct;
  final bool showQuantityControls;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            cartProduct.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 10),
          if (cartProduct.product == null ||
              (cartProduct.product.wooProduct.soldIndividually != null &&
                  cartProduct.product.wooProduct.soldIndividually == true) ||
              !showQuantityControls)
            Text(
              '${lang.quantity}:  ${cartProduct.quantity}',
              style: UIStyle.isDarkMode(context)
                  ? const TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    )
                  : const TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
            )
          else
            _Quantity(cartProduct: cartProduct),
          if (cartProduct?.attributes?.isNotEmpty ?? false)
            RenderAttributes(attributes: cartProduct.attributes),
        ],
      ),
    );
  }
}

class _PriceAndRemoveButton extends StatelessWidget {
  const _PriceAndRemoveButton({
    Key key,
    @required ThemeData theme,
    @required this.cartProduct,
  })  : _theme = theme,
        super(key: key);

  final ThemeData _theme;
  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: ThemeGuide.padding10,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _theme.disabledColor.withAlpha(10),
              borderRadius: ThemeGuide.borderRadius,
            ),
            child: Text(
              Utils.formatPrice(cartProduct.price),
              style: _theme.textTheme.subtitle1,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            LocatorService.cartViewModel().removeFromCart(cartProduct.id);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            padding: ThemeGuide.padding5,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _theme.errorColor.withAlpha(50),
              borderRadius: ThemeGuide.borderRadius5,
            ),
            child: Icon(
              Icons.close,
              color: _theme.errorColor.withAlpha(200),
            ),
          ),
        ),
      ],
    );
  }
}

class _Quantity extends StatelessWidget {
  const _Quantity({
    Key key,
    @required this.cartProduct,
  }) : super(key: key);

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '${lang.quantity}:  ${cartProduct.quantity}',
            style: UIStyle.isDarkMode(context)
                ? const TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                    fontWeight: FontWeight.w500,
                  )
                : const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
          ),
        ),
        GestureDetector(
          child: const Icon(
            Icons.add,
            size: 16,
          ),
          onTap: () {
            LocatorService.cartViewModel()
                .increaseProductQuantity(cartProduct.id);
          },
        ),
        const SizedBox(width: 20),
        GestureDetector(
          child: const Icon(
            Icons.remove,
            size: 16,
          ),
          onTap: () {
            LocatorService.cartViewModel()
                .decreaseProductQuantity(cartProduct.id);
          },
        ),
      ],
    );
  }
}
