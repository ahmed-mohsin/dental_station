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

import '../generated/l10n.dart';
import '../themes/theme.dart';

class TabbarController extends CupertinoTabController {
  /// Jumps the tabbar to home which is at index `0`
  void jumpToHome() {
    index = 0;
  }

  void jumpToFavorites() {
    index = 1;
  }

  void jumpToSearch() {
    index = 2;
  }

  void jumpToCart() {
    index = 3;
  }

  void jumpToProfile() {
    index = 4;
  }

  /// Handle the bak event from any tab.
  /// Checks for the tab index and manage the back event accordingly
  Future<bool> handleTabBackEvent() {
    switch (index) {
      case 0:
        return Future.value(true);
        break;

      case 1:
        index = 0;
        return Future.value(false);
        break;

      case 2:
        index = 0;
        return Future.value(false);
        break;

      case 3:
        index = 0;
        return Future.value(false);
        break;

      default:
        index = 0;
        return Future.value(false);
    }
  }

  /// Handles the exit event from home screen
  Future<bool> handleExitEvent(BuildContext context) {
    final lang = S.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: ThemeGuide.borderRadius10,
          ),
          title: Text(lang.exitMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop<bool>(context, true),
              child: Text(lang.yes),
            ),
            TextButton(
              onPressed: () => Navigator.pop<bool>(context, false),
              child: Text(lang.no),
            ),
          ],
        );
      },
    );
  }
}
