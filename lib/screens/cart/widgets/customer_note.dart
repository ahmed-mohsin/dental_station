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
import 'package:quiver/strings.dart';

import '../../../controllers/uiController.dart';
import '../../../generated/l10n.dart';
import '../../../locator.dart';

class CartCustomerNote extends StatelessWidget {
  const CartCustomerNote({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return TextField(
      decoration: InputDecoration(hintText: '${lang.customer} ${lang.note}'),
      minLines: 1,
      maxLines: 10,
      onChanged: (val) {
        LocatorService.cartViewModel().customerNote = val;
      },
      textInputAction: TextInputAction.done,
      onEditingComplete: () {
        if (isNotBlank(LocatorService.cartViewModel().customerNote)) {
          UiController.showNotification(
            context: context,
            title: lang.completed,
            message: '${lang.customer} ${lang.note} ${lang.completed}',
          );
        }
      },
    );
  }
}
