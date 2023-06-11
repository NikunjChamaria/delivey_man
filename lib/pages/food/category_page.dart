import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/height_spacer.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants/route.dart';

class CategoryPage extends StatefulWidget {
  final String foodType;
  const CategoryPage({super.key, required this.foodType});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List? response;

  @override
  void initState() {
    super.initState();
    downloadFood();
  }

  void downloadFood() async {
    var data = await http.post(Uri.parse(RESTAURANT1),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"foodType": widget.foodType}));

    if (data.statusCode == 200) {
      if (mounted) {
        setState(() {
          response = json.decode(data.body);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      appBar: AppBar(
        backgroundColor: backGround,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          widget.foodType,
          style: appstyle(white, 18, FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "ALL RESTAURANTS DELIVERING",
                  style: appstyle(white, 16, FontWeight.w900),
                ),
              ),
              HeightSpacer(height: 5),
              Center(
                child: Text(
                  widget.foodType.toUpperCase(),
                  style: appstyle(white, 16, FontWeight.w900),
                ),
              ),
              HeightSpacer(height: 20),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: response == null ? 0 : response!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.restaurant,
                          arguments: {'restaurant': response![index]});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 30, left: 20, right: 20),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x32000000),
                            offset: Offset(0, 2),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: response![index]['imageUrl'],
                              width: double.infinity,
                              height: 190,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 12, 16, 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(response![index]['resName'],
                                      style: appstyle(const Color(0xFF101213),
                                          20, FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 0, 16, 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(response![index]['location'],
                                      style: appstyle(const Color(0xFF57636C),
                                          14, FontWeight.normal)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 40,
                            decoration: const BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 24, 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        color: Color(0xFF212425),
                                        size: 24,
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 0, 0, 0),
                                        child: Text(
                                            response![index]['rating']
                                                .toString(),
                                            style: appstyle(
                                                const Color(0xFF101213),
                                                14,
                                                FontWeight.normal)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8, 0, 0, 0),
                                        child: Text('Rating',
                                            style: appstyle(
                                                const Color(0xFF57636C),
                                                14,
                                                FontWeight.normal)),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 24, 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.location_pin,
                                        color: Color(0xFF212425),
                                        size: 24,
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 0, 0, 0),
                                        child: Text(
                                            response![index]['dist'].toString(),
                                            style: appstyle(
                                                const Color(0xFF101213),
                                                14,
                                                FontWeight.normal)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8, 0, 0, 0),
                                        child: Text('Km',
                                            style: appstyle(
                                                const Color(0xFF57636C),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
