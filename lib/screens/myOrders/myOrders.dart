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
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../locator.dart';
import '../../providers/utils/viewStateController.dart';
import '../../shared/widgets/user/noUserFound.dart';
import '../../themes/themeGuide.dart';
import 'order.model.dart';
import 'viewModel/viewModel.dart';
import 'widgets/tabPageBuilder.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final lang = S.of(context);
    final bool isDarkMode =
        LocatorService.themeProvider().themeMode == ThemeMode.dark || false;
    return DefaultTabController(
      length: 6,
      child: Theme(
        data: _theme.copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ChangeNotifierProvider<MyOrdersViewModel>.value(
          value: LocatorService.myOrdersViewModel(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(lang.orders),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: LocatorService.myOrdersViewModel().fetchData,
                ),
              ],
              bottom: TabBar(
                indicator: BoxDecoration(
                  borderRadius: ThemeGuide.borderRadius,
                  color: _theme.colorScheme.secondary.withAlpha(50),
                ),
                labelColor: isDarkMode ? Colors.white : Colors.black,
                unselectedLabelColor:
                    isDarkMode ? Colors.white30 : Colors.black26,
                isScrollable: true,
                tabs: <Widget>[
                  Tab(child: Center(child: Text(lang.all))),
                  Tab(child: Center(child: Text(lang.completed))),
                  Tab(child: Center(child: Text(lang.pending))),
                  Tab(child: Center(child: Text(lang.processing))),
                  Tab(child: Center(child: Text(lang.cancelled))),
                  Tab(child: Center(child: Text(lang.failed))),
                ],
              ),
            ),
            body: const _Body(),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyOrdersViewModel>(context, listen: false);
    return ViewStateController<MyOrdersViewModel>(
      customMessageWidget: const NoUserFoundWithImage(),
      fetchData: provider.fetchData,
      child: const TabBarView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          TabPage(orderStatus: OrderStatus.all),
          TabPage(orderStatus: OrderStatus.completed),
          TabPage(orderStatus: OrderStatus.pending),
          TabPage(orderStatus: OrderStatus.processing),
          TabPage(orderStatus: OrderStatus.cancelled),
          TabPage(orderStatus: OrderStatus.failed),
        ],
      ),
    );
  }
}
