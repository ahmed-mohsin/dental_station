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
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/authController.dart';
import '../../../developer/dev.log.dart';
import '../../../generated/l10n.dart';
import '../../../shared/authScreenWidgets/authSreenWidgets.dart';
import '../../../shared/widgets/textInput/phone_number_text_input.dart';
import '../../../themes/themeGuide.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String email, firstName, lastName, username, password, confirmPassword, phone;
  bool _isLoading = false;
  String errorText = '';
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  ///
  /// ## Description
  ///
  /// Triggers methods to handle:
  ///
  /// - Form validation
  /// - Firebase Authentication
  ///
  /// ### Functional Flow:
  ///
  /// 1. Show the loading indicator
  /// 2. Start authenticating service
  ///
  /// `Note`: Always wrap an authentication request in a try-catch block
  ///
  Future<void> buttonFun() async {
    if (_formKey.currentState.validate()) {
      // Start the indicator
      setState(() => _isLoading = !_isLoading);
      // Authenticate
      try {
        final result = await AuthController.signUp(
          email: email,
          password: password,
          username: username,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        );

        if (result == null) {
          errorText = S.of(context).failedSignUp;
        }

        if (result.id != null) {
          // Navigate to tab bar
          AuthController.navigateToTabbar();
          return;
        }

        // Change the error text
        errorText = '';
      } on FormatException catch (e, s) {
        errorText = S.of(context).somethingWentWrong;
        Dev.error('Login Error Format Exception', error: e, stackTrace: s);
      } on PlatformException catch (e, s) {
        if (e.toString().contains('Exception:')) {
          errorText = e.toString().split('Exception:')[1];
        } else {
          errorText = e.toString();
        }
        Dev.error('Platform Exception sign up', error: e, stackTrace: s);
      } catch (e, s) {
        Dev.error('Error sign up', error: e, stackTrace: s);
        if (e.toString().contains('Exception:')) {
          errorText = e.toString().split('Exception:')[1];
        } else {
          errorText = e.toString();
        }
      }

      // Stop the indicator
      setState(() => _isLoading = !_isLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final lang = S.of(context);
    return Container(
      padding: ThemeGuide.padding16,
      margin: ThemeGuide.padding20,
      decoration: BoxDecoration(
        color: _theme.backgroundColor,
        borderRadius: ThemeGuide.borderRadius16,
      ),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: <Widget>[
            FormBuilderTextField(
              name: lang.firstName,
              maxLines: 1,
              onChanged: (val) => firstName = val,
              decoration: InputDecoration(hintText: lang.firstName),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  context,
                  errorText: lang.errorEmptyInput,
                ),
                FormBuilderValidators.maxLength(context, 20),
              ]),
            ),
            const SizedBox(height: 10),
            FormBuilderTextField(
              name: lang.lastName,
              maxLines: 1,
              onChanged: (val) => lastName = val,
              decoration: InputDecoration(hintText: lang.lastName),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  context,
                  errorText: lang.errorEmptyInput,
                ),
                FormBuilderValidators.maxLength(context, 20),
              ]),
            ),
            const SizedBox(height: 10),
            FormBuilderTextField(
              name: lang.username,
              maxLines: 1,
              onChanged: (val) => username = val,
              decoration: InputDecoration(hintText: lang.username),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  context,
                  errorText: lang.errorEmptyInput,
                ),
                FormBuilderValidators.maxLength(context, 20),
              ]),
            ),
            const SizedBox(height: 10),
            PhoneNumberTextField(onChange: (val) => phone = val),
            const SizedBox(height: 10),
            FormBuilderTextField(
              name: lang.emailLabel,
              maxLines: 1,
              onChanged: (val) => email = val,
              decoration: InputDecoration(hintText: lang.emailLabel),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  context,
                  errorText: lang.errorEmptyInput,
                ),
                FormBuilderValidators.email(context),
              ]),
            ),
            const SizedBox(height: 10),
            FormBuilderTextField(
              name: lang.passwordLabel,
              obscureText: true,
              maxLines: 1,
              onChanged: (val) => password = val,
              decoration: InputDecoration(hintText: lang.passwordLabel),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  context,
                  errorText: lang.errorEmptyInput,
                ),
                FormBuilderValidators.minLength(context, 6),
                FormBuilderValidators.maxLength(context, 40),
                AuthController.validatePassword,
              ]),
            ),
            const SizedBox(height: 10),
            FormBuilderTextField(
              name: lang.confirmPasswordLabel,
              obscureText: true,
              maxLines: 1,
              onChanged: (val) => confirmPassword = val,
              decoration: InputDecoration(hintText: lang.confirmPasswordLabel),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  context,
                  errorText: lang.errorEmptyInput,
                ),
                FormBuilderValidators.minLength(context, 6),
                FormBuilderValidators.maxLength(context, 40),
                (_) {
                  return AuthController.validateConfirmPassword(
                    confirmPassword,
                    password,
                  );
                }
              ]),
            ),
            const SizedBox(height: 20),
            Submit(
              onPress: buttonFun,
              isLoading: _isLoading,
              label: lang.signup,
            ),
            ShowError(
              text: errorText,
            ),
            const FooterLinks(),
          ],
        ),
      ),
    );
  }
}

class FooterLinks extends StatelessWidget {
  const FooterLinks({Key key}) : super(key: key);

  // Launch the terms of service URL
  Future<void> _launchURL1() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  // Launch the privacy policy URL
  Future<void> _launchURL2() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final lang = S.of(context);
    return DefaultTextStyle(
      style: _theme.textTheme.caption.copyWith(
        color: _theme.disabledColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Wrap(
          runSpacing: 2,
          alignment: WrapAlignment.center,
          children: <Widget>[
            Text(lang.tosPreText),
            GestureDetector(
              onTap: () => _launchURL1(),
              child: Text(
                lang.termsOfService,
                style: TextStyle(color: _theme.colorScheme.secondary),
              ),
            ),
            Text(' ${lang.and} '),
            GestureDetector(
              onTap: () => _launchURL2(),
              child: Text(
                lang.privacyPolicy,
                style: TextStyle(
                  color: _theme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
