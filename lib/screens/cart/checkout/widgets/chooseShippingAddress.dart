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

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';

import '../../../../controllers/uiController.dart';
import '../../../../developer/dev.log.dart';
import '../../../../generated/l10n.dart';
import '../../../../locator.dart';
import '../../../../models/address.model.dart';
import '../../../../services/woocommerce/models/models.dart';
import '../../../../shared/widgets/textInput/label.dart';
import '../../../../themes/theme.dart';
import '../../../address/addressContainers.dart';
import '../viewModel/checkout_native_view_model.dart';
import 'bottomButtons.dart';
import 'headline.dart';

class ChooseShippingAddress extends StatelessWidget {
  const ChooseShippingAddress({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
          ),
          child: Headline(title: lang.shippingAddress),
        ),
        const Divider(
          endIndent: 20,
          indent: 20,
          height: 30,
          thickness: 2.5,
        ),
        const Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: _SameAsShippingAddress(),
        ),
        const Expanded(child: Body()),
      ],
    );
  }
}

class _SameAsShippingAddress extends StatelessWidget {
  const _SameAsShippingAddress({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return CheckboxListTile(
      shape: const RoundedRectangleBorder(
        borderRadius: ThemeGuide.borderRadius10,
      ),
      tileColor: Theme.of(context).backgroundColor,
      value: Provider.of<CheckoutNativeViewModel>(context)
          .sameShippingAndBillingAddress,
      onChanged: (val) {
        Provider.of<CheckoutNativeViewModel>(context, listen: false)
            .setSameShippingAndBillingAddress(val);
      },
      title: Text('${lang.same} ${lang.as} ${lang.billing} ${lang.address}'),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<CheckoutNativeViewModel, bool>(
      selector: (context, d) => d.sameShippingAndBillingAddress,
      builder: (context, isSame, onlyAddress) {
        if (isSame) {
          return onlyAddress;
        } else {
          Address address = const Address.empty();
          if (isNotBlank(LocatorService.userProvider().user.id) &&
              LocatorService.userProvider().user.wooCustomer != null &&
              LocatorService.userProvider().user.wooCustomer.shipping != null &&
              isNotBlank(LocatorService.userProvider()
                  .user
                  .wooCustomer
                  .shipping
                  .country) &&
              isNotBlank(LocatorService.userProvider()
                  .user
                  .wooCustomer
                  .shipping
                  .address1) &&
              isNotBlank(LocatorService.userProvider()
                  .user
                  .wooCustomer
                  .shipping
                  .postcode)) {
            address = Address.fromWooAddress(
              shipping: LocatorService.userProvider().user.wooCustomer.shipping,
            );
          }

          if (Address.isValid(
              Provider.of<CheckoutNativeViewModel>(context, listen: false)
                  .shippingAddress)) {
            address =
                Provider.of<CheckoutNativeViewModel>(context, listen: false)
                    .shippingAddress;
          }
          return _AddressForm(address: address);
        }
      },
      child: const _OnlyAddress(),
    );
  }
}

class _OnlyAddress extends StatelessWidget {
  const _OnlyAddress({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Address address = const Address.empty();
    final provider =
        Provider.of<CheckoutNativeViewModel>(context, listen: false);
    if (isNotBlank(LocatorService.userProvider().user.id) &&
        LocatorService.userProvider().user.wooCustomer != null &&
        LocatorService.userProvider().user.wooCustomer.billing != null &&
        isNotBlank(
            LocatorService.userProvider().user.wooCustomer.billing.country) &&
        isNotBlank(
            LocatorService.userProvider().user.wooCustomer.billing.address1) &&
        isNotBlank(
            LocatorService.userProvider().user.wooCustomer.billing.postcode)) {
      address = BillingAddress.fromWooAddress(
        billing: LocatorService.userProvider().user.wooCustomer.billing,
      );
    }

    if (BillingAddress.isValid(provider.billingAddress)) {
      address = provider.billingAddress;
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: AddressContainer(
            isBillingAddress: false,
            address: address,
          ),
        ),
        const Spacer(),
        BottomButtons(
          next: () {
            provider.setSameShippingAndBillingAddress(true);
            provider.next();
          },
          back: provider.back,
        ),
      ],
    );
  }
}

class _AddressForm extends StatefulWidget {
  const _AddressForm({
    Key key,
    @required this.address,
  }) : super(key: key);

  final Address address;

  @override
  __AddressFormState createState() => __AddressFormState();
}

class __AddressFormState extends State<_AddressForm> {
  GlobalKey<FormBuilderState> _fKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormState> _f2Key = GlobalKey<FormState>();

  Address newAddress;

  List<WooCountry> countries = [];
  List<WooState> selectedCountryStates = [];

  WooCountry selectedCountry = const WooCountry.empty();
  WooState selectedState = const WooState.empty();

