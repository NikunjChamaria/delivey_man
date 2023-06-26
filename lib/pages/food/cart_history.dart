import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_man/constants/item.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/constants/width_spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../../constants/route.dart';

class CartHistory extends StatefulWidget {
  const CartHistory({super.key});

  @override
  State<CartHistory> createState() => _CartHistoryState();
}

class _CartHistoryState extends State<CartHistory> {
  @override
  void initState() {
    super.initState();
  }

  Future<Map<Map, Map>> getData() async {
    Map<Map, Map> snapshot = {};

    List response = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String email = JwtDecoder.decode(token!)['email'];
    var req = {'userEmail': email};
    var data = await http.post(Uri.parse(CARTHISTORYDOWNLOAD),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(req));

    response = json.decode(data.body);
    response = response.reversed.toList();

    for (var n in response) {
      var req = {'resName': n['restaurant']};
      var data = await http.post(Uri.parse(RESTAURANT2),
          headers: {"Content-Type": "application/json"}, body: jsonEncode(req));

      Map map = json.decode(data.body)[0];
      snapshot[n] = map;
    }

    return snapshot;
  }

  Future<void> postFav(String userEmail, String time, bool isFav) async {
    // ignore: unused_local_variable
    var data = await http.post(Uri.parse(POSTFAV),
        headers: {"Content-Type": "application/json"},
        body:
            jsonEncode({'userEmail': userEmail, 'time': time, 'isFav': isFav}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10),
                child: Text(
                  "Your Recent Orders",
                  style: appstyle(Theme.of(context).colorScheme.secondary, 30,
                      FontWeight.normal),
                ),
              ),
              FutureBuilder(
                  future: getData(),
                  builder: (context, AsyncSnapshot<Map?> snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? Center(
                            child: SizedBox(
                            width: 200.0,
                            height: 100.0,
                            child: Shimmer.fromColors(
                                baseColor: Colors.red,
                                highlightColor: Colors.yellow,
                                child: Container()),
                          ))
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.isEmpty
                                ? 0
                                : snapshot.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var keys = snapshot.data!.keys.toList();
                              bool isFav = keys[index]['isFav'];
                              //print(snapshot.data![keys[0]]);
                              //print(keys[0]);
                              Future<Uint8List> downloadImage() async {
                                var data = await http.post(
                                  Uri.parse(DOWNLOADIMAGE),
                                  headers: {"Content-Type": "application/json"},
                                  body: jsonEncode({
                                    'ownerEmail': snapshot.data![keys[index]]
                                        ['ownerEmail'],
                                    'resName': snapshot.data![keys[index]]
                                        ['resName'],
                                  }),
                                );

                                var response = jsonDecode(data.body);
                                //print(response[0]['image']['data']['data']);
                                List<dynamic> yo =
                                    response[0]['image']['data']['data'];
                                List<int> bufferInt =
                                    yo.map((e) => e as int).toList();

                                Uint8List imageData =
                                    Uint8List.fromList(bufferInt);
                                return imageData;
                              }

                              return Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5, 5, 5, 5),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
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
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ClipRRect(
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
                                                          ? Container(
                                                              width: 50,
                                                              height: 50,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                child:
                                                                    CachedMemoryImage(
                                                                  uniqueKey: snapshot
                                                                              .data![
                                                                          keys[
                                                                              index]]
                                                                      [
                                                                      'resName'],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  bytes:
                                                                      snapshot1
                                                                          .data!,
                                                                ),
                                                              ),
                                                            )
                                                          : CachedNetworkImage(
                                                              imageUrl:
                                                                  'https://cdn-icons-png.flaticon.com/512/147/147144.png?w=360',
                                                              height: 50,
                                                              width: 50,
                                                              fit: BoxFit.cover,
                                                            );
                                                    }),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(10, 0, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                        keys[index]
                                                            ['restaurant'],
                                                        style: appstyle(
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                            14,
                                                            FontWeight.w600),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data![
                                                              keys[index]]
                                                          ['location'],
                                                      style: appstyle(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                          10,
                                                          FontWeight.w300),
                                                    ),
                                                    Text(
                                                      'Deliver to your location',
                                                      style: appstyle(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                          10,
                                                          FontWeight.w800),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(20, 0, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              2, 2, 2, 2),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary),
                                                        child: Text(
                                                          keys[index][
                                                                  'isDelivered']
                                                              ? 'Delivered'
                                                              : 'Preparing',
                                                          style: appstyle(
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                              12,
                                                              FontWeight.w500),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              isFav = !isFav;
                                                              postFav(
                                                                  keys[index][
                                                                      'userEmail'],
                                                                  keys[index]
                                                                      ['time'],
                                                                  isFav);
                                                            });
                                                          },
                                                          child: isFav
                                                              ? const Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: Colors
                                                                      .pink,
                                                                  size: 30,
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .favorite_border,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 30,
                                                                ),
                                                        ),
                                                        const WidthSpacer(
                                                            width: 10),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            List response = [];
                                                            var data =
                                                                await http.post(
                                                                    Uri.parse(
                                                                        FOOD1),
                                                                    headers: {
                                                                      "Content-Type":
                                                                          "application/json"
                                                                    },
                                                                    body:
                                                                        jsonEncode({
                                                                      "resName":
                                                                          snapshot.data![keys[index]]
                                                                              [
                                                                              'resName']
                                                                    }));

                                                            if (data.statusCode ==
                                                                200) {
                                                              if (mounted) {
                                                                response = json
                                                                    .decode(data
                                                                        .body);
                                                              }
                                                            }
                                                            Map<String, dynamic>
                                                                itemdy =
                                                                keys[index]
                                                                    ['items'];
                                                            itemCount = itemdy
                                                                .map<String,
                                                                        int>(
                                                                    (key,
                                                                        value) {
                                                              return MapEntry<
                                                                      String,
                                                                      int>(key,
                                                                  value as int);
                                                            });
                                                            num totalAmount = 0;
                                                            var key = keys[
                                                                        index]
                                                                    ["items"]
                                                                .keys
                                                                .toList();
                                                            for (int n = 0;
                                                                n <
                                                                    keys[index][
                                                                            'price']
                                                                        .length;
                                                                n++) {
                                                              totalAmount = totalAmount +
                                                                  (keys[index][
                                                                              'price']
                                                                          [n] *
                                                                      keys[index]
                                                                              [
                                                                              'items']
                                                                          [
                                                                          key[n]]);
                                                            }
                                                            Get.toNamed(
                                                                RouteHelper
                                                                    .cart,
                                                                arguments: {
                                                                  'restaurant':
                                                                      snapshot.data![
                                                                          keys[
                                                                              index]],
                                                                  'response':
                                                                      response,
                                                                  'totalAmount':
                                                                      totalAmount
                                                                });
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                            .grey[
                                                                        400]!),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary,
                                                                      offset: Offset
                                                                          .infinite)
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  'Reorder',
                                                                  style: appstyle(
                                                                      Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                      20,
                                                                      FontWeight
                                                                          .w700),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const WidthSpacer(width: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 0, 10, 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListView.builder(
                                                  itemCount: keys[index]
                                                          ["items"]
                                                      .length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, ind) {
                                                    var key = keys[index]
                                                            ["items"]
                                                        .keys
                                                        .toList();
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Container(
                                                            width: 10,
                                                            height: 10,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                              border:
                                                                  Border.all(
                                                                color: const Color(
                                                                    0xFF067525),
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: const Icon(
                                                              Icons
                                                                  .radio_button_checked_rounded,
                                                              color: Color(
                                                                  0xFF067525),
                                                              size: 8,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    10,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            child: Text(
                                                              '${keys[index]["items"][key[ind]]} X ${key[ind]}',
                                                              style: appstyle(
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary,
                                                                  10,
                                                                  FontWeight
                                                                      .w400),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                              Divider(
                                                thickness: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 10),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      keys[index]['time'],
                                                      style: appstyle(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                          10,
                                                          FontWeight.w400),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              160, 0, 0, 0),
                                                      child: Text(
                                                        "\$${keys[index]['amount']}",
                                                        style: appstyle(
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                            10,
                                                            FontWeight.w400),
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
                                ),
                              );
                            });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
