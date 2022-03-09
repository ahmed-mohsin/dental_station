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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:woocommerce/models/coupon.dart';
import 'package:woocommerce/models/order_payload.dart';

import '../../../developer/dev.log.dart';
import '../../../locator.dart';
import '../../../models/cartProductModel.dart';
import '../../../models/productModel.dart';
import '../../../services/woocommerce/woocommerce.service.dart';
import '../../../utils/utils.dart';
import 'mixins/coupon_mixin.dart';
import 'mixins/customer_note.dart';
import 'states.dart';

class CartViewModel with ChangeNotifier, CouponMixin, CustomerNoteMixin {
  /// The cart error states
  CartErrorState _cartErrorState;

  CartErrorState get cartErrorState => _cartErrorState;

  /// WooCommerce Service for the cart actions
  final WooService wooService = LocatorService.wooService();

  /// Map of products to store all the products information in a single big
  /// object
  Map<String, CartProduct> _productsMap = {};

  /// Getter for products map
  Map<String, CartProduct> get productsMap => _productsMap;

  /// Tracks the total number of items in the cart
  int _totalItems = 0;

  int get totalItems => _totalItems;

  /// Total cost of all the products.
  double _totalCost = 0.0;

  String get subTotal => _totalCost.toStringAsFixed(2);
  double get discount {
    // Check for any applied coupon
    if (selectedCoupon.value != null &&
        isNotBlank(selectedCoupon.value.amount)) {
      if (selectedCoupon.value.couponType == WooCouponType.percentDiscount) {
        try {
          return double.tryParse(selectedCoupon.value.amount) *
              _totalCost /
              100;
        } catch (e) {
          Dev.error('cannot calculate coupon discount in percent', error: e);
          return 0;
        }
      } else {
        try {
          return double.tryParse(selectedCoupon.value.amount);
        } catch (e) {
          Dev.error('cannot calculate coupon discount as fixed', error: e);
          return 0;
        }
      }
    }
    return 0;
  }

  String get discountString => discount.toStringAsFixed(2);

  String get totalCost {
    final double result = _totalCost - discount;
    return result.toStringAsFixed(2);
  }

  CartViewModel() {
    getCart();
  }

  /// Reset the cart after user logs out
  void resetCart() {
    // Function Log
    Dev.debugFunction(
      functionName: 'resetCart',
      className: 'CartViewModel',
      fileName: 'viewModel.dart',
      start: true,
    );
    _cartErrorState = const CartEmptyState();
    _errorMessage = '';
    _productsMap = {};
    _totalItems = 0;
    _totalCost = 0.0;
    clearCustomerNote();
    clearCoupon();
    // Function Log
    Dev.debugFunction(
      functionName: 'resetCart',
      className: 'CartViewModel',
      fileName: 'viewModel.dart',
      start: false,
    );
  }

  /// Get the cart for the application
  Future<void> getCart() async {
    // Function Log
    Dev.debugFunction(
      functionName: 'getCart',
      className: 'CartViewModel',
      fileName: 'viewModel.dart',
      start: true,
    );

    try {
      final user = LocatorService.userProvider().user;

      if (user == null) {
        _onError('Could not find a user',
            errorState: const CartUserEmptyState());
        return;
      }

      final String cartKey = LocatorService.userProvider().user.id.toString();
      _onLoading(true);
      final CoCartEnhanced result =
          await wooService.cart.getCart(cartKey: cartKey);

      if (result == null || result.items == null || result.items.isEmpty) {
        _productsMap = {};
        _totalItems = 0;
        _calculateCost();
        _onError('', errorState: const CartEmptyState());
        return;
      }

      // If [CoCartEnhanced.items] are not present in productsMap
      // then fetch the products absent and add them
      _createCartProducts(result.items);

      _totalItems = _productsMap.length;

      _calculateCost();

      // Now update the UI
      _onSuccessful();

      // Function Log
      Dev.debugFunction(
        functionName: 'getCart',
        className: 'CartViewModel',
        fileName: 'viewModel.dart',
        start: false,
      );
    } on CoCartException catch (e) {
      Dev.error('Get Cart ${e.runtimeType}', error: e);
      if (e.runtimeType == CoCartNullArgumentsException) {
        _onError('', errorState: const CartEmptyState());
      } else {
        _onError(
          e.message,
          errorState: const CartLoginMessageState(),
        );
      }
    } catch (e, s) {
      _onError(
        Utils.renderException(e),
        errorState: const CartLoginMessageState(),
      );
      Dev.error('Get Cart error', error: e, stackTrace: s);
    }
  }

