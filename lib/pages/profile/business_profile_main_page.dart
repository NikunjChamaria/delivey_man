import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/height_spacer.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/server.dart';
import 'package:http/http.dart' as http;

class BusinessProfileMainPage extends StatefulWidget {
  const BusinessProfileMainPage({super.key});

  @override
  State<BusinessProfileMainPage> createState() =>
      _BusinessProfileMainPageState();
}

class _BusinessProfileMainPageState extends State<BusinessProfileMainPage> {
  Future<List> getBusiness() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');

    String email = JwtDecoder.decode(token!)['email'];
    var data = await http.post(Uri.parse(RESTAURANT3),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"ownerEmail": email}));
    List response = jsonDecode(data.body);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Your Businesses",
          style: appstyle(
              Theme.of(context).colorScheme.secondary, 16, FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const HeightSpacer(height: 20),
            FutureBuilder(
                future: getBusiness(),
                builder: (context, AsyncSnapshot<List?> snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Shimmer.fromColors(
                                  baseColor:
                                      Theme.of(context).colorScheme.primary,
                                  highlightColor:
                                      Theme.of(context).colorScheme.secondary,
                                  child: Container(
                                    width: double.maxFinite,
                                    height: 300,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                            );
                          })
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Future<List> check() async {
                              List respone = [];
                              var data = await http.post(Uri.parse(PREPARING),
                                  headers: {"Content-Type": "application/json"},
                                  body: jsonEncode({
                                    'restaurant': snapshot.data![index]
                                        ['resName']
                                  }));
                              respone = jsonDecode(data.body);
                              return respone;
                            }

                            Future<Uint8List> downloadImage() async {
                              var data = await http.post(
                                Uri.parse(DOWNLOADIMAGE),
                                headers: {"Content-Type": "application/json"},
                                body: jsonEncode({
                                  'ownerEmail': snapshot.data![index]
                                      ['ownerEmail'],
                                  'resName': snapshot.data![index]['resName']
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

                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(RouteHelper.businessPage,
                                    arguments: {
                                      'restaurant': snapshot.data![index]
                                    });
                              },
                              child: Padding(
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
                                  child: Column(
                                    children: [
                                      FutureBuilder(
                                          future: downloadImage(),
                                          builder: (context,
                                              AsyncSnapshot<Uint8List?>
                                                  snapshot1) {
                                            return snapshot1.connectionState ==
                                                    ConnectionState.done
                                                ? SizedBox(
                                                    height: 250,
                                                    width: double.maxFinite,
                                                    child: CachedMemoryImage(
                                                      uniqueKey:
                                                          snapshot.data![index]
                                                              ['resName'],
                                                      bytes: snapshot1.data,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : Shimmer.fromColors(
                                                    baseColor: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    highlightColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    child: Container(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      height: 250,
                                                      width: double.maxFinite,
                                                    ));
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data![index]
                                                        ['resName'],
                                                    style: appstyle(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                        16,
                                                        FontWeight.w600),
                                                  ),
                                                  Text(
                                                    snapshot.data![index]
                                                        ['location'],
                                                    style: appstyle(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                        14,
                                                        FontWeight.w300),
                                                  )
                                                ],
                                              ),
                                              FutureBuilder(
                                                  future: check(),
                                                  builder: (context,
                                                      AsyncSnapshot<List?>
                                                          snapshot) {
                                                    return snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? const CircularProgressIndicator()
                                                        : Text(
                                                            snapshot.data!
                                                                    .isEmpty
                                                                ? "No new Orders"
                                                                : "${snapshot.data!.length} new order(s)",
                                                            style: appstyle(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                                20,
                                                                FontWeight
                                                                    .w300),
                                                          );
                                                  })
                                            ],
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
            const HeightSpacer(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.businessProfileSigIn,
                      arguments: {"address": "", "lat": 0.0, "long": 0.0});
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: lightGrey.withOpacity(0.4)),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).colorScheme.background),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Add a new business",
                      style: appstyle(Theme.of(context).colorScheme.secondary,
                          18, FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const HeightSpacer(height: 20),
          ],
        ),
      ),
    );
  }
}
