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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/config.dart';
import '../../controllers/navigationController.dart';
import '../../generated/l10n.dart';
import '../../services/firebase_dynamic_links/firebase_dynamic_links.dart';
import '../../shared/widgets/bottomSheet/languageChange.bottomSheet.dart';
import '../../shared/widgets/listTiles/settingsItemTile.dart';
import '../../themes/theme.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Builder(builder: (context) {
              return SettingsItemTile(
                title: lang.languages,
                iconData: Icons.language_rounded,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => LanguageChangeBottomSheet(),
                  );
                },
              );
            }),
            SettingsItemTile(
              title: lang.contactUs,
              iconData: Icons.call,
              onTap: _goToContact,
            ),
            SettingsItemTile(
              title: lang.termsOfService,
              iconData: Icons.miscellaneous_services_rounded,
              onTap: _termsOfService,
            ),
            SettingsItemTile(
              title: lang.privacyPolicy,
              iconData: Icons.lock,
              onTap: _privacyPolicy,
            ),
            if (Config.enabledShareApp)
              SettingsItemTile(
                title: lang.shareApp,
                iconData:
                    Platform.isAndroid ? Icons.share : Icons.ios_share_rounded,
                onTap: () => _shareApp(context, lang),
              ),
            SettingsItemTile(
              title: lang.aboutUs,
              iconData: Icons.info_outline_rounded,
              onTap: () async {
                final PackageInfo packageInfo =
                    await PackageInfo.fromPlatform();
                showAboutDialog(
                  context: context,
                  applicationIcon: ClipRRect(
                    borderRadius: ThemeGuide.borderRadius10,
                    child: Image.asset(
                      Config.appIconPath,
                      height: 100,
                      width: 100,
                    ),
                  ),
                  applicationName: packageInfo.appName,
                  applicationVersion: '${lang.version} ${packageInfo.version}',
                  applicationLegalese: packageInfo.packageName,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Future<void> _shareApp(BuildContext context, S lang) async {
    if (Config.enableShareAppThroughFirebaseDynamicLinks) {
      final Uri shareUri =
          await FirebaseDynamicLinksService.createShortDynamicLink(
        uri: Uri.tryParse(Config.shareAppLink),
        title: Config.enableShareAppFirebaseDynamicLinksTitle
            ? '${lang.download} ${Config.appName} ${lang.now}'
            : null,
        imageUrl: Config.shareAppImageUrl,
      );

      Share.share(
        '${lang.download} ${Config.appName} ${lang.now}\n${shareUri.toString()}',
        subject: '${lang.download} ${Config.appName} ${lang.now}',
      );
    } else {
      Share.share(
        '${lang.download} ${Config.appName} ${lang.now}\n${Config.shareAppLink}',
        subject: '${lang.download} ${Config.appName} ${lang.now}',
      );
    }
  }

  static void _goToContact() {
    NavigationController.navigator.push(const ContactScreenRoute());
  }

  static Future<void> _termsOfService() async {
    if (await canLaunch(Config.termsOfServiceUrl)) {
      await launch(Config.termsOfServiceUrl);
    }
  }

  static Future<void> _privacyPolicy() async {
    if (await canLaunch(Config.privacyPolicyUrl)) {
      await launch(Config.privacyPolicyUrl);
    }
  }
}
