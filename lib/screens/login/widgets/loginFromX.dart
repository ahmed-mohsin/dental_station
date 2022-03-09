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
import 'package:provider/provider.dart';

import '../../../controllers/authController.dart';
import '../../../generated/l10n.dart';
import '../../../shared/authScreenWidgets/authSreenWidgets.dart';
import '../../../shared/dividerWithText.dart';
import '../../../themes/theme.dart';
import '../enums/loginFromXEnum.dart';
import '../form/loginForm.dart';
import '../socialLogin.dart';
import '../viewModal/loginFromViewModal.dart';

/// ## Description
///
/// Tracks the login from different places in the application where
/// the user can enter only if they are logged in.
class LoginFromX extends StatelessWidget {
  final LoginFrom loginFrom;

  const LoginFromX({
    Key key,
    this.loginFrom = LoginFrom.undefined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return ChangeNotifierProvider<LoginFromXViewModal>(
      create: (context) => LoginFromXViewModal(loginFrom),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: const [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CloseButton(),
            )
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderImage(),
              const SizedBox(height: 20),
              HeaderText(
                title: lang.login,
                body: lang.loginTagLine,
              ),
              const _LoginForm(),
              const SizedBox(height: 20),
              DividerWithText(text: lang.or),
              const SizedBox(height: 20),
              const _SocialLogin(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLogin extends StatelessWidget {
  const _SocialLogin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<LoginFromXViewModal>(context, listen: false);
    return SocialLoginRow(onSuccess: p.onLoginSuccess);
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final lang = S.of(context);
    final provider = Provider.of<LoginFromXViewModal>(context, listen: false);
    return Container(
      padding: ThemeGuide.padding20,
      margin: ThemeGuide.padding16,
      decoration: BoxDecoration(
        color: _theme.backgroundColor,
        borderRadius: ThemeGuide.borderRadius16,
      ),
      child: FormBuilder(
        key: provider.formKey,
        child: Column(
          children: <Widget>[
            FormBuilderTextField(
              name: lang.emailLabel,
              onChanged: (val) => provider.email = val,
              maxLines: 1,
              decoration: InputDecoration(hintText: lang.emailLabel),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.maxLength(context, 50),
                FormBuilderValidators.email(context),
              ]),
            ),
            const SizedBox(height: 10),
            FormBuilderTextField(
              name: lang.passwordLabel,
              obscureText: true,
              maxLines: 1,
              onChanged: (val) => provider.password = val,
              decoration: InputDecoration(hintText: lang.passwordLabel),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.maxLength(context, 40),
                AuthController.validatePassword,
              ]),
            ),
            const SizedBox(height: 20),
            Consumer<LoginFromXViewModal>(
              builder: (context, p, _) {
                return Submit(
                  onPress: provider.submit,
                  isLoading: p.isLoading,
                  label: lang.login,
                );
              },
            ),
            Consumer<LoginFromXViewModal>(
              builder: (context, p, _) {
                return ShowError(text: p.errorMessage);
              },
            ),
            const ForgotPassword(),
          ],
        ),
      ),
    );
  }
}
