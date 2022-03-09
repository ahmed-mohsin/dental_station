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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/config.dart';
import '../../themes/theme.dart';

class ExtendedCachedImage extends StatelessWidget {
  const ExtendedCachedImage({
    Key key,
    @required this.imageUrl,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.borderRadius,
    this.fit,
    this.color,
  }) : super(key: key);

  final String imageUrl;
  final Color shimmerBaseColor, shimmerHighlightColor;
  final BorderRadius borderRadius;
  final BoxFit fit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl.isEmpty) {
      if (borderRadius == null) {
        return LimitedBox(
          maxHeight: 100,
          child: Image.asset(Config.placeholderImageAssetPath),
        );
      } else {
        return LimitedBox(
          maxHeight: 100,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Image.asset(Config.placeholderImageAssetPath),
          ),
        );
      }
    } else {
      final ThemeData theme = Theme.of(context);
      return ClipRRect(
        borderRadius: borderRadius ?? ThemeGuide.borderRadius,
        child: CachedNetworkImage(
          color: color,
          imageUrl: imageUrl,
          fit: fit ?? BoxFit.cover,
          placeholder: (context, s) => LimitedBox(
            maxHeight: 100,
            child: Shimmer.fromColors(
              period: const Duration(milliseconds: 500),
              baseColor: shimmerBaseColor ?? theme.backgroundColor,
              highlightColor:
                  shimmerHighlightColor ?? theme.brightness == Brightness.dark
                      ? Colors.black12
                      : const Color(0xFFE0E0E0),
              child: LimitedBox(
                maxHeight: 100,
                child: Image.asset(
                  Config.placeholderImageAssetPath,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          errorWidget: (context, s, o) {
            return LimitedBox(
              maxHeight: 100,
              child: Image.asset(Config.placeholderImageAssetPath),
            );
          },
        ),
      );
    }
  }
}
