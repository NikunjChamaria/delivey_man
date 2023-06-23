import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/pages/home/home_page.dart';
import 'package:delivery_man/pages/on%20board/home_page_.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token = preferences.getString('token') == null
      ? ""
      : preferences.getString('token')!;
  bool check = token == "" ? false : true;
  runApp(MyApp(
    isToken: check,
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  final bool isToken;
  // ignore: prefer_typing_uninitialized_variables
  final token;
  const MyApp({super.key, required this.isToken, required this.token});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Mr. Delivery Man",
      theme: lightTheme,
      darkTheme: darktheme,
      debugShowCheckedModeBanner: false,
      home: (isToken) == true
          ? HomePageZoom(token: token)
          : const HomePageWidget(),
      //initialRoute: RouteHelper.auth,
      getPages: RouteHelper.routes,
    );
  }
}
