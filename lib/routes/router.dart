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

import 'package:auto_route/auto_route.dart';

import '../navigation/tabbar.dart';
import '../screens/accountSettings/accountSettings.dart';
import '../screens/addAddress/addAddress.dart';
import '../screens/address/address.dart';
import '../screens/allProducts/allProducts.dart';
import '../screens/cards/addNewCard.dart';
import '../screens/cards/cards.dart';
import '../screens/cart/cart.dart';
import '../screens/categories/categorisedProducts.dart';
import '../screens/changePassword/changePassword.dart';
import '../screens/contact/contact.dart';
import '../screens/downloads/downloads.dart';
import '../screens/editProfile/editProfile.dart';
import '../screens/favorites/favorites.dart';
import '../screens/home/home.dart';
import '../screens/login/login.dart';
import '../screens/login/widgets/loginFromX.dart';
import '../screens/myOrders/myOrders.dart';
import '../screens/myOrders/trackOrder/trackOrder.dart';
import '../screens/notifications/notifications.dart';
import '../screens/onBoarding/onBoarding.dart';
import '../screens/points/points.dart';
import '../screens/product/product.dart';
import '../screens/profile/profile.dart';
import '../screens/search/search.dart';
import '../screens/settings/settings.dart';
import '../screens/signup/signup.dart';
import '../screens/splash/splash.dart';
import '../screens/tags/tag_products.dart';
import 'guards.dart';

@CupertinoAutoRouter(
  routes: <AutoRoute>[
    CupertinoRoute(page: SplashScreen, initial: true),
    CupertinoRoute(page: TabbarNavigation),
    CupertinoRoute(page: ProductScreen),
    CupertinoRoute(page: Signup),
    CupertinoRoute(page: Login),
    CupertinoRoute(page: OnBoarding),
    CupertinoRoute(page: MyOrders, guards: [AuthGuard]),
    CupertinoRoute(page: TrackOrder),
    CupertinoRoute(page: Home),
    CupertinoRoute(page: Favorites),
    CupertinoRoute(page: Cart),
    CupertinoRoute(page: Profile),
    CupertinoRoute(page: EditProfile, guards: [AuthGuard]),
    CupertinoRoute(page: CardsScreen),
    CupertinoRoute(page: ContactScreen),
    CupertinoRoute(page: ChangePassword, guards: [AuthGuard]),
    CupertinoRoute(page: AccountSettings),
    CupertinoRoute(page: AddressScreen, guards: [AuthGuard]),
    CupertinoRoute(page: AddAddress, guards: [AuthGuard]),
    CupertinoRoute(page: AddNewCardScreen),
    CupertinoRoute(page: CategorisedProducts),
    CupertinoRoute(page: SearchScreen),
    CupertinoRoute(page: AllProducts),
    CupertinoRoute(page: Settings),
    CupertinoRoute(page: PointsScreen, guards: [AuthGuard]),
    CupertinoRoute(page: LoginFromX),
    CupertinoRoute(page: DownloadsScreen, guards: [AuthGuard]),
    CupertinoRoute(page: NotificationScreen),
    CupertinoRoute(page: TagProducts),
  ],
)
class $AppRouter {}