  @override
  void initState() {
    super.initState();

    newAddress = widget.address;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadCountries();
    });
  }

  @override
  void dispose() {
    countries = null;
    newAddress = null;
    _fKey = null;
    _f2Key = null;

    countries = null;
    selectedCountryStates = null;
    super.dispose();
  }

  Future<void> _loadCountries() async {
    try {
      final result =
          await LocatorService.wooService().getCountriesFromLocalAsset();

      // Set the selected country
      final WooCountry _selectedCountry = result.firstWhere(
          (element) => element.code == widget.address.country,
          orElse: () => WooCountry.empty(code: widget.address.country));

      // Update the country field
      selectedCountry = _selectedCountry;

      if (isBlank(_selectedCountry.code)) {
        selectedCountry = result.first;
      }

      // Set the selected country states
      final List<WooState> _selectedCountryStates =
          _selectedCountry.states ?? const [];

      // Set the selected state
      final WooState _selectedState = _selectedCountryStates.isNotEmpty
          ? _selectedCountryStates.firstWhere(
              (element) => element.code == widget.address.state,
              orElse: () => WooState.empty(code: widget.address.state))
          : WooState.empty(code: widget.address.state);

      // Update the state field
      selectedState = _selectedState;

      setState(() {
        countries = result;
        selectedCountryStates = _selectedCountryStates;

        // Set the country and state.
        newAddress = newAddress.copyWith(
          country: selectedCountry.code,
          state: selectedState.code,
        );
      });
    } catch (e, s) {
      setState(() {
        countries = [];
        selectedCountryStates = [];
      });
      Dev.error('_loadCountries', error: e, stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _f2Key,
              child: FormBuilder(
                key: _fKey,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 50),
                  children: <Widget>[
                    TextInputLabel(label: lang.street),
                    FormBuilderTextField(
                      name: lang.street,
                      maxLines: 5,
                      minLines: 1,
                      initialValue: newAddress.address1,
                      onChanged: (val) =>
                          newAddress = newAddress.copyWith(address1: val),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.min(context, 3),
                        FormBuilderValidators.maxLength(context, 100),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    TextInputLabel(
                        label: '${lang.apartment}, ${lang.unit}, ${lang.etc}'),
                    FormBuilderTextField(
                      name: lang.apartment,
                      maxLines: 5,
                      minLines: 1,
                      initialValue: newAddress.address2,
                      onChanged: (val) =>
                          newAddress = newAddress.copyWith(address2: val),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.min(context, 2),
                        FormBuilderValidators.maxLength(context, 50),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    TextInputLabel(label: lang.city),
                    FormBuilderTextField(
                      name: lang.city,
                      maxLines: 1,
                      initialValue: newAddress.city,
                      onChanged: (val) =>
                          newAddress = newAddress.copyWith(city: val),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.min(context, 2),
                        FormBuilderValidators.maxLength(context, 50),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    TextInputLabel(label: lang.postCode),
                    FormBuilderTextField(
                      name: lang.postCode,
                      maxLines: 1,
                      initialValue: newAddress.postCode,
                      onChanged: (val) =>
                          newAddress = newAddress.copyWith(postCode: val),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.min(context, 5),
                        FormBuilderValidators.maxLength(context, 16),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    TextInputLabel(label: lang.country),
                    DropdownSearch<WooCountry>(
                      validator: (val) {
                        if (isBlank(val.code)) {
                          return lang.errorEmptyInput;
                        }
                        return null;
                      },
                      showAsSuffixIcons: true,
                      mode: Mode.DIALOG,
                      popupBarrierColor: Colors.black.withAlpha(100),
                      showSearchBox: true,
                      selectedItem: selectedCountry,
                      items: countries,
                      itemAsString: (obj) {
                        var result = obj.name;
                        if (obj.name != null && obj.name.isNotEmpty) {
                          result += ' ';
                          if (obj.code != null && obj.code.isNotEmpty) {
                            result += '( ${obj.code} )';
                          }
                        } else {
                          result = obj.code;
                        }
                        return result;
                      },
                      onChanged: (val) {
                        newAddress = newAddress.copyWith(country: val.code);

                        if (val.states.isNotEmpty) {
                          selectedState = val.states.first;
                        } else {
                          selectedState = const WooState.empty();
                        }
                        // set the states
                        setState(() {
                          selectedCountry = val;
                          selectedCountryStates = val.states;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextInputLabel(label: lang.state),
                    DropdownSearch<WooState>(
                      validator: (val) {
                        if (selectedCountryStates.isEmpty) {
                          return null;
                        }
                        if (isBlank(val.code)) {
                          return lang.errorEmptyInput;
                        }
                        return null;
                      },
                      showSearchBox: true,
                      selectedItem: selectedState,
                      enabled: selectedCountryStates.isNotEmpty,
                      popupBarrierColor: Colors.black.withAlpha(100),
                      dropDownButton: selectedCountryStates.isNotEmpty
                          ? const Icon(Icons.arrow_drop_down)
                          : const SizedBox(),
                      items: selectedCountryStates,
                      itemAsString: (obj) {
                        var result = obj.name;
                        if (obj.name != null && obj.name.isNotEmpty) {
                          result += ' ';
                          if (obj.code != null && obj.code.isNotEmpty) {
                            result += '( ${obj.code} )';
                          }
                        } else {
                          result = obj.code;
                        }
                        return result;
                      },
                      onChanged: (val) {
                        selectedState = val;
                        newAddress = newAddress.copyWith(state: val.code);
                      },
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
          ),
        ),
        BottomButtons(
          next: onSubmit,
          back:
              Provider.of<CheckoutNativeViewModel>(context, listen: false).back,
        ),
      ],
    );
  }

  Future<void> onSubmit() async {
    if (_fKey.currentState.saveAndValidate() &&
        _f2Key.currentState.validate()) {
      try {
        final provider =
            Provider.of<CheckoutNativeViewModel>(context, listen: false);

        // Set the new shipping address
        provider.setShippingAddress = newAddress;

        if (Address.isValid(provider.shippingAddress)) {
          provider.next();
          return;
        }
        final lang = S.of(context);
        UiController.showErrorNotification(
          context: context,
          title: '${lang.invalid} ${lang.shippingAddress}',
          message: lang.somethingWentWrong,
        );
      } catch (e, s) {
        Dev.error('Submit Shipping Address Checkout', error: e, stackTrace: s);
      }
    }
  }
}
