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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../developer/dev.log.dart';
import '../../../generated/l10n.dart';
import '../../../services/woocommerce/woocommerce.service.dart';
import '../../../shared/widgets/error/noDataAvailable.dart';
import '../../../themes/theme.dart';

class VendorMoreInfoModal extends StatelessWidget {
  const VendorMoreInfoModal({
    Key key,
    @required this.vendor,
  }) : super(key: key);
  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    bool isVendorDataAvailable = true;
    if (vendor == null || vendor.address == null) {
      isVendorDataAvailable = false;
    }

    return ClipRRect(
      borderRadius: ThemeGuide.borderRadiusBottomSheet,
      child: Scaffold(
        body: !isVendorDataAvailable
            ? const NoDataAvailableImage()
            : _Body(vendor: vendor),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key key,
    @required this.vendor,
  }) : super(key: key);
  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Padding(
      padding: ThemeGuide.padding20,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Heading(title: lang.address),
            _Decorator(
              child: _BuildRow(
                icon: const Icon(Icons.location_on_rounded),
                text: Text(
                  '${vendor.address.street_1 ?? ''} ${vendor.address.street_2 ?? ''}\n${vendor.address.city ?? ''}, ${vendor.address.zip ?? ''}\n${vendor.address.state ?? ''}, ${vendor.address.country ?? ''}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _Heading(title: lang.contactUs),
            _Decorator(child: _ContactUs(vendor: vendor)),
          ],
        ),
      ),
    );
  }
}

//**********************************************************
// Helper Widgets
//**********************************************************

class _Heading extends StatelessWidget {
  const _Heading({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title ?? 'NA',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
    );
  }
}

class _Decorator extends StatelessWidget {
  const _Decorator({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ThemeGuide.padding10,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withAlpha(10),
        borderRadius: ThemeGuide.borderRadius10,
      ),
      child: child,
    );
  }
}

class _ContactUs extends StatelessWidget {
  const _ContactUs({Key key, this.vendor}) : super(key: key);
  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isNotBlank(vendor.phone))
          GestureDetector(
            onTap: () async {
              try {
                await launch('tel:${vendor.phone}');
              } catch (e, s) {
                Dev.error(
                  'Cannot open phone: ${vendor.phone}',
                  error: e,
                  stackTrace: s,
                );
              }
            },
            child: _BuildRow(
              icon: const Icon(Icons.phone_outlined),
              text: Text(
                vendor.phone,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (isNotBlank(vendor.phone)) const SizedBox(height: 10),
        if (isNotBlank(vendor.email))
          GestureDetector(
            onTap: () async {
              try {
                await launch('mailto:${vendor.email}');
              } catch (e, s) {
                Dev.error(
                  'Cannot open email: ${vendor.email}',
                  error: e,
                  stackTrace: s,
                );
              }
            },
            child: _BuildRow(
              icon: const Icon(Icons.email),
              text: Text(
                vendor.email,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (isNotBlank(vendor.email)) const SizedBox(height: 10),
        Wrap(
          children: [
            _BuildSocialButton(
              icon: const FaIcon(FontAwesomeIcons.facebook),
              url: vendor?.social?.fb,
            ),
            _BuildSocialButton(
              icon: const FaIcon(FontAwesomeIcons.instagram),
              url: vendor?.social?.instagram,
            ),
            _BuildSocialButton(
              icon: const FaIcon(FontAwesomeIcons.linkedin),
              url: vendor?.social?.linkedin,
            ),
            _BuildSocialButton(
              icon: const FaIcon(FontAwesomeIcons.pinterest),
              url: vendor?.social?.pinterest,
            ),
            _BuildSocialButton(
              icon: const FaIcon(FontAwesomeIcons.twitter),
              url: vendor?.social?.twitter,
            ),
            _BuildSocialButton(
              icon: const FaIcon(FontAwesomeIcons.youtube),
              url: vendor?.social?.youtube,
            ),
            _BuildSocialButton(
              icon: const FaIcon(FontAwesomeIcons.flickr),
              url: vendor?.social?.flickr,
            ),
          ],
        ),
      ],
    );
  }
}

class _BuildSocialButton extends StatelessWidget {
  const _BuildSocialButton({
    Key key,
    this.icon,
    this.url,
  }) : super(key: key);
  final Widget icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ?? const Icon(Icons.link),
      onPressed: () async {
        try {
          await launch(url);
        } catch (e, s) {
          Dev.error(
            'Cannot open url: $url',
            error: e,
            stackTrace: s,
          );
        }
      },
    );
  }
}

class _BuildRow extends StatelessWidget {
  const _BuildRow({
    Key key,
    this.icon,
    this.text,
  }) : super(key: key);

  final Widget icon;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 16),
        Expanded(child: text),
      ],
    );
  }
}
