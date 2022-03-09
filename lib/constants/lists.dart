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

import '../enums/enums.dart';

/// Contains a map with key
/// * `label`
/// * `assetUrl` - SVG asset
/// * `type` - Product category type
const List<Map<String, dynamic>> PRODUCT_CATEGORY_LIST = [
  {
    'label': 'Clothing',
    'assetUrl': 'lib/assets/svg/clothes.svg',
    'type': ProductCategoryType.Clothing,
  },
  {
    'label': 'Jeans',
    'assetUrl': 'lib/assets/svg/jeans.svg',
    'type': ProductCategoryType.Jeans,
  },
  {
    'label': 'Shirts',
    'assetUrl': 'lib/assets/svg/shirts.svg',
    'type': ProductCategoryType.Shirts,
  },
  {
    'label': 'T-Shirts',
    'assetUrl': 'lib/assets/svg/tshirt.svg',
    'type': ProductCategoryType.T_Shirts,
  },
  {
    'label': 'Shoes',
    'assetUrl': 'lib/assets/svg/shoe.svg',
    'type': ProductCategoryType.Shoes,
  },
  {
    'label': 'Bags',
    'assetUrl': 'lib/assets/svg/handbag.svg',
    'type': ProductCategoryType.Bags,
  },
  {
    'label': 'Watch',
    'assetUrl': 'lib/assets/svg/watch.svg',
    'type': ProductCategoryType.Watch,
  },
  {
    'label': 'Accessories',
    'assetUrl': 'lib/assets/svg/sunglasses.svg',
    'type': ProductCategoryType.Accessories,
  },
];

const List<int> PRODUCT_SIZE_LIST = [32, 34, 36, 38, 40, 42, 44, 46, 48];
