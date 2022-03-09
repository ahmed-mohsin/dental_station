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

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/models/coupon.dart';

import '../../../constants/config.dart';
import '../../../generated/l10n.dart';
import '../../../locator.dart';
import '../../../providers/utils/viewStateController.dart';
import '../../../shared/widgets/error/noDataAvailable.dart';
import '../../../themes/theme.dart';
import 'utils.dart';
import 'view_model/view_model.dart';
import 'widgets/apply_coupon_text_field.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).coupon),
      ),
      body: ChangeNotifierProvider<CouponsViewModel>(
        create: (context) => CouponsViewModel(),
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CouponTextFieldTile(),
            ),
            Expanded(child: _Body()),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateController<CouponsViewModel>(
      fetchData:
          Provider.of<CouponsViewModel>(context, listen: false).fetchCoupons,
      child: const _List(),
    );
  }
}

class _List extends StatelessWidget {
  const _List({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list =
        Provider.of<CouponsViewModel>(context, listen: false).wooCouponsList ??
            const [];
    if (list.isEmpty) {
      return const NoDataAvailableImage();
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        return _ListItem(coupon: list[i]);
      },
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    Key key,
    @required this.coupon,
  }) : super(key: key);

  final WooCoupon coupon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    return Container(
      margin: ThemeGuide.margin5,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: ThemeGuide.borderRadius20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _BuildDiscountContainer(coupon: coupon),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: ThemeGuide.padding10,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.disabledColor.withAlpha(20),
                          borderRadius: ThemeGuide.borderRadius10,
                        ),
                        child: SelectableText(
                          coupon.code?.toUpperCase() ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  coupon.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                _ItemRow(
                  title: '${lang.expiration} ${lang.date}',
                  titleTextStyle: const TextStyle(
                    color: Colors.red,
                  ),
                  value: CouponUtils.createDateTimeString(coupon.dateExpires),
                ),
                ExpandablePanel(
                  theme: const ExpandableThemeData(
                    hasIcon: true,
                    iconColor: Colors.grey,
                  ),
                  collapsed: const SizedBox(),
                  header: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      lang.moreInfo,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (Config.couponShowUsageLimit)
                        _ItemRow(
                          title: 'Usage Limit',
                          value: coupon.usageLimit?.toString(),
                        ),
                      if (Config.couponShowUsageCount)
                        const SizedBox(height: 5),
                      if (Config.couponShowUsageCount)
                        _ItemRow(
                          title: 'Usage Count',
                          value: coupon.usageCount?.toString(),
                        ),
                      if (Config.couponShowCouponType)
                        const SizedBox(height: 5),
                      if (Config.couponShowCouponType)
                        _ItemRow(
                          title: 'Coupon Type',
                          value: coupon.discountType,
                        ),
                      if (Config.couponShowMaximumSpend)
                        const SizedBox(height: 5),
                      if (Config.couponShowMaximumSpend)
                        _ItemRow(
                          title: 'Maximum spend',
                          value:
                              '${Config.currencySymbol} ${coupon.maximumAmount}',
                        ),
                      if (Config.couponShowMinimumSpend)
                        const SizedBox(height: 5),
                      if (Config.couponShowMinimumSpend)
                        _ItemRow(
                          title: 'Minimum spend',
                          value:
                              '${Config.currencySymbol} ${coupon.minimumAmount}',
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          if (CouponUtils.canBeUsed(coupon))
            _ApplyNowButton(coupon: coupon)
          else
            const _Expired(),
        ],
      ),
    );
  }
}

class _ApplyNowButton extends StatefulWidget {
  const _ApplyNowButton({
    Key key,
    @required this.coupon,
  }) : super(key: key);
  final WooCoupon coupon;

  @override
  State<_ApplyNowButton> createState() => _ApplyNowButtonState();
}

class _ApplyNowButtonState extends State<_ApplyNowButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SpinKitCircle(color: Theme.of(context).colorScheme.secondary),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: OutlinedButton(
        child: Text('${lang.apply} ${lang.now}'),
        onPressed: () async {
          // Verify the coupon
          setState(() {
            isLoading = true;
          });

          final result =
              await LocatorService.cartViewModel().verifyCouponFromCouponCard(
            widget.coupon,
            context,
          );

          setState(() {
            isLoading = false;
          });

          if (result) {
            // Pop the screen and verify th coupon
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        },
      ),
    );
  }
}

class _BuildDiscountContainer extends StatelessWidget {
  const _BuildDiscountContainer({Key key, this.coupon}) : super(key: key);
  final WooCoupon coupon;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: ThemeGuide.padding10,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: ThemeGuide.borderRadius10,
      ),
      child: FittedBox(child: _buildDiscount(coupon)),
    );
  }

  static Widget _buildDiscount(WooCoupon coupon) {
    if (coupon.couponType == WooCouponType.percentDiscount) {
      return Text(
        '${coupon.amount} %',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
      );
    } else {
      return Text(
        '${Config.currencySymbol} ${coupon.amount}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
      );
    }
  }
}

class _Expired extends StatelessWidget {
  const _Expired({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        S.of(context).expired,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    Key key,
    this.title,
    this.value,
    this.titleTextStyle,
  }) : super(key: key);

  final String title, value;
  final TextStyle titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Text(
          '$title:',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ).merge(titleTextStyle),
        )),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value ?? '',
            style: const TextStyle(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
