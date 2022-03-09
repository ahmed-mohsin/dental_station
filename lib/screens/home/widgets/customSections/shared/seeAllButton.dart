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

import '../../../../../generated/l10n.dart';
import '../../../../../shared/animatedButton.dart';
import '../../../../../themes/theme.dart';

class SeeAllButton extends StatelessWidget {
  const SeeAllButton({Key key, this.onPress}) : super(key: key);

  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return AnimButton(
      onTap: onPress,
      child: Container(
        padding: ThemeGuide.padding10,
        decoration: const BoxDecoration(
          borderRadius: ThemeGuide.borderRadius,
        ),
        child: Center(
          child: Text(lang.seeAll),
        ),
      ),
    );
  }
}
