import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/pages/home/home.dart';
import 'package:delivery_man/pages/on%20board/home_page_.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
  final token;
  const MyApp({super.key, required this.isToken, required this.token});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          (isToken) == true ? HomeWidget(token: token) : const HomePageWidget(),
      //initialRoute: RouteHelper.auth,
      getPages: RouteHelper.routes,
    );
  }
}
