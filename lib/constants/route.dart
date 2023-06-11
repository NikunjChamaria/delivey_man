import 'package:delivery_man/pages/food/cart_page.dart';
import 'package:delivery_man/pages/food/category_page.dart';
import 'package:delivery_man/pages/food/chekout_page.dart';
import 'package:delivery_man/pages/food/food_main_page.dart';
import 'package:delivery_man/pages/food/restaurant_page.dart';
import 'package:delivery_man/pages/home/home.dart';
import 'package:delivery_man/pages/on%20board/home_page_.dart';
import 'package:delivery_man/pages/profile/profile.dart';
import 'package:delivery_man/pages/retail_store/retail_store_main_page.dart';
import 'package:get/get.dart';

import '../pages/auth/auth.dart';

class RouteHelper {
  static const String onBoard = '/onboard';
  static const String auth = '/auth';
  static const String homw = '/home';
  static const String food = '/food';
  static const String retail = '/retail';
  static const String profile = '/profile';
  static const String restaurant = '/restaurant';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String category = '/category';

  static String getInitial() => onBoard;
  static String getAuth() => auth;
  static String getHome(String token) => homw;
  static String getFood() => food;
  static String getRetail() => retail;
  static String getProfile() => profile;
  static String getRestaurant() => restaurant;
  static String getCart() => cart;
  static String getCheckOut() => checkout;

  static List<GetPage> routes = [
    GetPage(
        name: onBoard,
        page: () => const HomePageWidget(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: auth,
        page: () => const AuthenticateSoloAltWidget(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: homw,
        page: () {
          var token = Get.arguments['token'];
          return HomeWidget(
            token: token,
          );
        },
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: food,
        page: () => const FoodMainPage(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: retail,
        page: () => const RetailStoreMainPage(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: profile,
        page: () {
          var token = Get.arguments['token'];
          return ProfilePage(
            token: token,
          );
        },
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: restaurant,
        page: () {
          Map? restaurant = Get.arguments['restaurant'];
          return RestaurantPage(restaurant: restaurant!);
        },
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: cart,
        page: () {
          Map restaurant = Get.arguments['restaurant'];
          Map<String, dynamic> itemCount = Get.arguments['itemCount'];
          List response = Get.arguments['response'];
          num totalAmount = Get.arguments['totalAmount'];
          return CartPage(
            restaurant: restaurant,
            itemCount: itemCount,
            response: response,
            totalAmount: totalAmount,
          );
        },
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: checkout,
        page: () => const CheckOutPage(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: category,
        page: () {
          String foodType = Get.arguments['foodType'];
          return CategoryPage(foodType: foodType);
        },
        transition: Transition.rightToLeftWithFade),
  ];
}
