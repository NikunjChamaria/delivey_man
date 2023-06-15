import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constants/route.dart';

// ignore: must_be_immutable
class HomeWidget extends StatefulWidget {
  var token;
  HomeWidget({Key? key, this.token}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late String email;
  late String name;
  List? response;
  List? response1;

  @override
  void initState() {
    super.initState();
    downloadData();
    downloadData1();
    Map<String, dynamic> jwtDecodedToekn = JwtDecoder.decode(widget.token);
    email = jwtDecodedToekn['email'];
    name = jwtDecodedToekn['name'];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void downloadData() async {
    var data = await http.get(
      Uri.parse(POPULARFOOD),
      headers: {"Content-Type": "application/json"},
    );
    setState(() {
      response = json.decode(data.body);
    });
    //print(response[0]['name']);
  }

  void downloadData1() async {
    var data = await http.get(
      Uri.parse(POPULARPRODUCT),
      headers: {"Content-Type": "application/json"},
    );
    setState(() {
      response1 = json.decode(data.body);
    });
    //print(response[0]['name']);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: white,
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
                      const Text(
                        'Nikunj',
                        style: TextStyle(color: white, fontSize: 20)
                        /*FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              fontSize: 20,
                            )*/
                        ,
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
                                  textSize: 22)
                              /*FFButtonWidget(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                text: 'Home',
                                options: FFButtonOptions(
                                  height: 40,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Color(0xFF212425),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                      ),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              )*/
                              ,
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
                              /*FFButtonWidget(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                text: 'Food',
                                options: FFButtonOptions(
                                  height: 40,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Color(0xFF212425),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                      ),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),*/
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
                              /*FFButtonWidget(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                text: 'Retail Store',
                                options: FFButtonOptions(
                                  height: 40,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Color(0xFF212425),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                      ),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),*/
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
                                    Get.toNamed(RouteHelper.profile,
                                        arguments: {
                                          'token':
                                              preferences.getString('token')
                                        });
                                    scaffoldKey.currentState!.closeDrawer();
                                  },
                                  text: "Profile",
                                  width: 140,
                                  height: 50,
                                  color: transparent,
                                  color2: white,
                                  textSize: 22)
                              /*FFButtonWidget(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                text: 'Profile',
                                options: FFButtonOptions(
                                  height: 40,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Color(0xFF212425),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                      ),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),*/
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
            Expanded(
              child: SizedBox(
                child: Stack(
                  alignment: const AlignmentDirectional(0, -1),
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0.05, -1),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1286&q=80',
                        width: double.infinity,
                        height: 500,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 600,
                      decoration: const BoxDecoration(color: transparent),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0, 1),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 32, 0, 0),
                              child: Container(
                                width: double.infinity,
                                height: 700,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF212425),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 24),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Divider(
                                          height: 8,
                                          thickness: 4,
                                          indent: 140,
                                          endIndent: 140,
                                          color: white,
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 16, 16, 0),
                                            child: Text(
                                              'Popular food ',
                                              style: TextStyle(
                                                  color: white, fontSize: 24),
                                            )),
                                        const Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 4, 16, 0),
                                            child: Text(
                                              'Most searched food itmes',
                                              style: TextStyle(
                                                  color: white, fontSize: 14),
                                            )),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 12, 0, 0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 210,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF212425),
                                            ),
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              itemCount: response == null
                                                  ? 0
                                                  : response!.length,
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return response == null
                                                    ? SizedBox.shrink()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                16, 8, 0, 12),
                                                        child: Container(
                                                          width: 270,
                                                          height: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: white,
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                blurRadius: 8,
                                                                color: Color(
                                                                    0x230F1113),
                                                                offset: Offset(
                                                                    0, 4),
                                                              )
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            border: Border.all(
                                                              color: black,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          12),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          12),
                                                                ),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: response![
                                                                          index]
                                                                      [
                                                                      'imageUrl'],
                                                                  width: double
                                                                      .infinity,
                                                                  height: 110,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                        16,
                                                                        12,
                                                                        16,
                                                                        12),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            response![index][
                                                                                'name'],
                                                                            style: const TextStyle(
                                                                                fontSize: 16,
                                                                                color: black,
                                                                                fontWeight: FontWeight.normal)),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                                                              0,
                                                                              8,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              RatingBarIndicator(
                                                                                itemBuilder: (context, index) => const Icon(
                                                                                  Icons.radio_button_checked_rounded,
                                                                                  color: black,
                                                                                ),
                                                                                direction: Axis.horizontal,
                                                                                rating: 4,
                                                                                unratedColor: lightGrey,
                                                                                itemCount: 5,
                                                                                itemSize: 16,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                                                                child: Text(
                                                                                  response![index]['rating'],
                                                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: black),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Get.toNamed(
                                                                            RouteHelper.food);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            32,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              black,
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        alignment: const AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            const Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              8,
                                                                              0,
                                                                              8,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            'Explore Food',
                                                                            style:
                                                                                TextStyle(fontSize: 14, color: white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ));
                                              },
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 16, 16, 0),
                                            child: Text(
                                              'Search Products',
                                              style: TextStyle(
                                                  color: white, fontSize: 24),
                                            )),
                                        const Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 4, 16, 0),
                                            child: Text(
                                              'Most searched products in our app',
                                              style: TextStyle(
                                                  color: white, fontSize: 14),
                                            )),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 24),
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            primary: false,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: response1 == null
                                                ? 0
                                                : response1!.length,
                                            itemBuilder: (context, index) {
                                              return response1 == null
                                                  ? SizedBox.shrink()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              16, 8, 16, 8),
                                                      child: Container(
                                                        width: 270,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: white,
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              blurRadius: 8,
                                                              color: Color(
                                                                  0x230F1113),
                                                              offset:
                                                                  Offset(0, 4),
                                                            )
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                            color: black,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Hero(
                                                              tag: response1![
                                                                      index]
                                                                  ['name'],
                                                              transitionOnUserGestures:
                                                                  true,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          12),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          12),
                                                                ),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: response1![
                                                                          index]
                                                                      [
                                                                      'imageUrl'],
                                                                  width: double
                                                                      .infinity,
                                                                  height: 200,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                      16,
                                                                      12,
                                                                      16,
                                                                      12),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            response1![index][
                                                                                'name'],
                                                                            style:
                                                                                const TextStyle(fontSize: 16, color: black)),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                                                              0,
                                                                              8,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              RatingBarIndicator(
                                                                                itemBuilder: (context, index) => const Icon(
                                                                                  Icons.radio_button_checked_rounded,
                                                                                  color: black,
                                                                                ),
                                                                                direction: Axis.horizontal,
                                                                                rating: 4,
                                                                                unratedColor: lightGrey,
                                                                                itemCount: 5,
                                                                                itemSize: 16,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                                                                child: Text(
                                                                                  response1![index]['rating'],
                                                                                  style: const TextStyle(fontSize: 12, color: black),
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
                                                                      Get.toNamed(
                                                                          RouteHelper
                                                                              .retail);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          32,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color:
                                                                            black,
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                      ),
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          const Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            8,
                                                                            0,
                                                                            8,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          'Explore Store',
                                                                          style: TextStyle(
                                                                              color: white,
                                                                              fontSize: 14),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                            },
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            email,
                                            style: appstyle(
                                                white, 12, FontWeight.w800),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            name,
                                            style: appstyle(
                                                white, 12, FontWeight.w800),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(-0.95, -0.91),
                      child: IconButton(
                        color: transparent,
                        icon: const Icon(
                          Icons.menu_sharp,
                          color: white,
                          size: 24,
                        ),
                        onPressed: () async {
                          scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0.88, -0.90),
                      child: IconButton(
                        color: Colors.transparent,
                        icon: const FaIcon(
                          FontAwesomeIcons.solidBell,
                          color: white,
                          size: 24,
                        ),
                        onPressed: () {
                          //print('IconButton pressed ...');
                        },
                      ),
                    ),
                    const Align(
                      alignment: AlignmentDirectional(-0.07, -0.89),
                      child: Text('Mr. Delivery Man',
                          style: TextStyle(
                              color: white,
                              fontSize: 25,
                              fontWeight: FontWeight
                                  .bold) /*FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),*/
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
