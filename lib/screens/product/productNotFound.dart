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

import '../../controllers/navigationController.dart';
import '../../generated/l10n.dart';
import '../../locator.dart';
import '../../shared/customLoader.dart';
import '../../shared/widgets/error/errorReload.dart';

class ProductNotFound extends StatelessWidget {
  const ProductNotFound({
    @required this.productId,
    Key key,
  }) : super(key: key);

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _Body(productId: productId),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.productId,
  }) : super(key: key);
  final String productId;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
    }

    if (widget.productId != null) {
      // fetch the product
      final result = await LocatorService.productsProvider()
          .fetchProductsById([int.parse(widget.productId)]);

      if (result.isNotEmpty) {
        NavigationController.navigator.popAndPush(
          ProductScreenRoute(id: widget.productId),
        );
      } else {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const CustomLoader();
    }

    return ErrorReload(
      errorMessage: S.of(context).somethingWentWrong,
      reloadFunction: init,
    );
  }
}
