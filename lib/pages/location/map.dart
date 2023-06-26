import 'dart:convert';

import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final String address;
  final int route;
  const MapScreen(
      {super.key,
      required this.initialLatitude,
      required this.initialLongitude,
      required this.address,
      required this.route});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  TextEditingController? search;
  LatLng? _markerPosition;
  void _centerMapOnCurrentLocation() {
    _mapController.move(
        LatLng(widget.initialLatitude, widget.initialLongitude), 16.0);
  }

  String? address;
  @override
  void initState() {
    _markerPosition = LatLng(widget.initialLatitude, widget.initialLongitude);
    address = widget.address;
    search = TextEditingController(text: widget.address);
    super.initState();
  }

  void _handleMapPositionChanged(MapPosition position, bool hasGesture) async {
    setState(() {
      _markerPosition = position.center!;
    });

    //search.text = address!;
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
        String fullAddress = '$address, $city, $state, $country, $postalCode';
        return fullAddress;
      }
    } catch (e) {
      //print('Error: $e');
    }
    return '';
  }

  Future<Coordinates?> getCoordinatesFromAddress(String address) async {
    final addresses = await Geocoder.local.findAddressesFromQuery(address);
    if (addresses.isNotEmpty) {
      final firstAddress = addresses.first;
      return firstAddress.coordinates;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Choose Delivery Location',
            style: appstyle(
                Theme.of(context).colorScheme.secondary, 16, FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
              center: LatLng(widget.initialLatitude, widget.initialLongitude),
              zoom: 16.0,
              onPositionChanged: _handleMapPositionChanged),
          nonRotatedChildren: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      decoration: const BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          style: appstyle(black, 16, FontWeight.normal),
                          controller: search,
                          onSubmitted: (val) async {
                            Coordinates? coordinates;
                            coordinates = await getCoordinatesFromAddress(val);
                            setState(() {
                              _markerPosition = LatLng(coordinates!.latitude!,
                                  coordinates.longitude!);
                              _mapController.move(
                                  LatLng(coordinates.latitude!,
                                      coordinates.longitude!),
                                  15.0);
                              search!.text = val;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: black,
                            ),
                          ),
                        ),
                      )),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100, right: 10),
                    child: GestureDetector(
                      onTap: () async {
                        _centerMapOnCurrentLocation();
                      },
                      child: Container(
                        decoration: ShapeDecoration(
                            shape: const CircleBorder(),
                            color: Theme.of(context).colorScheme.background),
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.my_location,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async {
                      String address = await getAddressFromCoordinates(
                          _markerPosition!.latitude,
                          _markerPosition!.longitude);
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      var token = preferences.getString('token');
                      String email = JwtDecoder.decode(token!)['email'];
                      var req = {
                        "useremail": email,
                        "address": address,
                        "lat": _markerPosition!.latitude,
                        "long": _markerPosition!.longitude
                      };

                      // ignore: unused_local_variable
                      var data = await http.post(Uri.parse(ADDRESS),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(req));
                      if (widget.route == 1) {
                        Get.back();
                      }
                      if (widget.route == 0) {
                        Get.toNamed(RouteHelper.homw,
                            arguments: {"token": token});
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 30, left: 30, right: 30),
                      color: Theme.of(context).colorScheme.background,
                      width: double.maxFinite,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Save Address",
                          style: appstyle(
                              Theme.of(context).colorScheme.secondary,
                              18,
                              FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                    point: _markerPosition!,
                    builder: (context) => const Icon(
                          Icons.location_on,
                          size: 34,
                          color: black,
                        ))
              ],
            )
          ],
        ),
      ),
    ]);
  }
}
