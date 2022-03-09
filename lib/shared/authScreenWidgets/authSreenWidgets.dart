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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quiver/strings.dart';

import '../../generated/l10n.dart';
import '../../themes/theme.dart';
import '../../utils/style.dart';
import '../gradientButton/gradientButton.dart';

class HeaderImage extends StatelessWidget {
  const HeaderImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 80,
            maxWidth: 80,
          ),
          padding: ThemeGuide.padding,
          decoration: const BoxDecoration(
            borderRadius: ThemeGuide.borderRadius16,
            gradient: AppGradients.mainGradient,
          ),
          child: Center(
            child: Image.asset(
              'lib/assets/images/bag-100x100.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key key,
    @required this.title,
    this.body,
  }) : super(key: key);

  final String title, body;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: _theme.textTheme.headline6,
          ),
          const SizedBox(height: 5),
          if (body.isNotEmpty)
            Text(body,
                style: _theme.textTheme.subtitle2
                    .copyWith(color: _theme.disabledColor)),
        ],
      ),
    );
  }
}

class FooterQuestion extends StatelessWidget {
  const FooterQuestion({
    Key key,
    @required this.questionText,
    @required this.buttonLabel,
    @required this.onPress,
  }) : super(key: key);

  final String questionText, buttonLabel;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            questionText,
            style: _theme.textTheme.caption,
          ),
          const SizedBox(height: 5),
          TextButton(
            child: Text(buttonLabel, style: _theme.textTheme.button),
            onPressed: () {
              FocusScope.of(context).unfocus();
              onPress();
            },
          ),
        ],
      ),
    );
  }
}

class Submit extends StatelessWidget {
  const Submit({
    Key key,
    @required this.isLoading,
    @required this.onPress,
    @required this.label,
  }) : super(key: key);

  final bool isLoading;
  final Function onPress;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final lang = S.of(context);
    return Container(
      // margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      child: isLoading
          ? const Loading()
          : GradientButton(
              onPress: () {
                FocusScope.of(context).unfocus();
                onPress();
              },
              gradient: ThemeGuide.isDarkMode(context)
                  ? AppGradients.mainGradientDarkMode
                  : AppGradients.mainGradient,
              child: Text(
                label ?? lang.submit,
                style: _theme.textTheme.button.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}

class ShowError extends StatelessWidget {
  const ShowError({Key key, this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    if (isBlank(text)) {
      return const SizedBox(height: 20);
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          text,
          style: _theme.textTheme.bodyText1.copyWith(
            color: _theme.errorColor,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: UIStyle.isDarkMode(context)
          ? const Center(
              child: SpinKitCircle(
                color: Colors.white,
                duration: Duration(seconds: 1),
              ),
            )
          : const Center(
              child: SpinKitCircle(
                color: Colors.black,
                duration: Duration(seconds: 1),
              ),
            ),
    );
  }
}
