// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/constants/width_spacer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        String address = placemark.street ?? '';
        String city = placemark.locality ?? '';
        String state = placemark.administrativeArea ?? '';
        String country = placemark.country ?? '';
        String postalCode = placemark.postalCode ?? '';

        // Concatenate the address components as needed
        String fullAddress = '$address, $city, $state, $country, $postalCode';

        // Use the fullAddress value as needed
        print('Address: $fullAddress');
        return fullAddress;
      }
    } catch (e) {
      print('Error: $e');
    }
    return '';
  }

  Future<List<double>?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;

        double latitude = location.latitude;
        double longitude = location.longitude;

        // Return the latitude and longitude values
        return [latitude, longitude];
      }
    } catch (e) {
      print('Error: $e');
    }

    // Return null if coordinates couldn't be retrieved
    return null;
  }

  Future<List>? _getData;
  @override
  void initState() {
    super.initState();
    _getData = getAddress();
  }

  Future<List> getAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String email = JwtDecoder.decode(token!)['email'];
    List response;
    var data = await http.post(Uri.parse(GETADDRESS),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"useremail": email}));
    response = jsonDecode(data.body);
    response = response.reversed.toList();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      appBar: AppBar(
        backgroundColor: backGround,
        title: const Text("Address Book"),
      ),
      body: LiquidPullToRefresh(
        color: white,
        backgroundColor: backGround,
        onRefresh: () async {
          setState(() {
            _getData = getAddress();
          });
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My addresses",
                  style: appstyle(white, 16, FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () async {
                    if (kDebugMode) {
                      print("yo");
                    }
                    Position position = await _determinePosition();
                    String address = await getAddressFromCoordinates(
                        position.latitude, position.longitude);
                    Get.toNamed(RouteHelper.map, arguments: {
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          color: white,
                        ),
                        const WidthSpacer(width: 10),
                        Text(
                          "Add address",
                          style: appstyle(white, 14, FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                    future: _getData,
                    builder: (context, AsyncSnapshot<List?> snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  padding: EdgeInsets.zero,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: white, width: 0.2),
                                          bottom: BorderSide(
                                              color: white, width: 0.2))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20, top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 270,
                                          child: Text(
                                            snapshot.data![index]['address'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            softWrap: true,
                                            style: appstyle(
                                                white, 14, FontWeight.bold),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            print("tapped");
                                            SharedPreferences preferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            var token =
                                                preferences.getString('token');
                                            String email = JwtDecoder.decode(
                                                token!)['email'];
                                            var req = {
                                              "useremail": email,
                                              'address': snapshot.data![index]
                                                  ['address']
                                            };
                                            var data = await http.post(
                                                Uri.parse(SETCURRENT),
                                                headers: {
                                                  "Content-Type":
                                                      "application/json"
                                                },
                                                body: jsonEncode(req));
                                            setState(() {
                                              _getData = getAddress();
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: snapshot.data![index]
                                                        ['isCurrent']
                                                    ? white
                                                    : backGround,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Text(
                                                "Current",
                                                style: appstyle(
                                                    snapshot.data![index]
                                                            ['isCurrent']
                                                        ? backGround
                                                        : white,
                                                    14,
                                                    FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        )
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
      ),
    );
  }
}
