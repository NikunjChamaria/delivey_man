import 'dart:convert';

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

  void postSearch(String userEmail, String resName, String foodName,
      String imageUrl) async {
    // ignore: unused_local_variable
    var response = await http.post(Uri.parse(POSTSEARCH),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'userEmail': userEmail,
          'resName': resName,
          'foodName': foodName,
          'imageUrl': imageUrl
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
    print(data);
    return data;
  }

  Future<String> getImageUrl(String name, bool isRes) async {
    String imageUrl = "";
    var response = isRes
        ? await http.post(Uri.parse(RESTAURANT2),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              'resName': name,
            }))
        : await http.post(Uri.parse(FOOD1),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              'resName': name,
            }));
    var data = jsonDecode(response.body);
    imageUrl = data['imageUrl'];
    return imageUrl;
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
  Widget build(BuildContext context) {
    final unfocusNode = FocusNode();

    @override
    void dispose() {
      search.dispose();
      unfocusNode.dispose();
      super.dispose();
    }

    return Scaffold(
      backgroundColor: backGround,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: white),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
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
                    cursorColor: black,
                    controller: search,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        fillColor: white,
                        focusColor: white),
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
                              style: appstyle(white, 16, FontWeight.w500),
                            ),
                            Text(
                              "Clear",
                              style: appstyle(white, 14, FontWeight.normal),
                            )
                          ],
                        ),
                        HeightSpacer(height: 20),
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
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  child: Image.network(
                                                      snapshot.data![index]
                                                          ["imageUrl"]),
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
                                                      style: appstyle(white, 20,
                                                          FontWeight.w500),
                                                    ),
                                                    Text(
                                                      snapshot.data![index][
                                                                  "foodName"] ==
                                                              ""
                                                          ? "Restaurant"
                                                          : "Dish",
                                                      style: appstyle(white, 16,
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
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: white,
                                        ),
                                      )
                                    : SizedBox(
                                        height: snapshot.data!.length * 250,
                                        child: ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            shrinkWrap: true,
                                            itemBuilder: ((context, index) {
                                              print(snapshot.data);
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
                                                      snapshot.data![index]
                                                          ["imageUrl"]);
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
                                                      Container(
                                                        height: 50,
                                                        width: 50,
                                                        child: CachedNetworkImage(
                                                            imageUrl: snapshot
                                                                        .data![
                                                                    index]
                                                                ["imageUrl"]),
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
                                                                white,
                                                                20,
                                                                FontWeight
                                                                    .w500),
                                                          ),
                                                          Text(
                                                            "Food",
                                                            style: appstyle(
                                                                white,
                                                                16,
                                                                FontWeight
                                                                    .normal),
                                                          ),
                                                          Text(
                                                            "${snapshot.data![index]["resName"]}",
                                                            style: appstyle(
                                                                white,
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
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: white,
                                        ),
                                      )
                                    : SizedBox(
                                        height: snapshot.data!.length * 200,
                                        child: ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            shrinkWrap: true,
                                            itemBuilder: ((context, index) {
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
                                                      snapshot.data![index]
                                                          ["imageUrl"]);
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
                                                      Container(
                                                        height: 50,
                                                        width: 50,
                                                        child: CachedNetworkImage(
                                                            imageUrl: snapshot
                                                                        .data![
                                                                    index]
                                                                ["imageUrl"]),
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
                                                                white,
                                                                20,
                                                                FontWeight
                                                                    .w500),
                                                          ),
                                                          Text(
                                                            "Restaurant",
                                                            style: appstyle(
                                                                white,
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
