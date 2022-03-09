// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;
import 'package:flutter/material.dart';

import '../navigation/tabbar.dart' as _i5;
import '../screens/accountSettings/accountSettings.dart' as _i20;
import '../screens/addAddress/addAddress.dart' as _i22;
import '../screens/address/address.dart' as _i21;
import '../screens/allProducts/allProducts.dart' as _i26;
import '../screens/cards/addNewCard.dart' as _i23;
import '../screens/cards/cards.dart' as _i17;
import '../screens/cart/cart.dart' as _i14;
import '../screens/categories/categorisedProducts.dart' as _i24;
import '../screens/changePassword/changePassword.dart' as _i19;
import '../screens/contact/contact.dart' as _i18;
import '../screens/downloads/downloads.dart' as _i30;
import '../screens/editProfile/editProfile.dart' as _i16;
import '../screens/favorites/favorites.dart' as _i13;
import '../screens/home/home.dart' as _i12;
import '../screens/home/viewModel/homeSection.viewModel.dart' as _i35;
import '../screens/login/enums/loginFromXEnum.dart' as _i36;
import '../screens/login/login.dart' as _i8;
import '../screens/login/widgets/loginFromX.dart' as _i29;
import '../screens/myOrders/myOrders.dart' as _i10;
import '../screens/myOrders/order.model.dart' as _i33;
import '../screens/myOrders/trackOrder/trackOrder.dart' as _i11;
import '../screens/notifications/notifications.dart' as _i31;
import '../screens/onBoarding/onBoarding.dart' as _i9;
import '../screens/points/points.dart' as _i28;
import '../screens/product/product.dart' as _i6;
import '../screens/profile/profile.dart' as _i15;
import '../screens/search/search.dart' as _i25;
import '../screens/search/viewModel/searchViewModel.dart' as _i34;
import '../screens/settings/settings.dart' as _i27;
import '../screens/signup/signup.dart' as _i7;
import '../screens/splash/splash.dart' as _i4;
import '../screens/tags/tag_products.dart' as _i32;
import 'guards.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter(
      {_i2.GlobalKey<_i2.NavigatorState> navigatorKey,
      @required this.authGuard})
      : super(navigatorKey);

  final _i3.AuthGuard authGuard;

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i4.SplashScreen());
    },
    TabbarNavigationRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i5.TabbarNavigation());
    },
    ProductScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ProductScreenRouteArgs>(
          orElse: () => const ProductScreenRouteArgs());
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i6.ProductScreen(key: args.key, id: args.id));
    },
    SignupRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i7.Signup());
    },
    LoginRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i8.Login());
    },
    OnBoardingRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i9.OnBoarding());
    },
    MyOrdersRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i10.MyOrders());
    },
    TrackOrderRoute.name: (routeData) {
      final args = routeData.argsAs<TrackOrderRouteArgs>(
          orElse: () => const TrackOrderRouteArgs());
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i11.TrackOrder(key: args.key, order: args.order));
    },
    HomeRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i12.Home());
    },
    FavoritesRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i13.Favorites());
    },
    CartRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i14.Cart());
    },
    ProfileRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i15.Profile());
    },
    EditProfileRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i16.EditProfile());
    },
    CardsScreenRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i17.CardsScreen());
    },
    ContactScreenRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i18.ContactScreen());
    },
    ChangePasswordRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i19.ChangePassword());
    },
    AccountSettingsRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i20.AccountSettings());
    },
    AddressScreenRoute.name: (routeData) {
      final args = routeData.argsAs<AddressScreenRouteArgs>(
          orElse: () => const AddressScreenRouteArgs());
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData,
          child:
              _i21.AddressScreen(key: args.key, isShipping: args.isShipping));
    },
    AddAddressRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i22.AddAddress());
    },
    AddNewCardScreenRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i23.AddNewCardScreen());
    },
    CategorisedProductsRoute.name: (routeData) {
      final args = routeData.argsAs<CategorisedProductsRouteArgs>(
          orElse: () => const CategorisedProductsRouteArgs());
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i24.CategorisedProducts(
              key: args.key,
              category: args.category,
              searchCategory: args.searchCategory,
              childrenCategoryList: args.childrenCategoryList));
    },
    SearchScreenRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i25.SearchScreen());
    },
    AllProductsRoute.name: (routeData) {
      final args = routeData.argsAs<AllProductsRouteArgs>(
          orElse: () => const AllProductsRouteArgs());
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i26.AllProducts(
              key: args.key,
              homeSectionDataHolder: args.homeSectionDataHolder));
    },
    SettingsRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i27.Settings());
    },
    PointsScreenRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i28.PointsScreen());
    },
    LoginFromXRoute.name: (routeData) {
      final args = routeData.argsAs<LoginFromXRouteArgs>(
          orElse: () => const LoginFromXRouteArgs());
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i29.LoginFromX(key: args.key, loginFrom: args.loginFrom));
    },
    DownloadsScreenRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i30.DownloadsScreen());
    },
    NotificationScreenRoute.name: (routeData) {
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i31.NotificationScreen());
    },
    TagProductsRoute.name: (routeData) {
      final args = routeData.argsAs<TagProductsRouteArgs>(
          orElse: () => const TagProductsRouteArgs());
      return _i1.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i32.TagProducts(key: args.key, tag: args.tag));
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashScreenRoute.name, path: '/'),
        _i1.RouteConfig(TabbarNavigationRoute.name, path: '/tabbar-navigation'),
        _i1.RouteConfig(ProductScreenRoute.name, path: '/product-screen'),
        _i1.RouteConfig(SignupRoute.name, path: '/Signup'),
        _i1.RouteConfig(LoginRoute.name, path: '/Login'),
        _i1.RouteConfig(OnBoardingRoute.name, path: '/on-boarding'),
        _i1.RouteConfig(MyOrdersRoute.name,
            path: '/my-orders', guards: [authGuard]),
        _i1.RouteConfig(TrackOrderRoute.name, path: '/track-order'),
        _i1.RouteConfig(HomeRoute.name, path: '/Home'),
        _i1.RouteConfig(FavoritesRoute.name, path: '/Favorites'),
        _i1.RouteConfig(CartRoute.name, path: '/Cart'),
        _i1.RouteConfig(ProfileRoute.name, path: '/Profile'),
        _i1.RouteConfig(EditProfileRoute.name,
            path: '/edit-profile', guards: [authGuard]),
        _i1.RouteConfig(CardsScreenRoute.name, path: '/cards-screen'),
        _i1.RouteConfig(ContactScreenRoute.name, path: '/contact-screen'),
        _i1.RouteConfig(ChangePasswordRoute.name,
            path: '/change-password', guards: [authGuard]),
        _i1.RouteConfig(AccountSettingsRoute.name, path: '/account-settings'),
        _i1.RouteConfig(AddressScreenRoute.name,
            path: '/address-screen', guards: [authGuard]),
        _i1.RouteConfig(AddAddressRoute.name,
            path: '/add-address', guards: [authGuard]),
        _i1.RouteConfig(AddNewCardScreenRoute.name,
            path: '/add-new-card-screen'),
        _i1.RouteConfig(CategorisedProductsRoute.name,
            path: '/categorised-products'),
        _i1.RouteConfig(SearchScreenRoute.name, path: '/search-screen'),
        _i1.RouteConfig(AllProductsRoute.name, path: '/all-products'),
        _i1.RouteConfig(SettingsRoute.name, path: '/Settings'),
        _i1.RouteConfig(PointsScreenRoute.name,
            path: '/points-screen', guards: [authGuard]),
        _i1.RouteConfig(LoginFromXRoute.name, path: '/login-from-x'),
        _i1.RouteConfig(DownloadsScreenRoute.name,
            path: '/downloads-screen', guards: [authGuard]),
        _i1.RouteConfig(NotificationScreenRoute.name,
            path: '/notification-screen'),
        _i1.RouteConfig(TagProductsRoute.name, path: '/tag-products')
      ];
}