  /// Clears the cart data from the backend
  Future<bool> clearCart() async {
    // Function Log
    Dev.debugFunction(
      functionName: 'clearCart',
      className: 'CartViewModel',
      fileName: 'viewModel.dart',
      start: true,
    );
    try {
      resetCart();
      // Function Log
      Dev.debugFunction(
        functionName: 'clearCart',
        className: 'CartViewModel',
        fileName: 'viewModel.dart',
        start: false,
      );
      notifyListeners();
      return await wooService.cart.clearCart();
    } catch (e, s) {
      Dev.error('Clear cart', error: e, stackTrace: s);
      notifyListeners();
      return false;
    }
  }

  /// Takes in a product id --> search for the product in products provider -->
  /// create a `CartProduct` --> then save it in the cart map and update the
  /// reference list with [total items] and [total cost].
  Future<void> addToCart(String id) async {
    // Function Log
    Dev.debugFunction(
      functionName: 'addToCart',
      className: 'CartViewModel',
      fileName: 'viewModel.dart',
      start: true,
    );

    final Product p = LocatorService.productsProvider().productsMap[id];
    final CartProduct cartProduct = CartProduct.fromProduct(p);

    // Find if the product is already in the products map
    final bool isAlreadyPresent = _productsMap.containsKey(cartProduct.id);

    Dev.debug('Is already present: $isAlreadyPresent');

    if (isAlreadyPresent) {
      Dev.debug('Item already present, returning');
      Dev.info(_productsMap.toString());
      return;
    }

    // If the item is being added the first time then continue.
    try {
      _onLoading(true);
      final result = await wooService.cart.addItem(
        id: cartProduct.id,
        quantity: cartProduct.quantity,
      );

      if (result == null) {
        // Notify error and return
        _onError('', errorState: const CartGeneralErrorState());
        return;
      }

      // Adding to products map
      _productsMap.addAll({
        cartProduct.id: cartProduct,
      });

      /// Update total items in cart
      _totalItems = productsMap.length;

      /// Update the total cost
      _calculateCost();

      _onSuccessful();

      // Function Log
      Dev.debugFunction(
        functionName: 'addToCart',
        className: 'CartViewModel',
        fileName: 'viewModel.dart',
        start: false,
      );
    } on CoCartException catch (e) {
      _onError(e.message);
      _handleExceptionOnAddToSync(exception: e, cartProduct: cartProduct);
      Dev.error('CoCartException Add to cart', error: e);
    } catch (e, s) {
      // notify error
      _onError(Utils.renderException(e));
      Dev.error('Add to cart Error', error: e, stackTrace: s);
    }
  }

  Future<void> removeFromCart(String cartProductId) async {
    // Remove the product from the map as well
    final cartProduct = _productsMap[cartProductId];

    // Update the total cost
    if (cartProduct != null) {
      try {
        _onLoading(true);
        final result = await wooService.cart.removeItem(
          productId: int.parse(cartProductId),
        );

        if (!result) {
          _onError('', errorState: const CartGeneralErrorState());
          return;
        }

        // Remove product from products map
        _productsMap.remove(cartProductId);

        // Update total items in cart
        _totalItems = productsMap.length;

        _calculateCost();
        _onSuccessful();
      } on CoCartException catch (e) {
        _onError(e.message);
        Dev.error('Remove from cart error', error: e);
      } catch (e) {
        _onError(Utils.renderException(e));
        Dev.error('Remove from cart error: ', error: e);
      }
    } else {
      _onError('Did not find cart product in list');
    }
  }

  Future<void> increaseProductQuantity(String productId) async {
    // Function Log
    Dev.debugFunction(
      functionName: 'increaseProductQuantity',
      className: 'CartViewModel',
      fileName: 'viewModel.dart',
      start: true,
    );

    final CartProduct cp = _productsMap[productId];
    _onLoading(true);
    final bool result = await _updateCart(cp, increaseQuantity: true);
    if (result) {
      _onSuccessful();
      _calculateCost();
    } else {
      _onError('', errorState: const CartGeneralErrorState());
    }

    // Function Log
    Dev.debugFunction(
      functionName: 'increaseProductQuantity',
      className: 'CartViewModel',
      fileName: 'viewModel.dart',
      start: false,
    );
  }

