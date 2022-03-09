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

import '../../themes/theme.dart';
import '../animatedButton.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    Key key,
    @required this.gradient,
    @required this.child,
    this.onPress,
  }) : super(key: key);

  final Gradient gradient;
  final Widget child;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return AnimButton(
      onTap: onPress ?? () {},
      child: Container(
        padding: ThemeGuide.padding16,
        decoration: BoxDecoration(
          borderRadius: ThemeGuide.borderRadius,
          color: Colors.transparent.withAlpha(220),
          gradient: gradient,
        ),
        child: child,
      ),
    );
  }
}
