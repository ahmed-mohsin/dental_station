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

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../controllers/uiController.dart';
import '../generated/l10n.dart';
import '../locator.dart';
import '../themes/theme.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: _theme.backgroundColor,
        borderRadius: ThemeGuide.borderRadius10,
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: false,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          alignLabelWithHint: true,
          hintText: S.of(context).search,
          prefixIcon: const Icon(EvaIcons.search),
        ),
        onChanged: _onTextChanged,
        onEditingComplete: () => _navigateToSearchScreen(context),
        maxLines: 1,
      ),
    );
  }

  void _navigateToSearchScreen(BuildContext context) {
    FocusManager.instance.primaryFocus.unfocus();
    if (LocatorService.searchViewModel().searchTerm.isNotEmpty) {
      // Navigate to search screen
      // NavigationController.navigator.push(Routes.searchScreen);
      LocatorService.tabbarController().jumpToSearch();
      LocatorService.searchViewModel().fetchData();
    } else {
      final lang = S.of(context);
      UiController.showNotification(
        context: context,
        title: lang.oops,
        message: lang.nothingToSearch,
      );
    }
  }

  static void _onTextChanged(String value) {
    LocatorService.searchViewModel().setSearchTerm = value;
  }
}
