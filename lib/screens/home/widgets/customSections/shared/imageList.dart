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
import 'package:flutter/widgets.dart';

import '../../../../../shared/image/extendedCachedImage.dart';

class ImageListContainer extends StatelessWidget {
  const ImageListContainer({
    Key key,
    @required this.images,
    this.isGrid = false,
    this.columns = 0,
  }) : super(key: key);

  const ImageListContainer.grid({
    Key key,
    @required this.images,
    this.isGrid = true,
    this.columns = 2,
  }) : super(key: key);

  final List<String> images;
  final bool isGrid;
  final int columns;

  @override
  Widget build(BuildContext context) {
    if (!isGrid) {
      return _ListLayout(images: images);
    }
    return _GridLayout(
      images: images,
      columns: columns,
    );
  }
}

class _GridLayout extends StatelessWidget {
  const _GridLayout({
    Key key,
    @required this.images,
    this.columns = 2,
  }) : super(key: key);
  final List<String> images;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return SizedBox(
      width: mq.size.width,
      child: Wrap(
        runSpacing: 8,
        spacing: 8,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: images.map<Widget>((i) {
          return SizedBox(
            height: mq.size.width / columns - 20,
            width: mq.size.width / columns - 20,
            child: ExtendedCachedImage(
              imageUrl: i,
              fit: BoxFit.cover,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ListLayout extends StatelessWidget {
  const _ListLayout({
    Key key,
    @required this.images,
  }) : super(key: key);
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return _ImageListItem(imageUrl: images[index]);
        },
      ),
    );
  }
}

class _ImageListItem extends StatelessWidget {
  const _ImageListItem({
    Key key,
    @required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: ExtendedCachedImage(imageUrl: imageUrl),
      ),
    );
  }
}