class SplashScreenRoute extends _i1.PageRouteInfo<void> {
  const SplashScreenRoute() : super(name, path: '/');

  static const String name = 'SplashScreenRoute';
}

class TabbarNavigationRoute extends _i1.PageRouteInfo<void> {
  const TabbarNavigationRoute() : super(name, path: '/tabbar-navigation');

  static const String name = 'TabbarNavigationRoute';
}

class ProductScreenRoute extends _i1.PageRouteInfo<ProductScreenRouteArgs> {
  ProductScreenRoute({_i2.Key key, String id})
      : super(name,
            path: '/product-screen',
            args: ProductScreenRouteArgs(key: key, id: id));

  static const String name = 'ProductScreenRoute';
}

class ProductScreenRouteArgs {
  const ProductScreenRouteArgs({this.key, this.id});

  final _i2.Key key;

  final String id;
}

class SignupRoute extends _i1.PageRouteInfo<void> {
  const SignupRoute() : super(name, path: '/Signup');

  static const String name = 'SignupRoute';
}

class LoginRoute extends _i1.PageRouteInfo<void> {
  const LoginRoute() : super(name, path: '/Login');

  static const String name = 'LoginRoute';
}

class OnBoardingRoute extends _i1.PageRouteInfo<void> {
  const OnBoardingRoute() : super(name, path: '/on-boarding');

