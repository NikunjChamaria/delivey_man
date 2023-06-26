import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_man/constants/height_spacer.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/constants/width_spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/item.dart';
import '../../constants/route.dart';
import '../../constants/server.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  Future<Map<Map, Map>> getData() async {
    Map<Map, Map> snapshot = {};

    List response = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String email = JwtDecoder.decode(token!)['email'];
    var req = {'userEmail': email};
    var data = await http.post(Uri.parse(FAVORDER),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(req));

    response = json.decode(data.body);

    for (var n in response) {
      var req = {'resName': n['restaurant']};
      var data = await http.post(Uri.parse(RESTAURANT2),
          headers: {"Content-Type": "application/json"}, body: jsonEncode(req));

      Map map = json.decode(data.body)[0];
      snapshot[n] = map;
    }

    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeightSpacer(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Favourite Orders",
                style: appstyle(Theme.of(context).colorScheme.secondary, 24,
                    FontWeight.normal),
              ),
            ),
            const HeightSpacer(height: 20),
            FutureBuilder(
                future: getData(),
                builder: (context, AsyncSnapshot<Map?> snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.isEmpty
                              ? 0
                              : snapshot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var keys = snapshot.data!.keys.toList();
                            Future<Uint8List> downloadImage() async {
                              var data = await http.post(
                                Uri.parse(DOWNLOADIMAGE),
                                headers: {"Content-Type": "application/json"},
                                body: jsonEncode({
                                  'ownerEmail': snapshot.data![keys[index]]
                                      ['ownerEmail'],
                                  'resName': snapshot.data![keys[index]]
                                      ['resName']
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

                            return Container(
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
                                  color: Theme.of(context).colorScheme.primary,
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      width: 1)),
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 30),
                              width: double.maxFinite,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: FutureBuilder(
                                              future: downloadImage(),
                                              builder: (context,
                                                  AsyncSnapshot<Uint8List?>
                                                      snapshot1) {
                                                return snapshot1
                                                            .connectionState ==
                                                        ConnectionState.done
                                                    ? Container(
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          child:
                                                              CachedMemoryImage(
                                                            uniqueKey: snapshot
                                                                        .data![
                                                                    keys[index]]
                                                                ['resName'],
                                                            bytes:
                                                                snapshot1.data,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
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
                                              keys[index]['restaurant'],
                                              style: appstyle(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  16,
                                                  FontWeight.bold),
                                            ),
                                            Text(
                                              snapshot.data![keys[index]]
                                                  ['location'],
                                              style: appstyle(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  12,
                                                  FontWeight.normal),
                                            )
                                          ],
                                        ),
                                        const WidthSpacer(width: 130),
                                        Text(
                                          "\$${keys[index]['amount']}",
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              20,
                                              FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const HeightSpacer(height: 10),
                                    Divider(
                                      thickness: 0.2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    const HeightSpacer(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "ITEMS",
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              14,
                                              FontWeight.w700),
                                        ),
                                        const HeightSpacer(height: 5),
                                        ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                keys[index]["items"].length,
                                            itemBuilder: (context, ind) {
                                              var key = keys[index]["items"]
                                                  .keys
                                                  .toList();
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Text(
                                                  '${keys[index]["items"][key[ind]]} X ${key[ind]}',
                                                  style: appstyle(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      12,
                                                      FontWeight.w200),
                                                ),
                                              );
                                            }),
                                        const HeightSpacer(height: 5),
                                        Text(
                                          "ORDERED ON",
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              14,
                                              FontWeight.w700),
                                        ),
                                        const HeightSpacer(height: 5),
                                        Text(
                                          keys[index]['time'],
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              12,
                                              FontWeight.w200),
                                        )
                                      ],
                                    ),
                                    const HeightSpacer(height: 10),
                                    Divider(
                                      thickness: 0.2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Delivered",
                                          style: appstyle(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              12,
                                              FontWeight.w200),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            List response = [];
                                            var data = await http.post(
                                                Uri.parse(FOOD1),
                                                headers: {
                                                  "Content-Type":
                                                      "application/json"
                                                },
                                                body: jsonEncode({
                                                  "resName": snapshot
                                                          .data![keys[index]]
                                                      ['resName']
                                                }));

                                            if (data.statusCode == 200) {
                                              if (mounted) {
                                                response =
                                                    json.decode(data.body);
                                              }
                                            }
                                            Map<String, dynamic> itemdy =
                                                keys[index]['items'];
                                            itemCount = itemdy
                                                .map<String, int>((key, value) {
                                              return MapEntry<String, int>(
                                                  key, value as int);
                                            });
                                            num totalAmount = 0;
                                            var key = keys[index]["items"]
                                                .keys
                                                .toList();
                                            for (int n = 0;
                                                n < keys[index]['price'].length;
                                                n++) {
                                              totalAmount = totalAmount +
                                                  (keys[index]['price'][n] *
                                                      keys[index]['items']
                                                          [key[n]]);
                                            }
                                            Get.toNamed(RouteHelper.cart,
                                                arguments: {
                                                  'restaurant': snapshot
                                                      .data![keys[index]],
                                                  'itemCount': itemCount,
                                                  'response': response,
                                                  'totalAmount': totalAmount
                                                });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Repeat Order",
                                                style: appstyle(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    16,
                                                    FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                }),
          ],
        ),
      ),
    );
  }
}