  Future<void> decreaseProductQuantity(String productId) async {
    // Function Log
    Dev.debugFunction(
      functionName: 'decreaseProductQuantity',
      className: 'CartViewModel',
      fileName: 'viewModel.dart',
      start: true,
    );

    final CartProduct cp = _productsMap[productId];
    _onLoading(true);
    final bool result = await _updateCart(cp, decreaseQuantity: true);
    if (result) {
      _onSuccessful();
      _calculateCost();
    } else {
      _onLoading(false);
    }

    // Function Log
    Dev.debugFunction(
      functionName: 'decreaseProductQuantity',
      className: 'CartViewModel',
      fileName: 'viewModel.dart',
      start: false,
    );
  }

  //**********************************************************
  //  Private Helper functions
  //**********************************************************

  /// Update the cart based on product update
  Future<bool> _updateCart(
    CartProduct cp, {
    bool increaseQuantity = false,
    bool decreaseQuantity = false,
  }) async {
    final int oldQuantity = cp.quantity;
    try {
      // Function Log
      Dev.debugFunction(
        functionName: '_updateCart',
        className: 'CartViewModel',
        fileName: 'viewModel.dart',
        start: true,
      );

      if (increaseQuantity) {
        final bool canIncrease = cp.increaseQuantity();
        // If the quantity is not allowed to be increased then return
        if (!canIncrease) {
          Dev.debug('Increase quantity action not allowed returning');
          return false;
        }
        final result = await wooService.cart.updateItem(
          id: int.parse(cp.id),
          quantity: cp.quantity,
        );

        if (result == null || result == false) {
          // Notify error and return
          cp.setQuantity = oldQuantity;

          // Function Log
          Dev.debugFunction(
            functionName: '_updateCart',
            className: 'CartViewModel',
            fileName: 'viewModel.dart',
            start: false,
          );

          return false;
        }

        return result;
      }

      if (decreaseQuantity) {
        final bool canDecrease = cp.decreaseQuantity();
        if (!canDecrease) {
          Dev.debug('Decrease quantity action not allowed returning');
          return false;
        }
        final result = await wooService.cart.updateItem(
          id: int.parse(cp.id),
          quantity: cp.quantity,
        );

        if (result == null || result == false) {
          // Notify error and return
          cp.setQuantity = oldQuantity;

          // Function Log
          Dev.debugFunction(
            functionName: '_updateCart',
            className: 'CartViewModel',
            fileName: 'viewModel.dart',
            start: false,
          );

          return false;
        }
        return result;
      }

      // Function Log
      Dev.debugFunction(
        functionName: '_updateCart',
        className: 'CartViewModel',
        fileName: 'viewModel.dart',
        start: false,
      );

      return false;
    } on CoCartException catch (e) {
      cp.setQuantity = oldQuantity;
      Dev.error('Update Cart Error', error: e);
      // possibly show error to the user
      return false;
    } catch (e, s) {
      cp.setQuantity = oldQuantity;
      Dev.error('Update Cart Error', error: e, stackTrace: s);
      return false;
    }
  }

  /// Calculate the total cost from the list of products
  void _calculateCost() {
    if (_totalItems == 0) {
      _totalCost = 0;
      return;
    }
    double result = 0;
    for (final item in _productsMap.values) {
      if (item.price != null) {
        if (item.price.isNotEmpty) {
          result += double.parse(item.price) * item.quantity;
        }
      }
    }
    _totalCost = result;
  }

  /// If the cart item is not present in the list and the API
  /// returns an error, then according to the error status, perform
  /// further actions to keep carts in sync.
  void _handleExceptionOnAddToSync({
    CoCartException exception,
    CartProduct cartProduct,
  }) {
    if (exception.status == 'cocart_cannot_add_to_cart') {
      _productsMap.addAll({cartProduct.id: cartProduct});
    }
  }

