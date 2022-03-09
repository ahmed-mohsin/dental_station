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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../controllers/navigationController.dart';
import '../../controllers/uiController.dart';
import '../../generated/l10n.dart';
import '../../locator.dart';
import '../../models/models.dart';
import '../../services/woocommerce/woocommerce.service.dart';
import '../../shared/authScreenWidgets/authSreenWidgets.dart';
import '../../themes/theme.dart';
import '../../utils/utils.dart';
import '../product/viewModel/productViewModel.dart';

class AddReview extends StatelessWidget {
  const AddReview({
    Key key,
    @required this.notifier,
  }) : super(key: key);

  final PVMReviewNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return ChangeNotifierProvider<PVMReviewNotifier>.value(
      value: notifier,
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 120,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: ThemeGuide.borderRadius20,
          child: Material(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        lang.addReview,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const CloseButton(onPressed: _close),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Form(product: notifier.currentProduct),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void _close() {
    NavigationController.navigator.pop();
  }
}

class _Form extends StatefulWidget {
  const _Form({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final GlobalKey<FormBuilderState> fKey = GlobalKey<FormBuilderState>();

  bool isLoading = false;
  bool isError = false;
  String errorText = '';

  // Information of the user
  User user;

  // Rating
  double ratingCount = 5;

  @override
  void initState() {
    super.initState();
    user = LocatorService.userProvider().user;
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    bool showName = true;
    bool showEmail = true;

    if (user != null) {
      if (user.name != null) {
        showName = false;
      }
      if (user.email != null) {
        showEmail = false;
      }
    }

    return FormBuilder(
      key: fKey,
      child: Column(
        children: [
          if (showName)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: FormBuilderTextField(
                name: 'name',
                decoration: InputDecoration(hintText: lang.name),
                maxLines: 1,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.minLength(context, 3),
                  FormBuilderValidators.maxLength(context, 50),
                ]),
              ),
            ),
          if (showEmail)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: FormBuilderTextField(
                name: 'email',
                decoration: InputDecoration(hintText: lang.emailLabel),
                maxLines: 1,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.email(context),
                ]),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: FormBuilderTextField(
              name: 'review',
              decoration: InputDecoration(hintText: lang.writeAReview + ' ...'),
              maxLines: 10,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.minLength(context, 10),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RatingBar.builder(
              glow: false,
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) => ratingCount = rating,
            ),
          ),
          const SizedBox(height: 10),
          if (isError) ShowError(text: errorText),
          Submit(
            isLoading: isLoading,
            onPress: submit,
            label: lang.submit,
          ),
        ],
      ),
    );
  }

  Future<void> submit() async {
    final provider = Provider.of<PVMReviewNotifier>(context, listen: false);
    if (fKey.currentState.saveAndValidate()) {
      setState(() {
        isLoading = !isLoading;
      });
      try {
        final WooProductReview review = WooProductReview(
          id: Random().nextInt(1000000),
          productId: widget.product.id is int
              ? widget.product.id
              : int.parse(widget.product.id.toString()),
          rating: ratingCount.toInt(),
          review: fKey.currentState.value['review'],
          reviewer: user.name ?? fKey.currentState.value['name'],
          reviewerEmail: user.email ?? fKey.currentState.value['email'],
        );

        final result =
            await LocatorService.wooService().wc.createProductReviewWithApi(
                  productId: review.productId,
                  reviewer: review.reviewer,
                  reviewerEmail: review.reviewerEmail,
                  review: review.review,
                  rating: review.rating,
                );

        if (result is WooProductReview) {
          setState(() {
            isLoading = !isLoading;
            errorText = '';
            isError = false;
          });

          // Add review to list
          provider.addToReviews(result);

          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }

          final lang = S.of(context);

          UiController.showNotification(
            context: context,
            title: lang.success,
            message: '${lang.addReview} ${lang.success}',
            color: Colors.green,
          );
          return;
        }

        setState(() {
          isLoading = !isLoading;
          errorText = '';
          isError = false;
        });
      } catch (e) {
        setState(() {
          isLoading = !isLoading;
          errorText = Utils.renderException(e);
          isError = true;
        });
      }
    }
  }
}
