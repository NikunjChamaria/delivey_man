import 'package:delivery_man/pages/business/business_page.dart';
import 'package:delivery_man/pages/business/new_food_page.dart';
import 'package:delivery_man/pages/food/cart_page.dart';
import 'package:delivery_man/pages/food/category_page.dart';
import 'package:delivery_man/pages/food/chekout_page.dart';
import 'package:delivery_man/pages/food/food_main_page.dart';
import 'package:delivery_man/pages/food/restaurant_page.dart';
import 'package:delivery_man/pages/home/home_page.dart';
import 'package:delivery_man/pages/location/add_address.dart';
import 'package:delivery_man/pages/location/business_map.dart';
import 'package:delivery_man/pages/location/map.dart';
import 'package:delivery_man/pages/on%20board/home_page_.dart';
import 'package:delivery_man/pages/profile/business_porfile_sign_in.dart';
import 'package:delivery_man/pages/profile/business_profile_main_page.dart';
import 'package:delivery_man/pages/profile/edit_profile.dart';
import 'package:delivery_man/pages/retail_store/retail_store_main_page.dart';
import 'package:get/get.dart';

import '../pages/auth/auth.dart';

class RouteHelper {
  static const String onBoard = '/onboard';
  static const String auth = '/auth';
  static const String homw = '/home';
  static const String food = '/food';
  static const String retail = '/retail';
  static const String restaurant = '/restaurant';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String category = '/category';
  static const String editProfile = '/editProfile';
  static const String businessProfileSigIn = '/businessProfileSigIn';
  static const String businessProfileMainPage = '/businessProfileMainPage';
  static const String businessPage = '/businessPage';
  static const String newFoodPage = '/newFoodPage';
  static const String addLocation = '/addLocation';
  static const String map = '/map';
  static const String businessmap = '/businessmap';

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
          return HomePageZoom(
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
    GetPage(
        name: editProfile,
        page: () => const EditProfile(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: businessProfileSigIn,
        page: () {
          String address = Get.arguments['address'];
          double lat = Get.arguments['lat'];
          double long = Get.arguments['long'];
          return BusinessProfileCreate(
            address: address,
            lat: lat,
            long: long,
          );
        },
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: businessProfileMainPage,
        page: () => const BusinessProfileMainPage(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: businessPage,
        page: () {
          Map restaurant = Get.arguments['restaurant'];
          return BusinessPage(
            restaurant: restaurant,
          );
        },
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: newFoodPage,
        page: () {
          String resName = Get.arguments['resName'];
          return NewFoodPage(resName: resName);
        },
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: addLocation,
        page: () => const AddLocation(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: map,
        page: () {
          double lat = Get.arguments['lat'];
          double long = Get.arguments['long'];
          String address = Get.arguments['address'];
          int route = Get.arguments['route'];
          return MapScreen(
            route: route,
            initialLatitude: lat,
            initialLongitude: long,
            address: address,
          );
        },
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: businessmap,
        page: () {
          double lat = Get.arguments['lat'];
          double long = Get.arguments['long'];
          String address = Get.arguments['address'];
          return BusinessMapScreen(
            initialLatitude: lat,
            initialLongitude: long,
            address: address,
          );
        },
        transition: Transition.rightToLeftWithFade),
  ];
}
