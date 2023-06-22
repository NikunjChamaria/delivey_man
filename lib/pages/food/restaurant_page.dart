import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    print(itemCount);
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
        backgroundColor: backGround,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              forceElevated: true,
              toolbarHeight: 200,
              floating: true,
              snap: true,
              stretch: true,
              backgroundColor: backGround,
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
                          : CachedNetworkImage(
                              imageUrl:
                                  'https://cdn-icons-png.flaticon.com/512/147/147144.png?w=360',
                              width: double.infinity,
                              height: 190,
                              fit: BoxFit.cover,
                            );
                    }),
              ),
              expandedHeight: 300,
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.only(
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
                                      style:
                                          appstyle(black, 22, FontWeight.w900)),
                                  const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            90, 0, 10, 0),
                                        child: Icon(
                                          Icons.share_outlined,
                                          color: black,
                                          size: 22,
                                        ),
                                      ),
                                      Icon(
                                        Icons.favorite_outlined,
                                        color: black,
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
                                    child: const Icon(
                                      Icons.star_rate_rounded,
                                      color: Colors.white,
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
                                            black, 14, FontWeight.w500)),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                    child: Text(
                                      '\$${widget.restaurant['averagePrice']} for two',
                                      style:
                                          appstyle(black, 14, FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(getFoodType(widget.restaurant['foodType']),
                                style: appstyle(black, 14, FontWeight.w200)),
                            const Divider(
                              thickness: 0.1,
                              color: Colors.black,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 60,
                                  decoration: const BoxDecoration(
                                    color: white,
                                  ),
                                  child: Text('Outlet',
                                      style:
                                          appstyle(black, 12, FontWeight.w600)),
                                ),
                                Text(widget.restaurant['location'],
                                    style:
                                        appstyle(black, 12, FontWeight.w300)),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 60,
                                  decoration: const BoxDecoration(color: white),
                                  child: FutureBuilder(
                                      future: getdistinTime(),
                                      builder: (context,
                                          AsyncSnapshot<double?> snapshot) {
                                        return Text("${snapshot.data} km",
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            style: appstyle(
                                                black, 12, FontWeight.w600));
                                      }),
                                ),
                                Text('Delivery to Meena Pearl',
                                    style:
                                        appstyle(black, 12, FontWeight.w300)),
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
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(
                                    Icons.local_offer_outlined,
                                    color: black,
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
                                            black, 22, FontWeight.w800),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'USE FEDERRALCC | ',
                                            style: appstyle(
                                                black, 12, FontWeight.w400),
                                          ),
                                          Text(
                                            'ABOVE \$249',
                                            style: appstyle(
                                                black, 12, FontWeight.w400),
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
                    style: appstyle(white, 14, FontWeight.w300),
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
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
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
                                                    color: transparent,
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
                                                black, 16, FontWeight.w700),
                                          ),
                                          Text(
                                            '\$${snapshot.data![index]['price']}',
                                            style: appstyle(
                                                black, 16, FontWeight.w300),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              RatingBar.builder(
                                                onRatingUpdate: (value) {},
                                                itemBuilder: (context, index) =>
                                                    const Icon(
                                                  Icons.star_rounded,
                                                  color: lightGrey,
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
                                                    black, 14, FontWeight.w400),
                                              ),
                                              Text(
                                                  '(${snapshot.data![index]['comments']})',
                                                  style: appstyle(black, 14,
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
                                                  color: Colors.black,
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
                                                      style: appstyle(black, 14,
                                                          FontWeight.w500),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: lightGrey,
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
                                                          : CachedNetworkImage(
                                                              imageUrl:
                                                                  'https://cdn-icons-png.flaticon.com/512/147/147144.png?w=360',
                                                              width: double
                                                                  .infinity,
                                                              height: 190,
                                                              fit: BoxFit.cover,
                                                            );
                                                    }),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 10, 0, 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 1,
                                                    color: Color(0xFF212425),
                                                    offset: Offset(1, 1),
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
                                                                    child:
                                                                        const Icon(
                                                                      Icons.add,
                                                                      size: 22,
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
                                                                        black,
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
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .remove,
                                                                      size: 22,
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
                                                                    black,
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
                    decoration: const BoxDecoration(
                      color: white,
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBFA14),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0xFF212425),
                              offset: Offset(1, 1),
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
                                              black, 18, FontWeight.w500)),
                                      Text('\$$totalAmount',
                                          style: appstyle(
                                              black, 18, FontWeight.w500)),
                                    ],
                                  ),
                                  Text('Extra Chargers may apply',
                                      style:
                                          appstyle(black, 8, FontWeight.w600)),
                                ],
                              ),
                              Text(' View Cart',
                                  style: appstyle(black, 14, FontWeight.w500)),
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
