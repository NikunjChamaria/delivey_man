import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/height_spacer.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/constants/width_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantPage extends StatefulWidget {
  final Map restaurant;
  const RestaurantPage({super.key, required this.restaurant});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  bool isCartEmpty = true;

  int cartItem = 0;
  int cartITEM = 0;
  num totalAmount = 0;
  Map<String, int> itemCount = {};

  List? response1;

  Future<List> downloadFood() async {
    List response = [];
    var data = await http.post(Uri.parse(FOOD1),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"resName": widget.restaurant['resName']}));

    if (data.statusCode == 200) {
      if (mounted) {
        response = json.decode(data.body);

        response1 = json.decode(data.body);
      }
    }
    //print(response1);
    return response;

    //print(response);
  }

  Future<double> getdistinTime() async {
    List response = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String email = JwtDecoder.decode(token!)['email'];
    var data = await http.post(Uri.parse(GETCURRENT),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"useremail": email}));
    response = jsonDecode(data.body);
    print(response);
    var distance = GeolocatorPlatform.instance.distanceBetween(
        response[0]["lat"],
        response[0]["long"],
        widget.restaurant["lat"],
        widget.restaurant["long"]);
    distance = distance / 1000;
    distance = double.parse(distance.toStringAsFixed(2));
    return distance;
  }

  String getFoodType(List list) {
    String s = "";
    for (var name in list) {
      s = "$s, " + name;
    }
    return (s.substring(2));
  }

  void onTap1(String key, num n, int a) {
    itemCount.update(key, (val) => val + a, ifAbsent: () => 1);
    if (itemCount[key] == 0) {
      itemCount.remove(key);
    }
    setState(() {
      totalAmount = totalAmount + (n * a);
      cartItem = 0;
      itemCount.forEach((key, value) {
        cartItem = cartItem + value;
      });
    });
    //print(itemCount);
  }

  void onTap2() {
    print("y0");
  }

  @override
  Widget build(BuildContext context) {
    Future<Uint8List> downloadImage() async {
      var data = await http.post(
        Uri.parse(DOWNLOADIMAGE),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'ownerEmail': widget.restaurant['ownerEmail'],
          'resName': widget.restaurant['resName']
        }),
      );

      var response = jsonDecode(data.body);
      //print(response[0]['image']['data']['data']);
      List<dynamic> yo = response[0]['image']['data']['data'];
      List<int> bufferInt = yo.map((e) => e as int).toList();

      Uint8List imageData = Uint8List.fromList(bufferInt);
      return imageData;
    }

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              forceElevated: true,
              toolbarHeight: 200,
              floating: true,
              snap: true,
              stretch: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              flexibleSpace: FlexibleSpaceBar(
                background: FutureBuilder(
                    future: downloadImage(),
                    builder: (context, AsyncSnapshot<Uint8List?> snapshot1) {
                      return snapshot1.connectionState == ConnectionState.done
                          ? CachedMemoryImage(
                              uniqueKey: widget.restaurant['resName'],
                              bytes: snapshot1.data,
                              fit: BoxFit.fill,
                            )
                          : Shimmer.fromColors(
                              baseColor:
                                  Theme.of(context).colorScheme.secondary,
                              highlightColor:
                                  Theme.of(context).colorScheme.primary,
                              child: Container(
                                color: Theme.of(context).colorScheme.primary,
                                width: double.maxFinite,
                              ));
                    }),
              ),
              expandedHeight: 300,
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.restaurant['resName'],
                                      style: appstyle(
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          22,
                                          FontWeight.w900)),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(90, 0, 10, 0),
                                        child: Icon(
                                          Icons.share_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: 22,
                                        ),
                                      ),
                                      Icon(
                                        Icons.favorite_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: 22,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF067525),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.star_rate_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 10,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                    child: Text(
                                        '${widget.restaurant['rating']}(${widget.restaurant['comments']} + ratings)   . ',
                                        style: appstyle(
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            14,
                                            FontWeight.w500)),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                    child: Text(
                                      '\$${widget.restaurant['averagePrice']} for two',
                                      style: appstyle(
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          14,
                                          FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(getFoodType(widget.restaurant['foodType']),
                                style: appstyle(
                                    Theme.of(context).colorScheme.secondary,
                                    14,
                                    FontWeight.w200)),
                            Divider(
                              thickness: 0.1,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  child: Text('Outlet',
                                      style: appstyle(
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          12,
                                          FontWeight.w600)),
                                ),
                                Text(widget.restaurant['location'],
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        12,
                                        FontWeight.w300)),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  child: FutureBuilder(
                                      future: getdistinTime(),
                                      builder: (context,
                                          AsyncSnapshot<double?> snapshot) {
                                        return Text("${snapshot.data} km",
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            style: appstyle(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                12,
                                                FontWeight.w600));
                                      }),
                                ),
                                Text('Delivery to Meena Pearl',
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        12,
                                        FontWeight.w300)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
            SliverToBoxAdapter(
                child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 20, 10, 0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    offset: const Offset(0, 2),
                                  )
                                ]),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.local_offer_outlined,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 45,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '20% off upto \$120',
                                        style: appstyle(
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            22,
                                            FontWeight.w800),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'USE FEDERRALCC | ',
                                            style: appstyle(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                12,
                                                FontWeight.w400),
                                          ),
                                          Text(
                                            'ABOVE \$249',
                                            style: appstyle(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                12,
                                                FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const HeightSpacer(height: 20),
                Center(
                  child: Text(
                    "MENU",
                    style: appstyle(Theme.of(context).colorScheme.secondary, 14,
                        FontWeight.w300),
                  ),
                ),
                const HeightSpacer(height: 20),
                FutureBuilder(
                    future: downloadFood(),
                    builder: (context, AsyncSnapshot<List?> snapshot) {
                      //print(snapshot.data);
                      return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 30),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              snapshot.hasData ? snapshot.data!.length : 0,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            int price(String key) {
                              for (var a in snapshot.data!) {
                                if (a['name'] == key.trim()) {
                                  return a['price'];
                                }
                              }
                              return 0;
                            }

                            Future<Uint8List> downloadImage() async {
                              var req = {
                                'ownerEmail': widget.restaurant['ownerEmail'],
                                'resName': widget.restaurant['resName'],
                                'foodName': snapshot.data![index]['name']
                              };
                              //print(req);
                              var data = await http.post(
                                Uri.parse(DOWNLOADFOODIMAGE),
                                headers: {"Content-Type": "application/json"},
                                body: jsonEncode(req),
                              );

                              var response = jsonDecode(data.body);
                              //print(response);
                              //print(response[0]['image']['data']['data']);
                              List<dynamic> yo =
                                  response[0]['image']['data']['data'];
                              List<int> bufferInt =
                                  yo.map((e) => e as int).toList();
                              //print(bufferInt);

                              Uint8List imageData =
                                  Uint8List.fromList(bufferInt);
                              return imageData;
                            }

                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 30, 5, 0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 0, 0, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                elevation: 1,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFF067525),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons
                                                        .radio_button_checked_outlined,
                                                    color: Color(0xFF067525),
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                              index == 0
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              10, 0, 0, 0),
                                                      child: Text(
                                                        'Bestseller',
                                                        style: appstyle(
                                                            Colors.red,
                                                            12,
                                                            FontWeight.normal),
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                            ],
                                          ),
                                          Text(
                                            snapshot.data![index]['name'],
                                            style: appstyle(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                16,
                                                FontWeight.w700),
                                          ),
                                          Text(
                                            '\$${snapshot.data![index]['price']}',
                                            style: appstyle(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                16,
                                                FontWeight.w300),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              RatingBar.builder(
                                                onRatingUpdate: (value) {},
                                                itemBuilder: (context, index) =>
                                                    Icon(
                                                  Icons.star_rounded,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                                direction: Axis.horizontal,
                                                initialRating: 4,
                                                unratedColor:
                                                    const Color(0xFFADBBBB),
                                                itemCount: 5,
                                                itemSize: 15,
                                                glowColor: Colors.orange,
                                              ),
                                              Text(
                                                snapshot.data![index]['rating']
                                                    .toString(),
                                                style: appstyle(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    14,
                                                    FontWeight.w400),
                                              ),
                                              Text(
                                                  '(${snapshot.data![index]['comments']})',
                                                  style: appstyle(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      14,
                                                      FontWeight.w400)),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 20, 0, 0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: transparent,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            3, 3, 3, 3),
                                                    child: Text(
                                                      'More Details',
                                                      style: appstyle(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                          14,
                                                          FontWeight.w500),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    size: 14,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              70, 0, 20, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 10, 0, 0),
                                            child: Container(
                                              width: 120,
                                              height: 100,
                                              decoration: const BoxDecoration(
                                                  color: transparent),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: FutureBuilder(
                                                    future: downloadImage(),
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                                Uint8List?>
                                                            snapshot1) {
                                                      return snapshot1
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .done
                                                          ? CachedMemoryImage(
                                                              uniqueKey:
                                                                  snapshot.data![
                                                                          index]
                                                                      ['name'],
                                                              bytes: snapshot1
                                                                  .data,
                                                              fit: BoxFit.fill,
                                                            )
                                                          : Shimmer.fromColors(
                                                              baseColor: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                              highlightColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary),
                                                                height: 100,
                                                                width: 120,
                                                              ));
                                                    }),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 10, 0, 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                    offset: const Offset(0, 1),
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, 0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 10, 0, 10),
                                                child: GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onTap: () {
                                                    itemCount.containsKey(
                                                            snapshot.data![
                                                                index]['name'])
                                                        ? onTap2
                                                        : onTap1(
                                                            snapshot.data![
                                                                index]['name'],
                                                            snapshot.data![
                                                                index]['price'],
                                                            1);
                                                  },
                                                  child:
                                                      itemCount.containsKey(
                                                              snapshot.data![
                                                                      index]
                                                                  ['name'])
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      onTap1(
                                                                          snapshot.data![index]
                                                                              [
                                                                              'name'],
                                                                          snapshot.data![index]
                                                                              [
                                                                              'price'],
                                                                          1);
                                                                    },
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      size: 22,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                    ),
                                                                  ),
                                                                  const WidthSpacer(
                                                                      width: 5),
                                                                  Text(
                                                                    itemCount[snapshot.data![index]
                                                                            [
                                                                            'name']]
                                                                        .toString(),
                                                                    style: appstyle(
                                                                        Theme.of(context)
                                                                            .colorScheme
                                                                            .secondary,
                                                                        22,
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                  const WidthSpacer(
                                                                      width: 5),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      onTap1(
                                                                          snapshot.data![index]
                                                                              [
                                                                              'name'],
                                                                          snapshot.data![index]
                                                                              [
                                                                              'price'],
                                                                          -1);
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      size: 22,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              child: Text(
                                                                'ADD',
                                                                style: appstyle(
                                                                    Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .secondary,
                                                                    22,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
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
                          });
                    })
              ],
            ))
          ],
        ),
        bottomNavigationBar: cartItem == 0
            ? const SizedBox.shrink()
            : GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.cart, arguments: {
                    'restaurant': widget.restaurant,
                    'itemCount': itemCount,
                    'response': response1,
                    'totalAmount': totalAmount
                  });
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Theme.of(context).colorScheme.tertiary,
                              offset: const Offset(1, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF212425),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text('$cartItem Item |  ',
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              18,
                                              FontWeight.w500)),
                                      Text('\$$totalAmount',
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              18,
                                              FontWeight.w500)),
                                    ],
                                  ),
                                  Text('Extra Chargers may apply',
                                      style: appstyle(
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          8,
                                          FontWeight.w600)),
                                ],
                              ),
                              Text(' View Cart',
                                  style: appstyle(
                                      Theme.of(context).colorScheme.secondary,
                                      14,
                                      FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }
}
