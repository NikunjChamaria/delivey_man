import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/height_spacer.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/constants/textstyle.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FoodHomePage extends StatefulWidget {
  const FoodHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FoodHomePageState createState() => _FoodHomePageState();
}

class _FoodHomePageState extends State<FoodHomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    downloadData();
    downloadData1();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List?> downloadData() async {
    List? response;
    var data = await http.get(
      Uri.parse(RESTAURANT),
      headers: {"Content-Type": "application/json"},
    );

    response = json.decode(data.body);

    return response;
  }

  Future<List?> downloadData1() async {
    List? response1;
    var data = await http.get(
      Uri.parse(CATEGORY),
      headers: {"Content-Type": "application/json"},
    );

    response1 = json.decode(data.body);

    return response1;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: const Color(0xFF212425),
            body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child:
                    Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        Text('Meena Pearl - 700055',
                            style: appstyle(white, 14, FontWeight.w500)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Browse Categories',
                          textAlign: TextAlign.start,
                          style: appstyle(white, 24, FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  const HeightSpacer(height: 20),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                    child: SizedBox(
                      height: 100,
                      child: FutureBuilder(
                          future: downloadData1(),
                          builder: (context, AsyncSnapshot<List?> snapshot) {
                            return snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: white,
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(RouteHelper.category,
                                              arguments: {
                                                'foodType': snapshot
                                                    .data![index]['foodType']
                                              });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12, 0, 0, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 64,
                                                height: 64,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xB0969696),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                      snapshot.data![index]
                                                          ['imageUrl'],
                                                    ),
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const HeightSpacer(height: 5),
                                              Text(
                                                  snapshot.data![index]
                                                      ['foodType'],
                                                  textAlign: TextAlign.center,
                                                  style: appstyle(white, 12,
                                                      FontWeight.normal)),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Special Offers',
                            textAlign: TextAlign.start,
                            style: appstyle(white, 24, FontWeight.normal)),
                      ],
                    ),
                  ),
                  const HeightSpacer(height: 20),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 16),
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  6, 0, 0, 0),
                              child: Container(
                                width: 360,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: black,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: index == 0
                                        ? Image.network(
                                            'https://www.wordstream.com/wp-content/uploads/2021/07/banner-ads-examples-aws.jpg',
                                          ).image
                                        : index == 1
                                            ? Image.network(
                                                'https://static.semrush.com/blog/uploads/media/c2/52/c2521160ece538cfdbfb218788caf9ea/mDWwN6GNJt_lE7-pGth6IXsdxvqVmPeaGHw-F_dHXiKN8p3FGgIVicwvbdShvLirF5slOvKUkxpfMkaVdne2a6do6vHWdLZSfy1i-lGmfZL9-FyS162K6P-QGbZbk1vKp9YjNSil%3Ds0.png',
                                              ).image
                                            : Image.network(
                                                'https://blog.hubspot.com/hubfs/How%20to%20Explain%20Banner%20Ads%20to%20Anyone-5.png',
                                              ).image,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Businesses Near You',
                            textAlign: TextAlign.start,
                            style: appstyle(white, 24, FontWeight.normal)),
                      ],
                    ),
                  ),
                  const HeightSpacer(height: 20),
                  FutureBuilder(
                      future: downloadData(),
                      builder: (context, AsyncSnapshot<List?> snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: white,
                                ),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  Future<Uint8List> downloadImage() async {
                                    var data = await http.post(
                                      Uri.parse(DOWNLOADIMAGE),
                                      headers: {
                                        "Content-Type": "application/json"
                                      },
                                      body: jsonEncode({
                                        'ownerEmail': snapshot.data![index]
                                            ['ownerEmail'],
                                        'resName': snapshot.data![index]
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

                                  return snapshot.data == null
                                      ? const SizedBox.shrink()
                                      : GestureDetector(
                                          onTap: () {
                                            Get.toNamed(RouteHelper.restaurant,
                                                arguments: {
                                                  'restaurant':
                                                      snapshot.data![index]
                                                });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 30,
                                                left: 20,
                                                right: 20),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                              color: lightGrey,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 4,
                                                  color: Color(0x32000000),
                                                  offset: Offset(0, 2),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0),
                                                    bottomRight:
                                                        Radius.circular(0),
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8),
                                                  ),
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
                                                                uniqueKey: snapshot
                                                                            .data![
                                                                        index]
                                                                    ['resName'],
                                                                bytes: snapshot1
                                                                    .data,
                                                                fit:
                                                                    BoxFit.fill,
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          16, 12, 16, 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                            snapshot.data![
                                                                    index]
                                                                ['resName'],
                                                            style: appstyle(
                                                                white,
                                                                20,
                                                                FontWeight
                                                                    .w500)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          16, 0, 16, 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                            snapshot.data![
                                                                    index]
                                                                ['location'],
                                                            style: appstyle(
                                                                white,
                                                                14,
                                                                FontWeight
                                                                    .normal)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  decoration:
                                                      const BoxDecoration(),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                16, 0, 24, 12),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .star_rounded,
                                                              color: white,
                                                              size: 24,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                      4,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Text(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                          [
                                                                          'rating']
                                                                      .toString(),
                                                                  style: appstyle(
                                                                      white,
                                                                      14,
                                                                      FontWeight
                                                                          .normal)),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                      8,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Text(
                                                                  'Rating',
                                                                  style: appstyle(
                                                                      white,
                                                                      14,
                                                                      FontWeight
                                                                          .normal)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                16, 0, 24, 12),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .location_pin,
                                                              color: white,
                                                              size: 24,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                      4,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Text(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                          [
                                                                          'dist']
                                                                      .toString(),
                                                                  style: appstyle(
                                                                      white,
                                                                      14,
                                                                      FontWeight
                                                                          .normal)),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                      8,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Text('Km',
                                                                  style: appstyle(
                                                                      white,
                                                                      14,
                                                                      FontWeight
                                                                          .normal)),
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
                                });
                      }),
                ]))));
  }
}
