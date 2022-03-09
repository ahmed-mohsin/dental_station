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
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';

import '../../controllers/navigationController.dart';
import '../../generated/l10n.dart';
import '../../locator.dart';
import '../../providers/themeProvider.dart';
import '../../providers/userProvider.dart';
import '../../themes/gradients.dart';
import '../../themes/themeGuide.dart';
import '../login/enums/loginFromXEnum.dart';

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => LocatorService.tabbarController().handleTabBackEvent(),
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: ThemeGuide.isDarkMode(context)
                    ? AppGradients.mainGradientDarkMode
                    : AppGradients.mainGradient,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(100),
                ),
              ),
            ),
            const ProfileInfo(),
          ],
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        top: 40,
        right: 30,
        left: 30,
        bottom: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _HeaderInfo(),
          const SizedBox(height: 30),
          _ProfileListTile(
            title: lang.my + ' ' + lang.orders,
            subtitle: lang.myOrdersSubtitle,
            onTap: _goToMyOrders,
            icon: EvaIcons.inbox,
          ),
          _ProfileListTile(
            title: lang.favorites,
            subtitle: lang.favorites + ' ' + lang.items,
            onTap: _goToFavorites,
            icon: Icons.favorite,
          ),
          _ProfileListTile(
            title: lang.profile + ' ' + lang.information,
            subtitle: lang.profileInformationSubtitle,
            onTap: _goToEditProfile,
            icon: Icons.verified_user,
          ),
          _ProfileListTile(
            title: lang.notifications,
            subtitle: lang.manageNotifications,
            onTap: _goToNotifications,
            icon: Icons.notifications_active_rounded,
          ),
          _ProfileListTile(
            title: lang.account,
            subtitle: lang.accountSettingsSubtitle,
            onTap: _goToAccountSettings,
            icon: Icons.account_box,
          ),
          _ProfileListTile(
            title: lang.settings,
            subtitle: lang.settingsSubtitle,
            onTap: _goToSettings,
            icon: EvaIcons.settings,
          ),
          const _ChangeThemeTile(),
        ],
      ),
    );
  }

  static void _goToFavorites() {
    NavigationController.navigator.push(
      const FavoritesRoute(),
      onFailure: (_) {
        NavigationController.navigator.push(
          LoginFromXRoute(loginFrom: LoginFrom.myOrders),
        );
      },
    );
  }

  static void _goToMyOrders() {
    NavigationController.navigator.push(
      const MyOrdersRoute(),
      onFailure: (_) {
        NavigationController.navigator.push(
          LoginFromXRoute(loginFrom: LoginFrom.myOrders),
        );
      },
    );
  }

  static void _goToEditProfile() {
    NavigationController.navigator.push(
      const EditProfileRoute(),
      onFailure: (_) {
        NavigationController.navigator.push(
          LoginFromXRoute(loginFrom: LoginFrom.editProfile),
        );
      },
    );
  }

  static void _goToAccountSettings() {
    NavigationController.navigator.push(const AccountSettingsRoute());
  }

  static void _goToSettings() {
    NavigationController.navigator.push(const SettingsRoute());
  }

  static void _goToNotifications() {
    NavigationController.navigator.push(const NotificationScreenRoute());
  }
}

///
/// ## `Description`
///
/// Container for image, name and email.
///
class _HeaderInfo extends StatelessWidget {
  const _HeaderInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          color: _theme.backgroundColor,
          borderRadius: ThemeGuide.borderRadius20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Selector<UserProvider, String>(
              selector: (context, d) => d.user?.name,
              child: const SizedBox(),
              builder: (context, name, w) {
                if (isNotBlank(name)) {
                  return Flexible(
                    child: Text(
                      name,
                      style: _theme.textTheme.headline5,
                    ),
                  );
                }
                return w;
              },
            ),
            const SizedBox(height: 5),
            Selector<UserProvider, String>(
              selector: (context, d) => d.user?.email,
              child: const _ProfileLoginButton(),
              builder: (context, email, w) {
                if (isNotBlank(email)) {
                  return Flexible(
                    child: Text(
                      email,
                      style: _theme.textTheme.subtitle1,
                    ),
                  );
                }
                return w;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileLoginButton extends StatelessWidget {
  const _ProfileLoginButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return OutlinedButton.icon(
      onPressed: _login,
      icon: const Icon(Icons.login),
      label: Text(lang.login),
    );
  }

  static void _login() {
    NavigationController.navigator.push(const LoginRoute());
  }
}

///
/// ## `Description`
///
/// Small item card for profile navigation
///
class _ProfileListTile extends StatelessWidget {
  const _ProfileListTile({
    Key key,
    @required this.title,
    @required this.subtitle,
    this.icon = Icons.title,
    this.onTap,
  }) : super(key: key);

  final String title, subtitle;
  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: ThemeGuide.padding,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: ThemeGuide.borderRadius,
          color: _theme.backgroundColor,
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: ThemeGuide.borderRadius,
                color: _theme.disabledColor.withAlpha(20),
              ),
              child: Center(child: Icon(icon)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: _theme.textTheme.subtitle1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: _theme.textTheme.caption.copyWith(
                        color: _theme.disabledColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: _theme.disabledColor,
            )
          ],
        ),
      ),
    );
  }
}

class _ChangeThemeTile extends StatelessWidget {
  const _ChangeThemeTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final lang = S.of(context);
    return Container(
      padding: ThemeGuide.padding,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: ThemeGuide.borderRadius,
        color: _theme.backgroundColor,
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: ThemeGuide.borderRadius,
              color: _theme.disabledColor.withAlpha(20),
            ),
            child: const Center(child: Icon(Icons.color_lens)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                lang.dark + ' ' + lang.mode,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Consumer<ThemeProvider>(
            builder: (context, provider, _) {
              final bool value = provider.themeMode == ThemeMode.dark ?? false;
              return Switch(
                value: value,
                onChanged: (_) {
                  provider.toggleThemeMode();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
