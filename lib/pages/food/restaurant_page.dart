import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/height_spacer.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/constants/width_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RestaurantPage extends StatefulWidget {
  final Map restaurant;
  const RestaurantPage({super.key, required this.restaurant});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  bool isCartEmpty = true;
  List? response;
  int cartItem = 0;
  int cartITEM = 0;
  num totalAmount = 0;
  Map<String, int> itemCount = {};

  @override
  void initState() {
    super.initState();

    downloadFood();
  }

  void downloadFood() async {
    var data = await http.post(Uri.parse(FOOD1),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"resName": widget.restaurant['resName']}));

    if (data.statusCode == 200) {
      if (mounted) {
        setState(() {
          response = json.decode(data.body);
        });
      }
    }

    //print(response);
  }

  @override
  void dispose() {
    downloadFood();
    response;
    super.dispose();
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

  int price(String key) {
    for (var a in response!) {
      if (a['name'] == key.trim()) {
        return a['price'];
      }
    }
    return 0;
  }

  void onTap2() {
    print("y0");
  }

  @override
  Widget build(BuildContext context) {
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
                background: CachedNetworkImage(
                  imageUrl: widget.restaurant['imageUrl'],
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
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
                                  child: Text("${widget.restaurant['dist']} km",
                                      style:
                                          appstyle(black, 12, FontWeight.w600)),
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
                const Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: SearchBar(
                    trailing: [
                      Icon(Icons.search),
                    ],
                  ),
                ),
                ListView.builder(
                    padding: const EdgeInsets.only(bottom: 30),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: response == null ? 0 : response!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return response == null
                          ? const SizedBox.shrink()
                          : Padding(
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
                                            response![index]['name'],
                                            style: appstyle(
                                                black, 16, FontWeight.w700),
                                          ),
                                          Text(
                                            '\$${response![index]['price']}',
                                            style: appstyle(
                                                black, 16, FontWeight.w300),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              RatingBar.builder(
                                                onRatingUpdate: (value) {},
                                                itemBuilder: (context, index) =>
                                                    Icon(
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
                                                response![index]['rating']
                                                    .toString(),
                                                style: appstyle(
                                                    black, 14, FontWeight.w400),
                                              ),
                                              Text(
                                                  '(${response![index]['comments']})',
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
                                                  Icon(
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
                                                child: CachedNetworkImage(
                                                  imageUrl: response![index]
                                                      ['imageUrl'],
                                                  width: 250,
                                                  height: 20,
                                                  fit: BoxFit.cover,
                                                ),
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
                                                            response![index]
                                                                ['name'])
                                                        ? onTap2
                                                        : onTap1(
                                                            response![index]
                                                                ['name'],
                                                            response![index]
                                                                ['price'],
                                                            1);
                                                  },
                                                  child:
                                                      itemCount.containsKey(
                                                              response![index]
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
                                                                          response![index]
                                                                              [
                                                                              'name'],
                                                                          response![index]
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
                                                                  WidthSpacer(
                                                                      width: 5),
                                                                  Text(
                                                                    itemCount[response![index]
                                                                            [
                                                                            'name']]
                                                                        .toString(),
                                                                    style: appstyle(
                                                                        black,
                                                                        22,
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                  WidthSpacer(
                                                                      width: 5),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      onTap1(
                                                                          response![index]
                                                                              [
                                                                              'name'],
                                                                          response![index]
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
                    'response': response,
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
