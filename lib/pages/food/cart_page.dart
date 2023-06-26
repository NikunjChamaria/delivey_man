// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constants/item.dart';

// ignore: must_be_immutable
class CartPage extends StatefulWidget {
  final Map restaurant;

  final List response;
  num totalAmount;
  CartPage(
      {super.key,
      required this.restaurant,
      required this.response,
      required this.totalAmount});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Map restaurant;

  late List response;
  late num totalAmount;
  late double deliveryFee;
  late double gst;
  double distance = 0.0;
  Set pricelist = {};
  double tip = 0;
  bool isCartEmpty = false;
  @override
  void initState() {
    super.initState();
    restaurant = widget.restaurant;

    response = widget.response;
    totalAmount = widget.totalAmount;
    deliveryFee = distance * 18;
    deliveryFee = deliveryFee.floor().toDouble();
    gst = totalAmount * 0.05;
  }

  void saveHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String email = JwtDecoder.decode(token!)['email'];
    var dt = DateTime.now();
    String time = "${dt.day}/${dt.month}/${dt.year} at ${dt.hour}:${dt.minute}";
    var keys = itemCount.keys.toList();
    var req = {
      "userEmail": email,
      "restaurant": restaurant['resName'],
      "items": itemCount,
      "time": time,
      "amount": widget.totalAmount + deliveryFee + tip + 2 + gst,
      "price": pricelist.toList()
    };
    var response = await http.post(Uri.parse(CARTHISTORYUPLOAD),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(req));
    //print(response);
  }

  @override
  void setState(VoidCallback fn) {
    itemCount = itemCount;
    print(itemCount);
    super.setState(fn);
  }

  void onTap1(String key, num n, int a) async {
    if (itemCount.containsKey(key)) {
      int? i = itemCount[key];
      itemCount[key] = i! + a;
    } else {
      itemCount[key] = 1;
    }
    if (itemCount[key] == 0) {
      itemCount.remove(key);
    }
    setState(() {
      widget.totalAmount = widget.totalAmount + (n * a);
      gst = widget.totalAmount * 0.05;
    });

    if (itemCount.isEmpty) {
      setState(() {
        isCartEmpty = true;
        Get.back();
      });
    }

    //print(itemCount);
  }

  int price(String key) {
    for (var a in response) {
      if (a['name'] == key.trim()) {
        pricelist.add(a['price']);
        return a['price'];
      }
    }
    return 0;
  }

  Future<double?> getdistinTime() async {
    List response = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String email = JwtDecoder.decode(token!)['email'];
    var data = await http.post(Uri.parse(GETCURRENT),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"useremail": email}));
    response = jsonDecode(data.body);
    //print(response);
    distance = GeolocatorPlatform.instance.distanceBetween(
        response[0]["lat"],
        response[0]["long"],
        widget.restaurant["lat"],
        widget.restaurant["long"]);
    distance = distance / 1000;
    distance = double.parse(distance.toStringAsFixed(2));

    if (mounted) {
      deliveryFee = distance * 18;
    }

    return distance;
  }

  Future<double?> getDeliveryFee() async {
    double? dist = await getdistinTime();
    dist = dist! * 18;
    dist = double.parse(distance.toStringAsFixed(2));
    return dist;
  }

  @override
  Widget build(BuildContext context) {
    double dist;
    //print(distance);
    setState(() {
      itemCount = itemCount;
    });
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          restaurant['resName'],
          style: appstyle(
              Theme.of(context).colorScheme.secondary, 16, FontWeight.bold),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.secondary,
            size: 16,
          ),
        ),
      ),
      body: isCartEmpty
          ? Center(
              child: SizedBox(
              height: 300,
              width: double.maxFinite,
              child: Column(
                children: [
                  Text(
                    "Your Cart Is empty",
                    style: appstyle(Theme.of(context).colorScheme.secondary, 30,
                        FontWeight.bold),
                  )
                ],
              ),
            ))
          : SingleChildScrollView(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Theme.of(context).colorScheme.tertiary,
                            offset: const Offset(0, 2),
                          )
                        ],
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.house_sharp,
                              color: Color(0xFFEBFA14),
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 0, 0, 0),
                              child: FutureBuilder(
                                  future: getdistinTime(),
                                  builder: (context,
                                      AsyncSnapshot<double?> snapshot) {
                                    return Text(
                                        '${snapshot.data} km to Location ',
                                        style: appstyle(
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            16,
                                            FontWeight.w600));
                                  }),
                            ),
                            Text(' |  Tap to Update',
                                style: appstyle(
                                    Theme.of(context).colorScheme.secondary,
                                    14,
                                    FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 30),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Theme.of(context).colorScheme.tertiary,
                            offset: const Offset(0, 2),
                          )
                        ],
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ListView.builder(
                                itemCount: itemCount.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var keys = itemCount.keys.toList();

                                  return Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 20),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF067525),
                                                  width: 1,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.radio_button_checked,
                                                color: Color(0xFF067525),
                                                size: 16,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(10, 0, 0, 0),
                                              child: Text(keys[index],
                                                  style: appstyle(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      14,
                                                      FontWeight.w400)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(25, 0, 25, 0),
                                          child: Material(
                                            color: Colors.transparent,
                                            elevation: 1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF464242),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(5, 5, 5, 5),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        onTap1(
                                                            keys[index],
                                                            price(keys[index]),
                                                            -1);
                                                      },
                                                      child: Icon(
                                                        Icons.remove,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                        size: 24,
                                                      ),
                                                    ),
                                                    Text(
                                                        itemCount[keys[index]]
                                                            .toString(),
                                                        style: appstyle(
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                            14,
                                                            FontWeight.normal)),
                                                    GestureDetector(
                                                      onTap: () {
                                                        //print('yo');

                                                        onTap1(
                                                            keys[index],
                                                            price(keys[index]),
                                                            1);
                                                      },
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                        size: 24,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                            '\$${price(keys[index]).toInt() * itemCount[keys[index]]!.toInt()}',
                                            style: appstyle(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                14,
                                                FontWeight.normal)),
                                      ],
                                    ),
                                  );
                                }),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 12,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                    child: Text('Add more Items',
                                        style: appstyle(
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            12,
                                            FontWeight.normal)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 20),
                    child: Text(
                      'Offers and Benefits',
                      style: appstyle(Theme.of(context).colorScheme.secondary,
                          20, FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Theme.of(context).colorScheme.tertiary,
                            offset: const Offset(0, 2),
                          )
                        ],
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 20, 10, 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Apply Coupon',
                              style: appstyle(
                                  Theme.of(context).colorScheme.secondary,
                                  14,
                                  FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 0, 0, 0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 20),
                    child: Text('Tip Your Delivery Partner',
                        style: appstyle(Theme.of(context).colorScheme.secondary,
                            20, FontWeight.bold)),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Theme.of(context).colorScheme.tertiary,
                            offset: const Offset(0, 2),
                          )
                        ],
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thank your delivery partner by leaving them a tip',
                              style: appstyle(
                                  Theme.of(context).colorScheme.secondary,
                                  12,
                                  FontWeight.w500),
                            ),
                            Text(
                              '100% of the tip will go to your delivery partner',
                              style: appstyle(
                                  Theme.of(context).colorScheme.secondary,
                                  12,
                                  FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 20, 10, 20),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        tip = 20;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15, 5, 15, 5),
                                        child: Text(
                                          '\$20',
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              14,
                                              FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        tip = 30;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15, 5, 15, 5),
                                        child: Text(
                                          '\$30',
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              14,
                                              FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        tip = 50;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15, 5, 15, 5),
                                        child: Text(
                                          '\$50',
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              14,
                                              FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        tip = 0;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15, 5, 15, 5),
                                        child: Text(
                                          'Remove',
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              14,
                                              FontWeight.w400),
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 20),
                    child: Text(
                      'Bil Details',
                      style: appstyle(Theme.of(context).colorScheme.secondary,
                          20, FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Theme.of(context).colorScheme.tertiary,
                            offset: const Offset(0, 2),
                          )
                        ],
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Item Total',
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        12,
                                        FontWeight.w600),
                                  ),
                                  Text(
                                    '\$${widget.totalAmount}',
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        14,
                                        FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery Fee',
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        12,
                                        FontWeight.w600),
                                  ),
                                  FutureBuilder(
                                      future: getDeliveryFee(),
                                      builder: (context,
                                          AsyncSnapshot<double?> snapshot) {
                                        double fee = snapshot.data! * 15;
                                        fee = double.parse(
                                            fee.toStringAsFixed(2));
                                        return Text(
                                          snapshot.connectionState ==
                                                  ConnectionState.waiting
                                              ? ""
                                              : '\$$fee',
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              14,
                                              FontWeight.w400),
                                        );
                                      }),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery Tip',
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        12,
                                        FontWeight.w600),
                                  ),
                                  Text(
                                    '\$$tip',
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        14,
                                        FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Platform fee',
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        12,
                                        FontWeight.w600),
                                  ),
                                  Text(
                                    '\$2.00',
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        14,
                                        FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'GST and Restaurant Charges',
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        12,
                                        FontWeight.w600),
                                  ),
                                  Text(
                                    '\$$gst',
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        14,
                                        FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 30, 0, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'To Pay',
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        12,
                                        FontWeight.w600),
                                  ),
                                  FutureBuilder(
                                      future: getDeliveryFee(),
                                      builder: (context,
                                          AsyncSnapshot<double?> snapshot) {
                                        num deliverfee =
                                            snapshot.connectionState ==
                                                    ConnectionState.waiting
                                                ? 0
                                                : snapshot.data! * 15;
                                        return Text(
                                          '\$${widget.totalAmount + deliverfee + tip + 2 + gst}',
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              14,
                                              FontWeight.w400),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
      bottomNavigationBar: isCartEmpty
          ? const SizedBox.shrink()
          : GestureDetector(
              onTap: () {
                saveHistory();
                Get.toNamed(RouteHelper.checkout);
              },
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Theme.of(context).colorScheme.tertiary,
                        offset: const Offset(1, 1),
                      )
                    ],
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
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
                                    FutureBuilder(
                                        future: getDeliveryFee(),
                                        builder: (context,
                                            AsyncSnapshot<double?> snapshot) {
                                          num deliverfee =
                                              snapshot.connectionState ==
                                                      ConnectionState.waiting
                                                  ? 0
                                                  : snapshot.data! * 15;
                                          num total = deliverfee +
                                              widget.totalAmount +
                                              tip +
                                              2 +
                                              gst;
                                          total = total.toDouble();
                                          total = double.parse(
                                              total.toStringAsFixed(2));
                                          return Text(
                                            '\$$total',
                                            style: appstyle(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                14,
                                                FontWeight.w400),
                                          );
                                        }),
                                  ],
                                ),
                                Text('View Detailed Bill',
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        12,
                                        FontWeight.w600)),
                              ],
                            ),
                            Text(' Proceed To Pay',
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
            ),
    );
  }
}
