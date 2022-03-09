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

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:quiver/strings.dart';

import '../../../../generated/l10n.dart';
import '../../../../shared/authScreenWidgets/authSreenWidgets.dart';
import '../../../../shared/widgets/textInput/phone_number_text_input.dart';
import '../../../../themes/theme.dart';
import '../../../../utils/utils.dart';

class OtpLoginScreen extends StatelessWidget {
  const OtpLoginScreen({
    Key key,
    @required this.onSuccess,
  }) : super(key: key);
  final void Function(String) onSuccess;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: ClipRRect(
        borderRadius: ThemeGuide.borderRadius20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: AppBar(title: Text('${lang.login} ${lang.phone}')),
            ),
            Flexible(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: _Form(submit: onSuccess),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({
    Key key,
    @required this.submit,
  }) : super(key: key);
  final Function submit;

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  final GlobalKey<FormBuilderState> formKey1 = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> formKey2 = GlobalKey<FormBuilderState>();
  String phone, error, otp = '';
  bool isLoading = false;
  final PageController controller = PageController();

  // Firebase fields
  String verificationId = '';
  int resendToken = 0;

  // Time to adjust resend otp function
  bool enabledResendCodeButton = false;
  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          _buildPage1(),
          _buildPage2(),
        ],
      ),
    );
  }

  Widget _buildPage1() {
    return FormBuilder(
      key: formKey1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PhoneNumberTextField(
            onChange: (val) => phone = val,
          ),
          ShowError(text: error),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Submit(
              isLoading: isLoading,
              onPress: _submit,
              label: S.of(context).submit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    final lang = S.of(context);
    return FormBuilder(
      key: formKey2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${lang.enter} ${lang.otp}'),
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: 'otp',
            onChanged: (val) => otp = val,
            textAlign: TextAlign.center,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
            ]),
          ),
          ShowError(text: error),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Submit(
              isLoading: isLoading,
              onPress: _verifyOtp,
              label: S.of(context).verify,
            ),
          ),
          TextButton(
            onPressed: enabledResendCodeButton ? _resendCode : null,
            child: Text(lang.resend),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (formKey1.currentState.validate()) {
      setState(() {
        isLoading = true;
        error = '';
      });
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {
          _performSignIn(credential);
        },
        verificationFailed: _handleVerificationFailedError,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            this.verificationId = verificationId;
          });
        },
      );
    }
  }

  Future<void> _verifyOtp() async {
    if (formKey2.currentState.validate()) {
      setState(() {
        isLoading = true;
        error = '';
      });
      await Future.delayed(const Duration(seconds: 2));
      // Create a PhoneAuthCredential with the code
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await _performSignIn(credential);
    }
  }

  void _handleVerificationFailedError(FirebaseAuthException e) {
    setState(() {
      isLoading = false;
      error = e.message;
    });
  }

  Future<void> _resendCode() async {
    setState(() {
      isLoading = false;
      error = '';
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) {
        _performSignIn(credential);
      },
      verificationFailed: _handleVerificationFailedError,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
    );
  }

  void _onCodeSent(String verificationId, int resendToken) {
    setState(() {
      isLoading = false;
      this.verificationId = verificationId;
      this.resendToken = resendToken;
      error = '';
      enabledResendCodeButton = false;
      timer = Timer(const Duration(seconds: 30), () {
        timer.cancel();
        setState(() {
          enabledResendCodeButton = true;
        });
      });
    });
    controller.animateToPage(
      1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  Future<void> _performSignIn(PhoneAuthCredential credential) async {
    try {
      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (isNotBlank(result.user.uid)) {
        widget.submit(phone);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error =
            e is FirebaseAuthException ? e.message : Utils.renderException(e);
      });
    }
  }
}
