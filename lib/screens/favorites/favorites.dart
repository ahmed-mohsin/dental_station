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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../locator.dart';
import '../../providers/products/products.provider.dart';
import '../../providers/utils/viewStateController.dart';
import '../../themes/theme.dart';
import 'listItems/itemCard.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final lang = S.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(lang.favorites),
      ),
      body: SizedBox(
        height: mq.size.height,
        width: mq.size.width,
        child: ChangeNotifierProvider<ProductsProvider>.value(
          value: LocatorService.productsProvider(),
          child: ViewStateController<ProductsProvider>(
            fetchData:
                LocatorService.productsProvider().getFavoriteProductsFromDB,
            child: Selector<ProductsProvider, List<String>>(
              selector: (context, d) => d.favProducts,
              shouldRebuild: (a, b) => true,
              builder: (context, favProducts, _) {
                if (favProducts.isNotEmpty) {
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: ThemeGuide.padding10,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1 / 1.3,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: favProducts.length,
                    itemBuilder: (context, int i) {
                      return FavoriteItemCard(
                        productId: favProducts[i],
                      );
                    },
                  );
                } else {
                  return const _NoItemsContainer();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NoItemsContainer extends StatelessWidget {
  const _NoItemsContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'lib/assets/svg/broken-heart.svg',
          color: const Color(0xFFEF5350),
          height: 150,
        ),
        const SizedBox(height: 20),
        Text(lang.noFavoriteItems),
      ],
    );
  }
}