  static const String name = 'OnBoardingRoute';
}

class MyOrdersRoute extends _i1.PageRouteInfo<void> {
  const MyOrdersRoute() : super(name, path: '/my-orders');

  static const String name = 'MyOrdersRoute';
}

class TrackOrderRoute extends _i1.PageRouteInfo<TrackOrderRouteArgs> {
  TrackOrderRoute({_i2.Key key, _i33.Order order})
      : super(name,
            path: '/track-order',
            args: TrackOrderRouteArgs(key: key, order: order));

  static const String name = 'TrackOrderRoute';
}

class TrackOrderRouteArgs {
  const TrackOrderRouteArgs({this.key, this.order});

  final _i2.Key key;

  final _i33.Order order;
}

class HomeRoute extends _i1.PageRouteInfo<void> {
  const HomeRoute() : super(name, path: '/Home');

  static const String name = 'HomeRoute';
}

class FavoritesRoute extends _i1.PageRouteInfo<void> {
  const FavoritesRoute() : super(name, path: '/Favorites');

  static const String name = 'FavoritesRoute';
}

class CartRoute extends _i1.PageRouteInfo<void> {
  const CartRoute() : super(name, path: '/Cart');

  static const String name = 'CartRoute';
}

class ProfileRoute extends _i1.PageRouteInfo<void> {
  const ProfileRoute() : super(name, path: '/Profile');

  static const String name = 'ProfileRoute';
}

class EditProfileRoute extends _i1.PageRouteInfo<void> {
  const EditProfileRoute() : super(name, path: '/edit-profile');

  static const String name = 'EditProfileRoute';
}

class CardsScreenRoute extends _i1.PageRouteInfo<void> {
  const CardsScreenRoute() : super(name, path: '/cards-screen');

  static const String name = 'CardsScreenRoute';
}

class ContactScreenRoute extends _i1.PageRouteInfo<void> {
  const ContactScreenRoute() : super(name, path: '/contact-screen');

  static const String name = 'ContactScreenRoute';
}

class ChangePasswordRoute extends _i1.PageRouteInfo<void> {
  const ChangePasswordRoute() : super(name, path: '/change-password');

  static const String name = 'ChangePasswordRoute';
}

class AccountSettingsRoute extends _i1.PageRouteInfo<void> {
  const AccountSettingsRoute() : super(name, path: '/account-settings');

  static const String name = 'AccountSettingsRoute';
}

class AddressScreenRoute extends _i1.PageRouteInfo<AddressScreenRouteArgs> {
  AddressScreenRoute({_i2.Key key, bool isShipping})
      : super(name,
            path: '/address-screen',
            args: AddressScreenRouteArgs(key: key, isShipping: isShipping));

  static const String name = 'AddressScreenRoute';
}

class AddressScreenRouteArgs {
  const AddressScreenRouteArgs({this.key, this.isShipping});

  final _i2.Key key;

  final bool isShipping;
}

