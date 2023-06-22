import 'dart:convert';

import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constants/server.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  var token;
  ProfilePage({super.key, this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String email;
  late String name;

  @override
  void initState() {
    super.initState();

    Map<String, dynamic> jwtDecodedToekn = JwtDecoder.decode(widget.token);
    email = jwtDecodedToekn['email'];
    name = jwtDecodedToekn['name'];
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: backGround,
        leading: GestureDetector(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            child: const Icon(Icons.menu)),
      ),
      backgroundColor: backGround,
      drawer: Drawer(
        elevation: 16,
        child: Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0xFF212425),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        'https://picsum.photos/seed/52/600',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 40,
                      decoration: const BoxDecoration(),
                    ),
                    Text(
                      name,
                      style: const TextStyle(color: white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 15),
                      child: Container(
                        width: 314,
                        height: 46,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const FaIcon(
                              // ignore: deprecated_member_use
                              FontAwesomeIcons.home,
                              color: Colors.white,
                              size: 24,
                            ),
                            Container(
                              width: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF212425),
                              ),
                            ),
                            CustomButton(
                                onTap: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  Get.toNamed(RouteHelper.homw, arguments: {
                                    'token': preferences.getString('token')
                                  });
                                  scaffoldKey.currentState!.closeDrawer();
                                },
                                text: "Home",
                                width: 140,
                                height: 50,
                                color: transparent,
                                color2: white,
                                textSize: 22),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 15),
                      child: Container(
                        width: 314,
                        height: 46,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.no_food_sharp,
                              color: Colors.white,
                              size: 24,
                            ),
                            Container(
                              width: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF212425),
                              ),
                            ),
                            CustomButton(
                                onTap: () {
                                  Get.toNamed(RouteHelper.food);
                                  scaffoldKey.currentState!.closeDrawer();
                                },
                                text: "Food",
                                width: 140,
                                height: 50,
                                color: transparent,
                                color2: white,
                                textSize: 22)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 15),
                      child: Container(
                        width: 314,
                        height: 46,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.local_convenience_store_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            Container(
                              width: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF212425),
                              ),
                            ),
                            CustomButton(
                                onTap: () {
                                  Get.toNamed(RouteHelper.retail);
                                  scaffoldKey.currentState!.closeDrawer();
                                },
                                text: "Retail Store",
                                width: 200,
                                height: 50,
                                color: transparent,
                                color2: white,
                                textSize: 22)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 15),
                      child: Container(
                        width: 314,
                        height: 46,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                            Container(
                              width: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF212425),
                              ),
                            ),
                            CustomButton(
                                onTap: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  Get.toNamed(RouteHelper.profile, arguments: {
                                    'token': preferences.getString('token')
                                  });
                                  scaffoldKey.currentState!.closeDrawer();
                                },
                                text: "Profile",
                                width: 140,
                                height: 50,
                                color: transparent,
                                color2: white,
                                textSize: 22)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 210,
                decoration: const BoxDecoration(
                  color: Color(0xFF212425),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Image.network(
                                  'https://www.daysoftheyear.com/wp-content/uploads/national-fast-food-day.jpg',
                                  width: MediaQuery.of(context).size.width,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(0.85, 0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 90, 0, 0),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.network(
                                      'https://cdn-icons-png.flaticon.com/512/147/147144.png?w=360',
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24, 140, 0, 0),
                                child: Text(
                                  'Hi, $name',
                                  style: appstyle(white, 28, FontWeight.normal),
                                ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(-1, 0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24, 174, 0, 0),
                                  child: Text(
                                    email,
                                    textAlign: TextAlign.start,
                                    style:
                                        appstyle(white, 12, FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 0, 12),
                child: Text(
                  'Profile Settings',
                  style: appstyle(white, 14, FontWeight.normal),
                ),
              ),
            ],
          ),
          ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.editProfile);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xFF212425),
                        shape: BoxShape.rectangle,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 0, 0, 0),
                            child: Text(
                              'Edit Profile',
                              style: appstyle(white, 14, FontWeight.normal),
                            ),
                          ),
                          const Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0.9, 0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  var token = preferences.getString('token');

                  String email = JwtDecoder.decode(token!)['email'];
                  var data = await http.post(Uri.parse(RESTAURANT3),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode({"ownerEmail": email}));
                  List response = jsonDecode(data.body);
                  response.isEmpty
                      ? Get.toNamed(RouteHelper.businessProfileSigIn,
                          arguments: {"address": "", "lat": 0.0, "long": 0.0})
                      : Get.toNamed(RouteHelper.businessProfileMainPage);
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF212425),
                          shape: BoxShape.rectangle,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24, 0, 0, 0),
                              child: Text(
                                'Switch to Business Profile',
                                style: appstyle(white, 14, FontWeight.normal),
                              ),
                            ),
                            const Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(0.9, 0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xFF212425),
                        shape: BoxShape.rectangle,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 0, 0, 0),
                            child: Text(
                              'About App',
                              style: appstyle(white, 14, FontWeight.normal),
                            ),
                          ),
                          const Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0.9, 0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.addLocation);
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF212425),
                          shape: BoxShape.rectangle,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24, 0, 0, 0),
                              child: Text(
                                'Address Book',
                                style: appstyle(white, 14, FontWeight.normal),
                              ),
                            ),
                            const Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(0.9, 0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: white, width: 1)),
                  child: CustomButton(
                      onTap: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.remove('token');
                        print(sharedPreferences.getString('token').toString());
                        Get.toNamed(RouteHelper.auth);
                      },
                      text: "Log Out",
                      width: 90,
                      height: 40,
                      color: backGround,
                      color2: white,
                      textSize: 14),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
