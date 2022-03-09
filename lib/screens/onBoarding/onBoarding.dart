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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../controllers/navigationController.dart';
import '../../generated/l10n.dart';
import '../../services/storage/localStorage.dart';
import '../../themes/theme.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  bool isDone = false;

  @override
  void initState() {
    super.initState();

    // Controller that controls the animation.
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    // Type of animation to perform for `Logo`
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  static const PageDecoration _decoration = PageDecoration(
    bodyTextStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
    ),
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
    ),
  );

  List<PageViewModel> listPagesViewModel() {
    final lang = S.of(context);
    return [
      PageViewModel(
        title: lang.onBoardingPage1Title,
        body: lang.onBoardingPage1Body,
        image: const _BuildImage(assetUrl: 'lib/assets/svg/shoppingAll.svg'),
        decoration: _decoration,
      ),
      PageViewModel(
        title: lang.onBoardingPage2Title,
        body: lang.onBoardingPage2Body,
        image: const _BuildImage(assetUrl: 'lib/assets/svg/experience.svg'),
        decoration: _decoration,
      ),
      PageViewModel(
        title: lang.onBoardingPage3Title,
        body: lang.onBoardingPage3Body,
        image: const _BuildImage(assetUrl: 'lib/assets/svg/cards.svg'),
        decoration: _decoration,
      ),
      PageViewModel(
        title: lang.onBoardingPage4Title,
        body: lang.onBoardingPage4Body,
        image: const _BuildImage(assetUrl: 'lib/assets/svg/bill.svg'),
        decoration: _decoration,
      ),
    ];
  }

  static void _goToLogin() {
    NavigationController.navigator.replace(const LoginRoute());
  }

  static void _goToSignUp() {
    NavigationController.navigator.replace(const SignupRoute());
  }

  static void _goToTabbar() {
    NavigationController.navigator.replace(const TabbarNavigationRoute());
    LocalStorage.setString(LocalStorageConstants.INITIAL_INSTALL, 'done');
    LocalStorage.setInt(LocalStorageConstants.shouldContinueWithoutLogin, 1);
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    if (isDone) {
      _controller.forward();
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'lib/assets/svg/getStarted.svg',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                  child: Text(
                    lang.onBoardingCreateAccountMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _BuildButton(
                  title: lang.login,
                  color: LightTheme.mRed,
                  onPress: _goToLogin,
                ),
                _BuildButton(
                  title: lang.signup,
                  color: LightTheme.mYellow,
                  onPress: _goToSignUp,
                ),
                _BuildButton(
                  title: lang.continueWithoutLogin,
                  color: LightTheme.mPurple,
                  onPress: _goToTabbar,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return IntroductionScreen(
        showNextButton: true,
        pages: listPagesViewModel(),
        onDone: () async {
          await LocalStorage.setString(
              LocalStorageConstants.INITIAL_INSTALL, 'done');
          setState(() {
            isDone = true;
          });
        },
        showSkipButton: true,
        skip: Text(lang.skip),
        next: Text(lang.next),
        done: Text(
          lang.done,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: LightTheme.mBlue,
          color: Colors.black12,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      );
    }
  }
}

class _BuildImage extends StatelessWidget {
  const _BuildImage({Key key, this.assetUrl}) : super(key: key);

  final String assetUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          borderRadius: ThemeGuide.borderRadius10,
        ),
        child: SvgPicture.asset(
          assetUrl,
          height: 200,
          width: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _BuildButton extends StatelessWidget {
  const _BuildButton({Key key, this.title, this.color, this.onPress})
      : super(key: key);
  final String title;
  final Color color;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: CupertinoButton(
        color: color ?? LightTheme.mRed,
        onPressed: onPress,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