class AddAddressRoute extends _i1.PageRouteInfo<void> {
  const AddAddressRoute() : super(name, path: '/add-address');

  static const String name = 'AddAddressRoute';
}

class AddNewCardScreenRoute extends _i1.PageRouteInfo<void> {
  const AddNewCardScreenRoute() : super(name, path: '/add-new-card-screen');

  static const String name = 'AddNewCardScreenRoute';
}

class CategorisedProductsRoute
    extends _i1.PageRouteInfo<CategorisedProductsRouteArgs> {
  CategorisedProductsRoute(
      {_i2.Key key,
      _i34.WooProductCategory category,
      _i34.WooProductCategory searchCategory,
      List<_i34.WooProductCategory> childrenCategoryList = const []})
      : super(name,
            path: '/categorised-products',
            args: CategorisedProductsRouteArgs(
                key: key,
                category: category,
                searchCategory: searchCategory,
                childrenCategoryList: childrenCategoryList));

  static const String name = 'CategorisedProductsRoute';
}

class CategorisedProductsRouteArgs {
  const CategorisedProductsRouteArgs(
      {this.key,
      this.category,
      this.searchCategory,
      this.childrenCategoryList = const []});

  final _i2.Key key;

  final _i34.WooProductCategory category;

  final _i34.WooProductCategory searchCategory;

  final List<_i34.WooProductCategory> childrenCategoryList;
}

class SearchScreenRoute extends _i1.PageRouteInfo<void> {
  const SearchScreenRoute() : super(name, path: '/search-screen');

  static const String name = 'SearchScreenRoute';
}

class AllProductsRoute extends _i1.PageRouteInfo<AllProductsRouteArgs> {
  AllProductsRoute(
      {_i2.Key key, _i35.HomeSectionDataHolder homeSectionDataHolder})
      : super(name,
            path: '/all-products',
            args: AllProductsRouteArgs(
                key: key, homeSectionDataHolder: homeSectionDataHolder));

  static const String name = 'AllProductsRoute';
}

class AllProductsRouteArgs {
  const AllProductsRouteArgs({this.key, this.homeSectionDataHolder});

  final _i2.Key key;

  final _i35.HomeSectionDataHolder homeSectionDataHolder;
}

class SettingsRoute extends _i1.PageRouteInfo<void> {
  const SettingsRoute() : super(name, path: '/Settings');

  static const String name = 'SettingsRoute';
}

class PointsScreenRoute extends _i1.PageRouteInfo<void> {
  const PointsScreenRoute() : super(name, path: '/points-screen');

  static const String name = 'PointsScreenRoute';
}

class LoginFromXRoute extends _i1.PageRouteInfo<LoginFromXRouteArgs> {
  LoginFromXRoute(
      {_i2.Key key, _i36.LoginFrom loginFrom = _i36.LoginFrom.undefined})
      : super(name,
            path: '/login-from-x',
            args: LoginFromXRouteArgs(key: key, loginFrom: loginFrom));

  static const String name = 'LoginFromXRoute';
}

class LoginFromXRouteArgs {
  const LoginFromXRouteArgs(
      {this.key, this.loginFrom = _i36.LoginFrom.undefined});

  final _i2.Key key;

  final _i36.LoginFrom loginFrom;
}

class DownloadsScreenRoute extends _i1.PageRouteInfo<void> {
  const DownloadsScreenRoute() : super(name, path: '/downloads-screen');

  static const String name = 'DownloadsScreenRoute';
}

class NotificationScreenRoute extends _i1.PageRouteInfo<void> {
  const NotificationScreenRoute() : super(name, path: '/notification-screen');

  static const String name = 'NotificationScreenRoute';
}

class TagProductsRoute extends _i1.PageRouteInfo<TagProductsRouteArgs> {
  TagProductsRoute({_i2.Key key, _i34.WooProductTag tag})
      : super(name,
            path: '/tag-products',
            args: TagProductsRouteArgs(key: key, tag: tag));

  static const String name = 'TagProductsRoute';
}

class TagProductsRouteArgs {
  const TagProductsRouteArgs({this.key, this.tag});

  final _i2.Key key;

  final _i34.WooProductTag tag;
}
