// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/constants/width_spacer.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

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

  bool isLoading = false;
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
        //print('Address: $fullAddress');
        return fullAddress;
      }
    } catch (e) {
      rethrow;
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
      rethrow;
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Address Book"),
      ),
      body: LiquidPullToRefresh(
        color: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.background,
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
                  style: appstyle(Theme.of(context).colorScheme.secondary, 16,
                      FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    Position position = await _determinePosition();
                    String address = await getAddressFromCoordinates(
                        position.latitude, position.longitude);
                    Get.toNamed(RouteHelper.map, arguments: {
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "route": 1
                    });
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: double.maxFinite,
                    child: isLoading
                        ? Shimmer.fromColors(
                            baseColor: Theme.of(context).colorScheme.background,
                            loop: 10,
                            highlightColor:
                                Theme.of(context).colorScheme.secondary,
                            child: Container(
                              height: 30,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ))
                        : Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const WidthSpacer(width: 10),
                              Text(
                                "Add address",
                                style: appstyle(
                                    Theme.of(context).colorScheme.secondary,
                                    14,
                                    FontWeight.bold),
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 10),
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
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                14,
                                                FontWeight.bold),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            //print("tapped");
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
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .background,
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
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .background
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
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
