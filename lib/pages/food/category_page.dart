import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';

import 'package:delivery_man/constants/height_spacer.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/route.dart';

class CategoryPage extends StatefulWidget {
  final String foodType;
  const CategoryPage({super.key, required this.foodType});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    downloadFood();
  }

  Future<List> downloadFood() async {
    List response = [];
    var data = await http.post(Uri.parse(RESTAURANT1),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"foodType": widget.foodType}));

    if (data.statusCode == 200) {
      if (mounted) {
        response = json.decode(data.body);
      }
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          widget.foodType,
          style: appstyle(
              Theme.of(context).colorScheme.secondary, 18, FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "ALL RESTAURANTS DELIVERING",
                  style: appstyle(Theme.of(context).colorScheme.secondary, 16,
                      FontWeight.w900),
                ),
              ),
              const HeightSpacer(height: 5),
              Center(
                child: Text(
                  widget.foodType.toUpperCase(),
                  style: appstyle(Theme.of(context).colorScheme.secondary, 16,
                      FontWeight.w900),
                ),
              ),
              const HeightSpacer(height: 20),
              FutureBuilder(
                  future: downloadFood(),
                  builder: (context, AsyncSnapshot<List?> snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator()
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Future<double> getdistinTime() async {
                                List response = [];
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                var token = preferences.getString('token');
                                String email =
                                    JwtDecoder.decode(token!)['email'];
                                var data = await http.post(
                                    Uri.parse(GETCURRENT),
                                    headers: {
                                      "Content-Type": "application/json"
                                    },
                                    body: jsonEncode({"useremail": email}));
                                response = jsonDecode(data.body);

                                var distance = GeolocatorPlatform.instance
                                    .distanceBetween(
                                        response[0]["lat"],
                                        response[0]["long"],
                                        snapshot.data![index]["lat"],
                                        snapshot.data![index]["long"]);
                                distance = distance / 1000;
                                distance =
                                    double.parse(distance.toStringAsFixed(2));
                                return distance;
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
                                onTap: () async {
                                  Get.toNamed(RouteHelper.restaurant,
                                      arguments: {
                                        'restaurant': snapshot.data![index]
                                      });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 30, left: 20, right: 20),
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color.fromARGB(49, 0, 0, 0),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        height: 250,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10))),
                                        child: FutureBuilder(
                                            future: downloadImage(),
                                            builder: (context,
                                                AsyncSnapshot<Uint8List?>
                                                    snapshot1) {
                                              return snapshot1
                                                          .connectionState ==
                                                      ConnectionState.done
                                                  ? Container(
                                                      width: double.maxFinite,
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10))),
                                                      child: CachedMemoryImage(
                                                        uniqueKey: snapshot
                                                                .data![index]
                                                            ['resName'],
                                                        bytes: snapshot1.data,
                                                        fit: BoxFit.fill,
                                                        placeholder:
                                                            Shimmer.fromColors(
                                                                baseColor: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                                highlightColor: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                                child:
                                                                    Container(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
                                                                  width: double
                                                                      .maxFinite,
                                                                  height: 200,
                                                                )),
                                                      ),
                                                    )
                                                  : Shimmer.fromColors(
                                                      baseColor:
                                                          Theme.of(context)
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
                                                        width: double.maxFinite,
                                                        height: 200,
                                                      ));
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 12, 16, 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  snapshot.data![index]
                                                      ['resName'],
                                                  style: appstyle(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      20,
                                                      FontWeight.w500)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 0, 16, 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  snapshot.data![index]
                                                      ['location'],
                                                  style: appstyle(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      14,
                                                      FontWeight.normal)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        decoration: const BoxDecoration(),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(16, 0, 24, 12),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.star_rounded,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    size: 24,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            4, 0, 0, 0),
                                                    child: Text(
                                                        snapshot.data![index]
                                                                ['rating']
                                                            .toString(),
                                                        style: appstyle(
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                            14,
                                                            FontWeight.normal)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            8, 0, 0, 0),
                                                    child: Text('Rating',
                                                        style: appstyle(
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                            14,
                                                            FontWeight.normal)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(16, 0, 24, 12),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.location_pin,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    size: 24,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            4, 0, 0, 0),
                                                    child: FutureBuilder(
                                                        future: getdistinTime(),
                                                        builder: (context,
                                                            AsyncSnapshot<
                                                                    double?>
                                                                snapshot1) {
                                                          return Text(
                                                              snapshot1.data
                                                                  .toString(),
                                                              style: appstyle(
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary,
                                                                  14,
                                                                  FontWeight
                                                                      .normal));
                                                        }),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            8, 0, 0, 0),
                                                    child: Text('Km',
                                                        style: appstyle(
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                            14,
                                                            FontWeight.normal)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
