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

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import '../../constants/config.dart';
import '../../controllers/authController.dart';
import '../../controllers/navigationController.dart';
import '../../developer/dev.log.dart';
import '../../services/firebase_dynamic_links/firebase_dynamic_links.dart';
import '../../services/storage/localStorage.dart';
import '../../themes/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation, _textAnimation;

  @override
  void initState() {
    super.initState();

    // Controller that controls the animation.
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    // Type of animation to perform for `Logo`
    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    );

    // Animation for the text => `Name of the application`
    _textAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut)));

    _controller.addStatusListener(_handleAnimationStatus);

    // Starts the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Very Important to dispose the controller for optimization.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeGuide.isDarkMode(context)
              ? AppGradients.mainGradientDarkMode
              : AppGradients.mainGradient,
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'lib/assets/images/bag.png',
                width: 300,
                height: 300,
              ),
            ),
            const SizedBox(height: 50),
            FadeTransition(
              opacity: _textAnimation,
              child: const Text(
                Config.appName,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAnimationStatus(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      // Dynamic Links actions
      _onInitialLink();
      FirebaseDynamicLinksService.listen(
        listenSuccess: _onLinkSuccess,
        listenFailure: _onLinkFailure,
      );

      final bool _isUserLoggedIn = await AuthController.isCustomerLoggedIn();

      final initial =
          await LocalStorage.getString(LocalStorageConstants.INITIAL_INSTALL);
      final bool _initialInstall = initial == null || false;

      // If the user is logged in then go to `Home` else go to `Login`
      if (_isUserLoggedIn) {
        NavigationController.navigator.replace(const TabbarNavigationRoute());
      } else if (!_isUserLoggedIn && _initialInstall) {
        NavigationController.navigator.replace(const OnBoardingRoute());
      } else {
        final isGuestUser = await LocalStorage.getInt(
            LocalStorageConstants.shouldContinueWithoutLogin);
        if (isGuestUser != null && isGuestUser == 1) {
          NavigationController.navigator.replace(const TabbarNavigationRoute());
          return;
        }
        NavigationController.navigator.replace(const LoginRoute());
      }
    }
  }

  // Dynamic Links Integration  ------------------------------------------------
  Future<void> _onInitialLink() async {
    final result = await FirebaseDynamicLinksService.onInitialLink();
    if (result != null) {
      _goToProductDetails(
        queryParameters: result?.link?.queryParameters,
        fromInitial: true,
      );
    }
  }

  Future<void> _onLinkSuccess(PendingDynamicLinkData data) async {
    if (data != null) {
      _goToProductDetails(queryParameters: data?.link?.queryParameters);
    }
  }

  Future<void> _onLinkFailure(OnLinkErrorException error) async {
    Dev.error('Dynamic Links Error ${error?.message}');
  }

  void _goToProductDetails({
    Map<String, dynamic> queryParameters,
    bool fromInitial = false,
  }) {
    if (queryParameters != null && queryParameters['product_id'] != null) {
      if (fromInitial) {
        NavigationController.navigator.replaceAll([
          const TabbarNavigationRoute(),
          ProductScreenRoute(id: queryParameters['product_id'].toString()),
        ]);
      } else {
        NavigationController.navigator.push(ProductScreenRoute(
          id: queryParameters['product_id'].toString(),
        ));
      }
    } else {
      Dev.warn('Dynamic Links - Splash Screen no product_id found');
    }
  }
}
