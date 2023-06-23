import 'dart:convert';

import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constants/server.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<String> getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String email = JwtDecoder.decode(token!)['email'];
    return email;
  }

  Future<String> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String name = JwtDecoder.decode(token!)['name'];
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: GestureDetector(
            onTap: () {
              ZoomDrawer.of(context)!.open();
            },
            child: const Icon(Icons.menu)),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
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
                                child: FutureBuilder(
                                    future: getName(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        'Hi, ${snapshot.data}',
                                        style: appstyle(
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            28,
                                            FontWeight.bold),
                                      );
                                    }),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(-1, 0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24, 174, 0, 0),
                                  child: FutureBuilder(
                                      future: getEmail(),
                                      builder: (context, snapshot) {
                                        return Text(
                                          '${snapshot.data}',
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              14,
                                              FontWeight.normal),
                                        );
                                      }),
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
                  style: appstyle(Theme.of(context).colorScheme.secondary, 14,
                      FontWeight.normal),
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
                              style: appstyle(
                                  Theme.of(context).colorScheme.secondary,
                                  14,
                                  FontWeight.normal),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: const AlignmentDirectional(0.9, 0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.secondary,
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
                                style: appstyle(
                                    Theme.of(context).colorScheme.secondary,
                                    14,
                                    FontWeight.normal),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: const AlignmentDirectional(0.9, 0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                              style: appstyle(
                                  Theme.of(context).colorScheme.secondary,
                                  14,
                                  FontWeight.normal),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: const AlignmentDirectional(0.9, 0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.secondary,
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
                                style: appstyle(
                                    Theme.of(context).colorScheme.secondary,
                                    14,
                                    FontWeight.normal),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: const AlignmentDirectional(0.9, 0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                      border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1)),
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
                      color: Theme.of(context).colorScheme.background,
                      color2: Theme.of(context).colorScheme.secondary,
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
