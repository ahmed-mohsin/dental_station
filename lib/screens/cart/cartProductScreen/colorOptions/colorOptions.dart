// // Copyright (c) 2020 Aniket Malik [aniketmalikwork@gmail.com]
// // All Rights Reserved.
// //
// // NOTICE: All information contained herein is, and remains the
// // property of Aniket Malik. The intellectual and technical concepts
// // contained herein are proprietary to Aniket Malik and are protected
// // by trade secret or copyright law.
// //
// // Dissemination of this information or reproduction of this material
// // is strictly forbidden unless prior written permission is obtained from
// // Aniket Malik.
//
// TODO(AniketMalik): Delete this file if not in use
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../locator.dart';
// import '../../../../themes/theme.dart';
// import '../../viewModel/viewModel.dart';
//
// class ColorOptionsCart extends StatefulWidget {
//   const ColorOptionsCart({
//     Key key,
//     this.colorList,
//   }) : super(key: key);
//
//   final List<Color> colorList;
//
//   @override
//   _ColorOptionsCartState createState() => _ColorOptionsCartState();
// }
//
// class _ColorOptionsCartState extends State<ColorOptionsCart> {
//   // Default list if no list of colors is sent
//   final List<Color> defaultList = [
//     Colors.red.shade400,
//     Colors.green.shade400,
//     Colors.blue.shade400,
//     Colors.yellow.shade700,
//   ];
//
//   List<Color> newColorList;
//
//   void setColorList() {
//     if (widget.colorList != null) {
//       newColorList = widget.colorList;
//     } else {
//       newColorList = defaultList;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     setColorList();
//     final CartViewModel provider = LocatorService.cartViewModel();
//     final String productId = provider.currentProduct.id;
//     return Wrap(
//       children: List<Widget>.generate(
//         newColorList.length,
//         (int index) {
//           return GestureDetector(
//             onTap: () {
//               // provider.setProductColor(productId, newColorList[index]);
//             },
//             child: Selector<CartViewModel, Color>(
//               selector: (context, d) => d.productsMap[productId].color,
//               builder: (context, selectedColor, _) {
//                 return Container(
//                   height: 50,
//                   width: 50,
//                   margin: const EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                     color: newColorList[index],
//                     borderRadius: ThemeGuide.borderRadius,
//                   ),
//                   child: selectedColor == newColorList[index]
//                       ? const Icon(Icons.check, color: Colors.white)
//                       : const SizedBox(),
//                 );
//               },
//             ),
//           );
//         },
//       ).toList(),
//     );
//   }
// }
