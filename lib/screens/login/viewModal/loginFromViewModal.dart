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
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../controllers/authController.dart';
import '../../../controllers/navigationController.dart';
import '../../../developer/dev.log.dart';
import '../../../locator.dart';
import '../../../utils/utils.dart';
import '../enums/loginFromXEnum.dart';

class LoginFromXViewModal with ChangeNotifier {
  //**********************************************************
  // Data Holder Fields
  //**********************************************************

  /// Holds the email value of the login form
  String email = '';

  /// Holds the password value of the login form
  String password = '';

  /// Form key for the login form
  GlobalKey<FormBuilderState> _formKey;

  /// Getter for form key
  GlobalKey<FormBuilderState> get formKey => _formKey;

  /// Data to tell from where this screen was called.
  LoginFrom loginFrom = LoginFrom.undefined;

  /// Default Constructor
  LoginFromXViewModal(this.loginFrom) {
    _formKey = GlobalKey<FormBuilderState>();
  }

  @override
  void dispose() {
    _formKey = null;
    super.dispose();
  }

  Future<void> submit() async {
    if (_formKey.currentState.validate()) {
      // Start the indicator
      _onLoading(true);

      // Authenticate
      try {
        final result = await AuthController.login(email, password);

        // If userId is not empty then set the userId in the provider
        if (result.id != null) {
          _onSuccessful();
          onLoginSuccess();
          return;
        }

        _onError('');
      } on PlatformException catch (e, s) {
        Dev.error('Login From X View Modal Error', error: e, stackTrace: s);
        _onError(Utils.renderException(e));
      } catch (e, s) {
        _onError(Utils.renderException(e));
        Dev.error('Login Error From X View Modal', error: e, stackTrace: s);
      }
    }
  }

  /// Perform the actions required after a successful login attempt
  void onLoginSuccess() {
    performNavigationAction();
    LocatorService.userProvider().notifyListeners();
  }

  /// Navigates to the desired screen after the login attempt is successful
  void performNavigationAction() {
    switch (loginFrom) {
      case LoginFrom.myOrders:
        NavigationController.navigator.replaceAll([
          const TabbarNavigationRoute(),
          const MyOrdersRoute(),
        ]);
        break;
      case LoginFrom.editProfile:
        NavigationController.navigator.replaceAll([
          const TabbarNavigationRoute(),
          const EditProfileRoute(),
        ]);
        break;

      case LoginFrom.shippingAddress:
        NavigationController.navigator.replaceAll([
          const TabbarNavigationRoute(),
          const AccountSettingsRoute(),
          AddressScreenRoute(isShipping: true),
        ]);
        break;

      case LoginFrom.billingAddress:
        NavigationController.navigator.replaceAll([
          const TabbarNavigationRoute(),
          const AccountSettingsRoute(),
          AddressScreenRoute(isShipping: false),
        ]);
        break;
      case LoginFrom.changePassword:
        NavigationController.navigator.replaceAll([
          const TabbarNavigationRoute(),
          const AccountSettingsRoute(),
          const ChangePasswordRoute(),
        ]);
        break;
      case LoginFrom.myPoints:
        NavigationController.navigator.replaceAll([
          const TabbarNavigationRoute(),
          const AccountSettingsRoute(),
          const PointsScreenRoute(),
        ]);
        break;
      case LoginFrom.customerDownloads:
        NavigationController.navigator.replaceAll([
          const TabbarNavigationRoute(),
          const AccountSettingsRoute(),
          const DownloadsScreenRoute(),
        ]);
        break;

      default:
        AuthController.navigateToTabbar();
    }
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
  void _onError(String message) {
    _isLoading = false;
    _isSuccess = false;
    _isError = true;
    _errorMessage = message;
    notifyListeners();
  }
}
