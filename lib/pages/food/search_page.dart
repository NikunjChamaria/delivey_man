// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/height_spacer.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/constants/width_spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/server.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool empty = false;
  TextEditingController search = TextEditingController();

  Future<List> searchRestaurant() async {
    var response = await http.post(Uri.parse(SEARCHRES),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'text': search.text}));
    List data = jsonDecode(response.body);
    //print(data);
    return data;
  }

  Future<List> searchFood() async {
    var response = await http.post(Uri.parse(SEARCHFOOD),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'text': search.text}));
    List data = jsonDecode(response.body);
    //print(data);
    return data;
  }

  void postSearch(
    String userEmail,
    String resName,
    String foodName,
  ) async {
    var response = await http.post(Uri.parse(POSTSEARCH),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'userEmail': userEmail,
          'resName': resName,
          'foodName': foodName,
        }));
  }

  Future<List> getSearch() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String email = JwtDecoder.decode(token!)['email'];
    var response = await http.post(Uri.parse(GETSEARCH),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'userEmail': email,
        }));
    var data = jsonDecode(response.body);
    //print(data);
    return data;
  }

  void goWithRes(String resName) async {
    var response = await http.post(Uri.parse(RESTAURANT2),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'resName': resName}));
    var data = jsonDecode(response.body);
    //print(data);
    Get.toNamed(RouteHelper.restaurant, arguments: {'restaurant': data[0]});
  }

  @override
  void dispose() {
    search.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: black.withOpacity(0.2)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: white),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    onChanged: (va) {
                      searchRestaurant();
                      searchFood();
                      if (search.text.isNotEmpty) {
                        setState(() {
                          empty = true;
                        });
                      } else {
                        setState(() {
                          empty = false;
                        });
                      }
                    },
                    style: appstyle(black, 14, FontWeight.normal),
                    cursorColor: Theme.of(context).colorScheme.tertiary,
                    controller: search,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: appstyle(
                            Theme.of(context).colorScheme.tertiary,
                            14,
                            FontWeight.normal),
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        focusColor: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ),
              !empty
                  ? Column(
                      children: [
                        const HeightSpacer(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "PAST SEARCHES",
                              style: appstyle(
                                  Theme.of(context).colorScheme.secondary,
                                  16,
                                  FontWeight.w500),
                            ),
                            Text(
                              "Clear",
                              style: appstyle(
                                  Theme.of(context).colorScheme.secondary,
                                  14,
                                  FontWeight.normal),
                            )
                          ],
                        ),
                        const HeightSpacer(height: 20),
                        FutureBuilder(
                            future: getSearch(),
                            builder: (context, AsyncSnapshot<List?> snapshot) {
                              return snapshot.hasData
                                  ? ListView.builder(
                                      itemCount: snapshot.hasData
                                          ? snapshot.data!.length > 3
                                              ? 3
                                              : snapshot.data!.length
                                          : 0,
                                      shrinkWrap: true,
                                      itemBuilder: ((context, index) {
                                        Future<Uint8List>
                                            downloadImage() async {
                                          var response1 = await http.post(
                                              Uri.parse(RESTAURANT2),
                                              headers: {
                                                "Content-Type":
                                                    "application/json"
                                              },
                                              body: jsonEncode({
                                                'resName': snapshot.data![index]
                                                    ['resName']
                                              }));
                                          var data = jsonDecode(response1.body);
                                          var data1 = await http.post(
                                            Uri.parse(DOWNLOADIMAGE),
                                            headers: {
                                              "Content-Type": "application/json"
                                            },
                                            body: jsonEncode({
                                              'ownerEmail': data[0]
                                                  ['ownerEmail'],
                                              'resName': snapshot.data![index]
                                                  ['resName']
                                            }),
                                          );

                                          var response = jsonDecode(data1.body);
                                          //print(response[0]['image']['data']['data']);
                                          List<dynamic> yo = response[0]
                                              ['image']['data']['data'];
                                          List<int> bufferInt =
                                              yo.map((e) => e as int).toList();

                                          Uint8List imageData =
                                              Uint8List.fromList(bufferInt);
                                          return imageData;
                                        }

                                        Future<Uint8List>
                                            downloadImage1() async {
                                          var response1 = await http.post(
                                              Uri.parse(RESTAURANT2),
                                              headers: {
                                                "Content-Type":
                                                    "application/json"
                                              },
                                              body: jsonEncode({
                                                'resName': snapshot.data![index]
                                                    ['resName']
                                              }));
                                          var data = jsonDecode(response1.body);
                                          var response2 = await http.post(
                                              Uri.parse(FOOD2),
                                              headers: {
                                                "Content-Type":
                                                    "application/json"
                                              },
                                              body: jsonEncode({
                                                'resName': snapshot.data![index]
                                                    ['resName'],
                                                'name': snapshot.data![index]
                                                    ['foodName']
                                              }));
                                          var data3 =
                                              jsonDecode(response1.body);
                                          var data1 = await http.post(
                                            Uri.parse(DOWNLOADFOODIMAGE),
                                            headers: {
                                              "Content-Type": "application/json"
                                            },
                                            body: jsonEncode({
                                              'ownerEmail': data[0]
                                                  ['ownerEmail'],
                                              'resName': snapshot.data![index]
                                                  ['resName'],
                                              'foodName': snapshot.data![index]
                                                  ['foodName']
                                            }),
                                          );

                                          var response = jsonDecode(data1.body);
                                          //print(response[0]['image']['data']['data']);
                                          List<dynamic> yo = response[0]
                                              ['image']['data']['data'];
                                          List<int> bufferInt =
                                              yo.map((e) => e as int).toList();

                                          Uint8List imageData =
                                              Uint8List.fromList(bufferInt);
                                          return imageData;
                                        }

                                        return GestureDetector(
                                          onTap: () async {
                                            snapshot.data![index]["foodName"] ==
                                                    ""
                                                ? goWithRes(snapshot
                                                    .data![index]['resName'])
                                                : goWithRes(snapshot
                                                    .data![index]['resName']);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: snapshot.data![index]
                                                              ["foodName"] ==
                                                          ""
                                                      ? FutureBuilder(
                                                          future:
                                                              downloadImage(),
                                                          builder: ((context,
                                                              AsyncSnapshot<
                                                                      Uint8List?>
                                                                  snapshot1) {
                                                            return snapshot1
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .done
                                                                ? CachedMemoryImage(
                                                                    uniqueKey: snapshot
                                                                            .data![index]
                                                                        [
                                                                        'resName'],
                                                                    bytes:
                                                                        snapshot1
                                                                            .data,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  )
                                                                : CachedNetworkImage(
                                                                    imageUrl:
                                                                        'https://cdn-icons-png.flaticon.com/512/147/147144.png?w=360',
                                                                    width: double
                                                                        .infinity,
                                                                    height: 190,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  );
                                                          }))
                                                      : FutureBuilder(
                                                          future:
                                                              downloadImage1(),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      Uint8List?>
                                                                  snapshot1) {
                                                            return snapshot1
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .done
                                                                ? CachedMemoryImage(
                                                                    uniqueKey: snapshot
                                                                            .data![index]
                                                                        [
                                                                        'foodName'],
                                                                    bytes:
                                                                        snapshot1
                                                                            .data,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  )
                                                                : CachedNetworkImage(
                                                                    imageUrl:
                                                                        'https://cdn-icons-png.flaticon.com/512/147/147144.png?w=360',
                                                                    width: double
                                                                        .infinity,
                                                                    height: 190,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  );
                                                          }),
                                                ),
                                                const WidthSpacer(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]
                                                                  [
                                                                  "foodName"] ==
                                                              ""
                                                          ? snapshot
                                                                  .data![index]
                                                              ['resName']
                                                          : snapshot
                                                                  .data![index]
                                                              ["foodName"],
                                                      style: appstyle(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                          20,
                                                          FontWeight.w500),
                                                    ),
                                                    Text(
                                                      snapshot.data![index][
                                                                  "foodName"] ==
                                                              ""
                                                          ? "Restaurant"
                                                          : "Dish",
                                                      style: appstyle(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                          16,
                                                          FontWeight.normal),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }))
                                  : const SizedBox.shrink();
                            }),
                      ],
                    )
                  : Column(
                      children: [
                        const HeightSpacer(height: 20),
                        SizedBox(
                          child: FutureBuilder(
                              future: searchFood(),
                              builder:
                                  (context, AsyncSnapshot<List?> snapshot) {
                                return snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      )
                                    : SizedBox(
                                        height: snapshot.data!.length * 250,
                                        child: ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            shrinkWrap: true,
                                            itemBuilder: ((context, index) {
                                              //print(snapshot.data);
                                              Future<Uint8List>
                                                  downloadImage1() async {
                                                var response1 = await http.post(
                                                    Uri.parse(RESTAURANT2),
                                                    headers: {
                                                      "Content-Type":
                                                          "application/json"
                                                    },
                                                    body: jsonEncode({
                                                      'resName':
                                                          snapshot.data![index]
                                                              ['resName']
                                                    }));
                                                var data =
                                                    jsonDecode(response1.body);

                                                var response2 = await http.post(
                                                    Uri.parse(FOOD2),
                                                    headers: {
                                                      "Content-Type":
                                                          "application/json"
                                                    },
                                                    body: jsonEncode({
                                                      'resName':
                                                          snapshot.data![index]
                                                              ['resName'],
                                                      'name':
                                                          snapshot.data![index]
                                                              ['foodName']
                                                    }));
                                                var data3 =
                                                    jsonDecode(response1.body);
                                                var data1 = await http.post(
                                                  Uri.parse(DOWNLOADFOODIMAGE),
                                                  headers: {
                                                    "Content-Type":
                                                        "application/json"
                                                  },
                                                  body: jsonEncode({
                                                    'ownerEmail': data[0]
                                                        ['ownerEmail'],
                                                    'resName':
                                                        snapshot.data![index]
                                                            ['resName'],
                                                    'foodName': snapshot
                                                        .data![index]['name']
                                                  }),
                                                );

                                                var response =
                                                    jsonDecode(data1.body);
                                                //print(response[0]['image']['data']['data']);
                                                List<dynamic> yo = response[0]
                                                    ['image']['data']['data'];
                                                List<int> bufferInt = yo
                                                    .map((e) => e as int)
                                                    .toList();

                                                Uint8List imageData =
                                                    Uint8List.fromList(
                                                        bufferInt);
                                                return imageData;
                                              }

                                              return GestureDetector(
                                                onTap: () async {
                                                  SharedPreferences
                                                      preferences =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  var token = preferences
                                                      .getString('token');
                                                  String email =
                                                      JwtDecoder.decode(
                                                          token!)['email'];
                                                  postSearch(
                                                    email,
                                                    snapshot.data![index]
                                                        ["resName"],
                                                    snapshot.data![index]
                                                        ["name"],
                                                  );
                                                  var response =
                                                      await http.post(
                                                          Uri.parse(
                                                              RESTAURANT2),
                                                          headers: {
                                                            "Content-Type":
                                                                "application/json"
                                                          },
                                                          body: jsonEncode({
                                                            'resName':
                                                                snapshot.data![
                                                                        index]
                                                                    ['resName']
                                                          }));
                                                  var data =
                                                      jsonDecode(response.body);
                                                  //print(data);
                                                  Get.toNamed(
                                                      RouteHelper.restaurant,
                                                      arguments: {
                                                        'restaurant': data[0]
                                                      });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 50,
                                                        width: 50,
                                                        child: FutureBuilder(
                                                            future:
                                                                downloadImage1(),
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
                                                                          snapshot.data![index]
                                                                              [
                                                                              'name'],
                                                                      bytes: snapshot1
                                                                          .data,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    )
                                                                  : CachedNetworkImage(
                                                                      imageUrl:
                                                                          'https://cdn-icons-png.flaticon.com/512/147/147144.png?w=360',
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          190,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    );
                                                            }),
                                                      ),
                                                      const WidthSpacer(
                                                          width: 10),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            snapshot.data![
                                                                index]["name"],
                                                            style: appstyle(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                                20,
                                                                FontWeight
                                                                    .w500),
                                                          ),
                                                          Text(
                                                            "Food",
                                                            style: appstyle(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                                16,
                                                                FontWeight
                                                                    .normal),
                                                          ),
                                                          Text(
                                                            "${snapshot.data![index]["resName"]}",
                                                            style: appstyle(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                                12,
                                                                FontWeight
                                                                    .bold),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })),
                                      );
                              }),
                        ),
                        SizedBox(
                          child: FutureBuilder(
                              future: searchRestaurant(),
                              builder:
                                  (context, AsyncSnapshot<List?> snapshot) {
                                return snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      )
                                    : SizedBox(
                                        height: snapshot.data!.length * 200,
                                        child: ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            shrinkWrap: true,
                                            itemBuilder: ((context, index) {
                                              Future<Uint8List>
                                                  downloadImage() async {
                                                var response1 = await http.post(
                                                    Uri.parse(RESTAURANT2),
                                                    headers: {
                                                      "Content-Type":
                                                          "application/json"
                                                    },
                                                    body: jsonEncode({
                                                      'resName':
                                                          snapshot.data![index]
                                                              ['resName']
                                                    }));
                                                var data =
                                                    jsonDecode(response1.body);
                                                var data1 = await http.post(
                                                  Uri.parse(DOWNLOADIMAGE),
                                                  headers: {
                                                    "Content-Type":
                                                        "application/json"
                                                  },
                                                  body: jsonEncode({
                                                    'ownerEmail': data[0]
                                                        ['ownerEmail'],
                                                    'resName': snapshot
                                                        .data![index]['resName']
                                                  }),
                                                );

                                                var response =
                                                    jsonDecode(data1.body);
                                                //print(response[0]['image']['data']['data']);
                                                List<dynamic> yo = response[0]
                                                    ['image']['data']['data'];
                                                List<int> bufferInt = yo
                                                    .map((e) => e as int)
                                                    .toList();

                                                Uint8List imageData =
                                                    Uint8List.fromList(
                                                        bufferInt);
                                                return imageData;
                                              }

                                              return GestureDetector(
                                                onTap: () async {
                                                  SharedPreferences
                                                      preferences =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  var token = preferences
                                                      .getString('token');
                                                  String email =
                                                      JwtDecoder.decode(
                                                          token!)['email'];
                                                  postSearch(
                                                    email,
                                                    snapshot.data![index]
                                                        ["resName"],
                                                    "",
                                                  );
                                                  Get.toNamed(
                                                      RouteHelper.restaurant,
                                                      arguments: {
                                                        'restaurant': snapshot
                                                            .data![index]
                                                      });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 50,
                                                        width: 50,
                                                        child: FutureBuilder(
                                                            future:
                                                                downloadImage(),
                                                            builder: ((context,
                                                                AsyncSnapshot<
                                                                        Uint8List?>
                                                                    snapshot1) {
                                                              return snapshot1
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .done
                                                                  ? CachedMemoryImage(
                                                                      uniqueKey:
                                                                          snapshot.data![index]
                                                                              [
                                                                              'resName'],
                                                                      bytes: snapshot1
                                                                          .data,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    )
                                                                  : CachedNetworkImage(
                                                                      imageUrl:
                                                                          'https://cdn-icons-png.flaticon.com/512/147/147144.png?w=360',
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          190,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    );
                                                            })),
                                                      ),
                                                      const WidthSpacer(
                                                          width: 10),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            snapshot.data![
                                                                    index]
                                                                ["resName"],
                                                            style: appstyle(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                                20,
                                                                FontWeight
                                                                    .w500),
                                                          ),
                                                          Text(
                                                            "Restaurant",
                                                            style: appstyle(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                                16,
                                                                FontWeight
                                                                    .normal),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })),
                                      );
                              }),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
