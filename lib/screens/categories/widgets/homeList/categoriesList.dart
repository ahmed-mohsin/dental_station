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

import '../../../../constants/config.dart';
import 'layouts/utils.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CHSLayoutUtils.renderLayout(Config.categoriesHomeScreenLayout);
  }
}
