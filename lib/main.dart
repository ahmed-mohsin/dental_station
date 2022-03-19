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

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'constants/config.dart';
import 'controllers/navigationController.dart';
import 'generated/l10n.dart';
import 'locator.dart';
import 'providers/language.provider.dart';
import 'providers/themeProvider.dart';
import 'services/pushNotification/pushNotification.dart';
import 'themes/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
  ));

  // Set orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  setupLocator();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  await PushNotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocatorService.themeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocatorService.productsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocatorService.userProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocatorService.cartViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return Consumer<LanguageProvider>(
              builder: (context, langProvider, _) {
            return MaterialApp.router(
              title: Config.appName,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              scrollBehavior: const CupertinoScrollBehavior(),
              supportedLocales: S.delegate.supportedLocales,
              locale: langProvider.locale,
              debugShowCheckedModeBanner: false,
              routerDelegate: NavigationController.navigator.delegate(),
              routeInformationParser:
                  NavigationController.navigator.defaultRouteParser(),
              theme: themeProvider.themeMode == ThemeMode.dark
                  ? CustomTheme.darkTheme
                  : CustomTheme.lightTheme,
            );
          });
        },
      ),
    );
  }
}
