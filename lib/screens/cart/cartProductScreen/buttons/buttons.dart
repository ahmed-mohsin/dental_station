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

import '../../../../generated/l10n.dart';
import '../../../../locator.dart';
import '../../../../shared/animatedButton.dart';
import '../../../../themes/theme.dart';
import '../../../../utils/style.dart';

class RemoveButton extends StatelessWidget {
  const RemoveButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final lang = S.of(context);
    return AnimButton(
      onTap: () {
        LocatorService.cartViewModel().removeCurrentFromCart();
        Navigator.of(context).pop();
      },
      child: Container(
        width: double.infinity,
        padding: ThemeGuide.padding16,
        decoration: BoxDecoration(
          color: _theme.backgroundColor,
          borderRadius: ThemeGuide.borderRadius,
        ),
        child: Text(
          lang.remove,
          textAlign: TextAlign.center,
          style: _theme.textTheme.button.copyWith(
            color: _theme.errorColor,
          ),
        ),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final lang = S.of(context);
    return AnimButton(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: ThemeGuide.borderRadius10,
          color: _theme.backgroundColor,
        ),
        child: UIStyle.isDarkMode(context)
            ? Text(
                lang.cancel,
                textAlign: TextAlign.center,
                style: _theme.textTheme.button.copyWith(
                  color: Colors.white,
                ),
              )
            : Text(
                lang.cancel,
                textAlign: TextAlign.center,
                style: _theme.textTheme.button,
              ),
      ),
    );
  }
}
