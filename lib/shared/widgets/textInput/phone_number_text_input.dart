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
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:quiver/strings.dart';

import '../../../constants/countries.dart';
import '../../../generated/l10n.dart';

class PhoneNumberTextField extends StatefulWidget {
  const PhoneNumberTextField({
    Key key,
    this.onChange,
    this.validator,
    this.initialValue,
  }) : super(key: key);

  final String initialValue;
  final ValueChanged<String> onChange;
  final String Function(String) validator;

  @override
  State<PhoneNumberTextField> createState() => PhoneNumberTextFieldState();
}

class PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  String flag = '';
  String dialCode = '';
  String number, initialValue = '';

  @override
  void initState() {
    super.initState();

    final Map<String, dynamic> countryObject = kCountries.firstWhere(
      (element) => element['countryCode'] == kDefaultCountryCode,
      orElse: () => const {},
    );
    flag = countryObject['flag'];
    dialCode = countryObject['dialCode'];

    if (isNotBlank(widget.initialValue) && widget.initialValue.contains('-')) {
      final tempNumber = widget.initialValue.split(r'-');
      if (tempNumber.length <= 1) {
        initialValue = tempNumber[0];
      } else {
        if (tempNumber[0] != null) {
          dialCode = tempNumber[0];
          final tempFlag = kCountries.firstWhere(
            (element) => element['dialCode'] == tempNumber[0],
            orElse: () => const {},
          )['flag'];
          if (isNotBlank(tempFlag)) {
            flag = tempFlag;
          }
        }
        if (tempNumber[1] != null) {
          initialValue = tempNumber[1];
          number = tempNumber[1];
        }
      }
    } else {
      initialValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return FormBuilderTextField(
      initialValue: initialValue,
      name: lang.phone,
      maxLines: 1,
      onChanged: (val) {
        number = val;
        widget.onChange(_createCompleteNumber());
      },
      decoration: InputDecoration(
        hintText: lang.phone,
        prefixIcon: _buildDialCodeSelector(),
      ),
      validator: widget.validator ??
          FormBuilderValidators.compose([
            FormBuilderValidators.required(
              context,
              errorText: lang.errorEmptyInput,
            ),
            FormBuilderValidators.numeric(context),
          ]),
    );
  }

  Widget _buildDialCodeSelector() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: ListView.builder(
                itemCount: kCountries.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                      setState(() {
                        flag = kCountries[i]['flag'];
                        dialCode = kCountries[i]['dialCode'];
                      });

                      widget.onChange(_createCompleteNumber());
                    },
                    leading: Text(
                      kCountries[i]['flag'] ?? '',
                      style: const TextStyle(fontSize: 26),
                    ),
                    title: Text(kCountries[i]['name'] ?? ''),
                    trailing: Text(kCountries[i]['dialCode'] ?? ''),
                  );
                },
              ),
            );
          },
        );
      },
      child: FractionallySizedBox(
        widthFactor: 0.25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                flag ?? '',
                style: const TextStyle(fontSize: 26),
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                dialCode ?? '',
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _createCompleteNumber() {
    if (isBlank(number)) {
      return '';
    }

    return dialCode + '-' + number;
  }
}
