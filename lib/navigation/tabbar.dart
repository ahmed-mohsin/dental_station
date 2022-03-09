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

import 'package:badges/badges.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/tabbarController.dart';
import '../locator.dart';
import '../screens/cart/cart.dart';
import '../screens/cart/viewModel/viewModel.dart';
import '../screens/categories/categoriesScreen.dart';
import '../screens/home/home.dart';
import '../screens/profile/profile.dart';
import '../screens/search/search.dart';
import '../themes/theme.dart';

class TabbarNavigation extends StatelessWidget {
  const TabbarNavigation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return ChangeNotifierProvider<TabbarController>.value(
      value: LocatorService.tabbarController(),
      child: CupertinoTabScaffold(
        controller: LocatorService.tabbarController(),
        tabBar: CupertinoTabBar(
          activeColor: ThemeGuide.isDarkMode(context)
              ? AppColors.tabbarDark
              : AppColors.tabbar,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(EvaIcons.homeOutline),
              activeIcon: ActiveTab(icon: Icon(EvaIcons.home)),
            ),
            const BottomNavigationBarItem(
              icon: Icon(EvaIcons.gridOutline),
              activeIcon: ActiveTab(icon: Icon(EvaIcons.grid)),
            ),
            const BottomNavigationBarItem(
              icon: Icon(EvaIcons.searchOutline),
              activeIcon: ActiveTab(icon: Icon(EvaIcons.search)),
            ),
            BottomNavigationBarItem(
              icon: Selector<CartViewModel, int>(
                selector: (context, d) => d.totalItems,
                builder: (context, count, w) {
                  if (count == null || count <= 0) {
                    return w;
                  }
                  return Badge(
                    toAnimate: false,
                    badgeColor: _theme.colorScheme.secondary,
                    badgeContent: Text(
                      count.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: w,
                  );
                },
                child: const Icon(EvaIcons.shoppingCartOutline),
              ),
              activeIcon: Selector<CartViewModel, int>(
                selector: (context, d) => d.totalItems,
                builder: (context, count, w) {
                  if (count == null || count <= 0) {
                    return w;
                  }
                  return Badge(
                    animationType: BadgeAnimationType.fade,
                    badgeColor: _theme.colorScheme.secondary,
                    badgeContent: Text(
                      count.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: w,
                  );
                },
                child: const ActiveTab(icon: Icon(EvaIcons.shoppingCart)),
              ),
            ),
            const BottomNavigationBarItem(
              icon: Icon(EvaIcons.personOutline),
              activeIcon: ActiveTab(icon: Icon(EvaIcons.person)),
            ),
          ],
          backgroundColor: _theme.scaffoldBackgroundColor,
          border: const Border(
            top: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
          ),
          onTap: (int index) {
            LocatorService.tabbarController().index = index;
          },
        ),
        tabBuilder: (context, i) {
          switch (i) {
            case 0:
              return const Home();
              break;

            case 1:
              return const CategoriesScreen();
              break;

            case 2:
              return const SearchScreen();
              break;

            case 3:
              return const Cart();
              break;

            case 4:
              return const Profile();
              break;

            default:
              return const Home();
              break;
          }
        },
      ),
    );
  }
}

class ActiveTab extends StatelessWidget {
  const ActiveTab({Key key, this.icon}) : super(key: key);
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, widget) {
        return Transform.scale(
          scale: value,
          child: widget,
        );
      },
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return ThemeGuide.isDarkMode(context)
              ? AppGradients.tabbarIconGradientDarkMode.createShader(bounds)
              : AppGradients.tabbarIconGradient.createShader(bounds);
        },
        child: icon,
      ),
    );
  }
}
