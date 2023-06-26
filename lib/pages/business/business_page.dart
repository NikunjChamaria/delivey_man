import 'dart:convert';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/height_spacer.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/constants/width_spacer.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/server.dart';
import 'package:http/http.dart' as http;

class BusinessPage extends StatefulWidget {
  final Map restaurant;
  const BusinessPage({super.key, required this.restaurant});

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  Future<List> getFood() async {
    var data = await http.post(Uri.parse(FOOD1),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'resName': widget.restaurant['resName']}));
    List response = jsonDecode(data.body);
    return response;
  }

  Future<List> getOrders() async {
    var data = await http.post(Uri.parse(PREPARING),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'restaurant': widget.restaurant['resName']}));
    List response = jsonDecode(data.body);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          widget.restaurant['resName'],
          style: appstyle(
              Theme.of(context).colorScheme.secondary, 18, FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Orders",
                style: appstyle(Theme.of(context).colorScheme.secondary, 22,
                    FontWeight.w500),
              ),
              const HeightSpacer(height: 20),
              Container(
                decoration: const BoxDecoration(
                    color: transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: FutureBuilder(
                    future: getOrders(),
                    builder: (context, AsyncSnapshot<List?> snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "User email id:",
                                                style: appstyle(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    14,
                                                    FontWeight.bold),
                                              ),
                                              Text(
                                                snapshot.data![index]
                                                    ['userEmail'],
                                                overflow: TextOverflow.fade,
                                                style: appstyle(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    12,
                                                    FontWeight.w300),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Ordered On:",
                                                  style: appstyle(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      14,
                                                      FontWeight.bold)),
                                              Text(
                                                snapshot.data![index]['time'],
                                                overflow: TextOverflow.fade,
                                                style: appstyle(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    12,
                                                    FontWeight.w300),
                                              )
                                            ],
                                          ),
                                          Text("Items Ordered:",
                                              style: appstyle(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  14,
                                                  FontWeight.bold)),
                                          const HeightSpacer(height: 10),
                                          ListView.builder(
                                              itemCount: snapshot
                                                  .data![index]['items'].length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, ind) {
                                                var keys = snapshot
                                                    .data![index]['items'].keys
                                                    .toList();
                                                return Text(
                                                    "${snapshot.data![index]['items'][keys[ind]]} X ${keys[ind]}",
                                                    style: appstyle(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                        12,
                                                        FontWeight.w300));
                                              }),
                                          const HeightSpacer(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Total Amount:",
                                                  style: appstyle(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      14,
                                                      FontWeight.bold)),
                                              Text(
                                                "\$${snapshot.data![index]['amount']}",
                                                overflow: TextOverflow.fade,
                                                style: appstyle(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    12,
                                                    FontWeight.w300),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  // ignore: unused_local_variable
                                                  var data = await http.post(
                                                      Uri.parse(DELIVERED),
                                                      headers: {
                                                        "Content-Type":
                                                            "application/json"
                                                      },
                                                      body: jsonEncode({
                                                        'userEmail': snapshot
                                                                .data![index]
                                                            ['userEmail'],
                                                        'time': snapshot
                                                                .data![index]
                                                            ['time']
                                                      }));
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          spreadRadius: 1,
                                                          blurRadius: 2,
                                                        )
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(10),
                                                      ),
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(
                                                      "Mark as Delivered",
                                                      style: appstyle(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                          14,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                    }),
              ),
              const HeightSpacer(height: 20),
              Text(
                "Your items",
                style: appstyle(Theme.of(context).colorScheme.secondary, 22,
                    FontWeight.w500),
              ),
              FutureBuilder(
                  future: getFood(),
                  builder: (context, AsyncSnapshot<List?> snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator()
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Future<Uint8List> downloadImage() async {
                                var req = {
                                  'ownerEmail': widget.restaurant['ownerEmail'],
                                  'resName': snapshot.data![index]['resName'],
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

                                Uint8List imageData =
                                    Uint8List.fromList(bufferInt);
                                return imageData;
                              }

                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
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
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: FutureBuilder(
                                              future: downloadImage(),
                                              builder: (context,
                                                  AsyncSnapshot<Uint8List?>
                                                      snapshot1) {
                                                return snapshot1
                                                            .connectionState ==
                                                        ConnectionState.done
                                                    ? CachedMemoryImage(
                                                        uniqueKey: snapshot
                                                                .data![index]
                                                            ['name'],
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
                                        const WidthSpacer(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index]['name'],
                                              style: appstyle(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  16,
                                                  FontWeight.w600),
                                            ),
                                            Text(
                                              snapshot.data![index]['price']
                                                  .toString(),
                                              style: appstyle(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  12,
                                                  FontWeight.w300),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                  }),
              const HeightSpacer(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.newFoodPage,
                        arguments: {'resName': widget.restaurant['resName']});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: lightGrey.withOpacity(0.8)),
                        color: Theme.of(context).colorScheme.background,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Add new Item",
                        style: appstyle(Theme.of(context).colorScheme.secondary,
                            14, FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