  /// Creates cart products and adds them to the products map
  void _createCartProducts(List<CoCartProductItem> items) {
    // Function Log
    Dev.debugFunction(
      functionName: '_createCartProducts',
      className: 'CartViewModel',
      fileName: 'viewModel.dart',
      start: true,
    );

    final Map<String, CartProduct> _tempCpMap = {};

    if (items != null && items.isNotEmpty) {
      for (final cpi in items) {
        // Instance to add to the local cart
        CartProduct cp;

        Dev.debug('Working for CPI with id: ${cpi.id}');

        Dev.debug('CPI not present in cart, checking in products repo');
        // If the item is not present in local cart then check if it is
        // present in products repository
        final product = LocatorService.productsProvider()
            .productsMap[cpi.productId.toString()];

        // If item is present in product repo then create cartProduct from it
        // and add it to local cart product map
        if (product != null) {
          Dev.debug('CPI found in local products repo');
          // Check if the CoCartProductItem is of type variation or simple
          if (cpi.isVariable) {
            Dev.debug('CPI is variable, checking for variation in local repo');
            // If the cpi is variable then check if the product has this
            // variation in the application's state
            //
            // If the variation is found then populate the cart product data
            // with that variation else fetch the variation and add it to
            // product variation and then update the cart item.

            // Create the cart product and update with variation data
            cp = CartProduct.fromCoCartProductItem(cpi, ref: product);

            WooProductVariation variationObject;

            if (product.variations.isNotEmpty) {
              variationObject = product.variations.firstWhere(
                (element) => element.id == cpi.variationId,
                orElse: () => null,
              );
            }

            if (variationObject != null) {
              Dev.debug(
                  'Found the variation in local products repo, updating...');
              cp.updateWith(newVariation: variationObject);
            } else {
              Dev.debug('No variation found');
            }
          } else {
            // both are simple
            Dev.debug('CPI is simple product');

            cp = CartProduct.fromCoCartProductItem(cpi, ref: product);
          }
        } else {
          Dev.debug('CPI not present in local products repo');
          cp = CartProduct.fromCoCartProductItem(cpi);
        }

        if (cp != null) {
          _tempCpMap.addAll({cp.id: cp});
        }
      } // For loop ends
    }

    _productsMap = _tempCpMap;

    // Function Log
    Dev.debugFunction(
      functionName: '_createCartProducts',
      className: 'CartViewModel',
      fileName: 'viewModel.dart',
      start: false,
    );
  }

  // *********************************************************************
  //  Testing for managing current product solely from cart provider.
  // *********************************************************************

  CartProduct currentProduct;

  void setCurrentProduct(String productId) {
    final CartProduct p = _productsMap[productId];
    if (p != null) {
      log('Setting current product to cart');
      currentProduct = p;
    }
  }

  void removeCurrentFromCart() {
    log('removing current product from cart');
    removeFromCart(currentProduct.id);
    currentProduct = null;
  }

  /// Empty the cart. Usually performed after checkout payment is made.
  void emptyCart() {
    log('Empty the cart', name: 'Cart provider');
    _productsMap.clear();
    _totalCost = 0;
    _totalItems = 0;
    notifyListeners();
  }

  //**********************************************************
  // Public Helper functions
  //**********************************************************

  List<WPILineItems> createOrderWPILineItems() {
    try {
      final List<WPILineItems> result = [];
      for (final item in productsMap.values) {
        result.add(
          WPILineItems(
            productId: int.tryParse(item.productId ?? '0'),
            variationId: int.tryParse(item.variationId ?? '0'),
            quantity: item.quantity ?? 0,
          ),
        );
      }
      return result;
    } catch (e, s) {
      Dev.error(
        'Error Creating cart order line items',
        error: e,
        stackTrace: s,
      );
      return const [];
    }
  }

  /// Perform all the required validation tasks before going to the
  /// checkout screen.
  Future<bool> validateCartBeforeCheckout(BuildContext context) async {
    if (await verifyCouponBeforeCheckout(context)) {
      return true;
    }

    return false;
  }

  //**********************************************************
  //  Events
  //**********************************************************

  /// Loading event
  bool _isLoading = false;

  /// Get the loading value
  bool get isLoading => _isLoading;

  /// Success flag to verify if data fetching event was successfully.
  bool _isSuccess = false;

  /// Get the success value
  bool get isSuccess => _isSuccess;

  /// Flag to show if data is available
  bool _hasData = false;

  /// Getter for the data availability flag
  bool get hasData => _hasData;

  /// Error flag for any error while fetching
  bool _isError = false;

  /// Get the error value
  bool get isError => _isError;

  /// Error message
  String _errorMessage = '';

  /// Get the error message value
  String get errorMessage => _errorMessage;

  //**********************************************************
  //  Event Helper Functions
  //**********************************************************

  /// Changes the flags to reflect loading event and notify the listeners.
  void _onLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Changes the flags to reflect success and notify the listeners.
  void _onSuccessful({bool hasData = true}) {
    _isLoading = false;
    _isSuccess = true;
    _hasData = hasData;
    _isError = false;
    _errorMessage = '';
    notifyListeners();
  }

  /// Notifies about the error
  void _onError(String message, {CartErrorState errorState}) {
    _isLoading = false;
    _isSuccess = false;
    _isError = true;
    _errorMessage = message;
    _cartErrorState = errorState;
    notifyListeners();
  }
}
