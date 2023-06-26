import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/server.dart';

import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../../constants/route.dart';

// ignore: must_be_immutable
class HomeWidget extends StatefulWidget {
  const HomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List? response;
  List? response1;

  @override
  void initState() {
    super.initState();
    downloadData();
    downloadData1();
  }

  void downloadData() async {
    var data = await http.get(
      Uri.parse(POPULARFOOD),
      headers: {"Content-Type": "application/json"},
    );
    setState(() {
      response = json.decode(data.body);
    });
  }

  void downloadData1() async {
    var data = await http.get(
      Uri.parse(POPULARPRODUCT),
      headers: {"Content-Type": "application/json"},
    );
    setState(() {
      response1 = json.decode(data.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
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
                      child: GestureDetector(
                        onTap: () {},
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://img.freepik.com/premium-photo/mix-vegetables-food-isolated-grey-background_429553-176.jpg?w=2000',
                          width: double.infinity,
                          height: 500,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 600,
                      decoration: const BoxDecoration(color: transparent),
                    ),
                    const SizedBox(
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
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      width: 0.1),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: const BorderRadius.only(
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
                                        Divider(
                                          height: 8,
                                          thickness: 4,
                                          indent: 140,
                                          endIndent: 140,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 16, 16, 0),
                                            child: Text(
                                              'Popular food ',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 24),
                                            )),
                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 4, 16, 0),
                                            child: Text(
                                              'Most searched food itmes',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 14),
                                            )),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 12, 0, 0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 210,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
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
                                                    ? const SizedBox.shrink()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                16, 8, 0, 12),
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          width: 270,
                                                          height: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 4,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .tertiary,
                                                                offset:
                                                                    const Offset(
                                                                        0, 2),
                                                              )
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .tertiary,
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
                                                                            style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Theme.of(context).colorScheme.secondary,
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
                                                                                itemBuilder: (context, index) => Icon(
                                                                                  Icons.radio_button_checked_rounded,
                                                                                  color: Theme.of(context).colorScheme.secondary,
                                                                                ),
                                                                                direction: Axis.horizontal,
                                                                                rating: 4,
                                                                                unratedColor: Theme.of(context).colorScheme.primary,
                                                                                itemCount: 5,
                                                                                itemSize: 16,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                                                                child: Text(
                                                                                  response![index]['rating'],
                                                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.secondary),
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
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .background,
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        alignment: const AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                                                              8,
                                                                              0,
                                                                              8,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            'Explore Food',
                                                                            style:
                                                                                TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary),
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
                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 16, 16, 0),
                                            child: Text(
                                              'Search Products',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 24),
                                            )),
                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 4, 16, 0),
                                            child: Text(
                                              'Most searched products in our app',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 14),
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
                                                  ? const SizedBox.shrink()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              16, 8, 16, 8),
                                                      child: Container(
                                                        width: 270,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 4,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                              offset:
                                                                  const Offset(
                                                                      0, 2),
                                                            )
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .tertiary,
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
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        blurRadius:
                                                                            4,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .tertiary,
                                                                        offset: const Offset(
                                                                            0,
                                                                            2),
                                                                      )
                                                                    ],
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10))),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          12)),
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
                                                                                TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary)),
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
                                                                                itemBuilder: (context, index) => Icon(
                                                                                  Icons.radio_button_checked_rounded,
                                                                                  color: Theme.of(context).colorScheme.secondary,
                                                                                ),
                                                                                direction: Axis.horizontal,
                                                                                rating: 4,
                                                                                unratedColor: Theme.of(context).colorScheme.primary,
                                                                                itemCount: 5,
                                                                                itemSize: 16,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                                                                child: Text(
                                                                                  response1![index]['rating'],
                                                                                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary),
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
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .background,
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                      ),
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            8,
                                                                            0,
                                                                            8,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          'Explore Store',
                                                                          style: TextStyle(
                                                                              color: Theme.of(context).colorScheme.secondary,
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
                        icon: Icon(
                          Icons.menu_sharp,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 24,
                        ),
                        onPressed: () async {
                          ZoomDrawer.of(context)!.open();
                        },
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0.88, -0.90),
                      child: IconButton(
                        color: Colors.transparent,
                        icon: FaIcon(
                          FontAwesomeIcons.solidBell,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 24,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(-0.07, -0.89),
                      child: Text('Mr. Delivery Man',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
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
