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

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';

import '../../constants/config.dart';
import '../../developer/dev.log.dart';

abstract class FirebaseDynamicLinksService {
  static final instance = FirebaseDynamicLinks.instance;

  static Future<void> listen({
    @required Future<void> Function(PendingDynamicLinkData) listenSuccess,
    @required Future<void> Function(OnLinkErrorException) listenFailure,
  }) async {
    print('FirebaseDynamicLinksService listening');
    instance.onLink(
      onSuccess: listenSuccess,
      onError: listenFailure,
    );
  }

  static Future<PendingDynamicLinkData> onInitialLink() async {
    print('FirebaseDynamicLinksService onInitialLink');
    return await instance.getInitialLink();
  }

  /// Creates a short dynamic link for the application.
  static Future<Uri> createShortDynamicLink({
    Uri uri,
    String title,
    String description,
    String imageUrl,
  }) async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        socialMetaTagParameters: SocialMetaTagParameters(
          title: title,
          description: description,
          imageUrl: imageUrl != null ? Uri.tryParse(imageUrl) : null,
        ),
        uriPrefix: FirebaseDynamicLinksConfig.uriPrefix,
        link: uri,
        androidParameters: AndroidParameters(
          packageName: FirebaseDynamicLinksConfig.androidPackageName,
          minimumVersion: 0,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
        iosParameters: IosParameters(
          bundleId: FirebaseDynamicLinksConfig.iOSBundleId,
          minimumVersion: '0',
          appStoreId: FirebaseDynamicLinksConfig.appStoreId,
        ),
      );
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      return shortLink.shortUrl;
    } catch (e, s) {
      Dev.error('Create Short Dynamic Link error', error: e, stackTrace: s);
      return uri;
    }
  }
}
