// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/widgets/custom_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class AuthenticateSoloAltWidget extends StatefulWidget {
  const AuthenticateSoloAltWidget({Key? key}) : super(key: key);

  @override
  _AuthenticateSoloAltWidgetState createState() =>
      _AuthenticateSoloAltWidgetState();
}

class _AuthenticateSoloAltWidgetState extends State<AuthenticateSoloAltWidget>
    with TickerProviderStateMixin {
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailAddressCreateController = TextEditingController();
  TextEditingController passwordCreateController = TextEditingController();
  TextEditingController nameCreateController = TextEditingController();
  TextEditingController phoneCreateController = TextEditingController();

  late bool passwordCreateVisibility;
  late bool passwordVisibility;
  late bool nameCreateVisibility;
  late bool phoneCreateVisibility;
  late SharedPreferences preferences;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  TabController? tabController;
  @override
  void initState() {
    initSharedPref();
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    passwordVisibility = false;
    passwordCreateVisibility = false;
    nameCreateVisibility = false;
    phoneCreateVisibility = false;
  }

  @override
  void dispose() {
    emailAddressController.dispose();
    passwordController.dispose();
    emailAddressCreateController.dispose();
    passwordCreateController.dispose();
    nameCreateController.dispose();
    phoneCreateController.dispose();

    super.dispose();
  }

  void initSharedPref() async {
    preferences = await SharedPreferences.getInstance();
  }

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
        String fullAddress = '$address, $city, $state, $country, $postalCode';
        return fullAddress;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
    return '';
  }

  void registerUser() async {
    setState(() {
      isLoading = true;
      tabController!.index = 1;
    });
    if (emailAddressCreateController.text.isNotEmpty &&
        passwordCreateController.text.isNotEmpty &&
        nameCreateController.text.isNotEmpty &&
        phoneCreateController.text.isNotEmpty) {
      var reqBody = {
        "email": emailAddressCreateController.text,
        "password": passwordCreateController.text,
        "name": nameCreateController.text,
        "phone": phoneCreateController.text
      };

      var response = await http.post(Uri.parse(REGISTER),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        preferences.setString('token', myToken);
        Position position = await _determinePosition();
        String address = await getAddressFromCoordinates(
            position.latitude, position.longitude);
        Get.toNamed(RouteHelper.map, arguments: {
          "lat": position.latitude,
          "long": position.longitude,
          "address": address,
          "route": 0
        });
      }
    } else {}
    setState(() {
      isLoading = false;
    });
  }

  void loginUser() async {
    if (emailAddressController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailAddressController.text,
        "password": passwordController.text,
      };
      var response = await http.post(Uri.parse(LOGIN),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        preferences.setString('token', myToken);
        //print(preferences.getString('token').toString());
        Get.toNamed(RouteHelper.homw, arguments: {'token': myToken});
      } else {
        if (kDebugMode) {
          print("OOps");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF212425),
        body: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 60),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 240,
                      height: 60,
                      child: Center(
                          child: Text(
                        "Mr. Delivery Man",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Theme.of(context).colorScheme.secondary),
                      )),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      Align(
                        alignment: const Alignment(0, 0),
                        child: TabBar(
                          controller: tabController,
                          indicatorColor:
                              Theme.of(context).colorScheme.secondary,
                          isScrollable: true,
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.secondary),
                          unselectedLabelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.secondary),
                          labelColor: Theme.of(context).colorScheme.secondary,
                          unselectedLabelColor: const Color(0xFF4E5657),
                          labelPadding: const EdgeInsetsDirectional.fromSTEB(
                              24, 0, 24, 0),
                          tabs: const [
                            Tab(
                              text: 'Sign In',
                            ),
                            Tab(
                              text: 'Sign Up',
                              iconMargin:
                                  EdgeInsetsDirectional.fromSTEB(50, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24, 24, 24, 24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 20, 20, 0),
                                        child: TextFormField(
                                          controller: emailAddressController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Email Address',
                                            labelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                            hintText: 'Enter your email...',
                                            hintStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            contentPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(20, 24, 20, 24),
                                          ),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          maxLines: null,
                                        )),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20, 12, 20, 0),
                                      child: TextFormField(
                                        controller: passwordController,
                                        obscureText: passwordVisibility,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          hintText: 'Enter your password...',
                                          hintStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(20, 24, 20, 24),
                                          suffixIcon: InkWell(
                                            onTap: () => setState(
                                              () => passwordVisibility =
                                                  passwordVisibility,
                                            ),
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            child: Icon(
                                              passwordVisibility
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 24, 0, 0),
                                        child: CustomButton(
                                            onTap: () {
                                              loginUser();
                                            },
                                            text: "Sign in",
                                            width: 230,
                                            height: 50,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            color2: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            textSize: 22)),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 20, 0, 0),
                                      child: CustomButton(
                                          text: 'Forgot Password',
                                          width: 170,
                                          height: 40,
                                          color: const Color(0xFF616155),
                                          color2: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          textSize: 14),
                                    ),
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 20, 12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 12, 0, 0),
                                            child: Text(
                                              'Or use a social account to login',
                                              style: TextStyle(
                                                color: Color(0x98FFFFFF),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              24, 8, 24, 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {},
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 5,
                                                    color: Color(0x3314181B),
                                                    offset: Offset(0, 2),
                                                  )
                                                ],
                                                shape: BoxShape.circle,
                                              ),
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, 0),
                                              child: FaIcon(
                                                FontAwesomeIcons.google,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {},
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 5,
                                                    color: Color(0x3314181B),
                                                    offset: Offset(0, 2),
                                                  )
                                                ],
                                                shape: BoxShape.circle,
                                              ),
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, 0),
                                              child: FaIcon(
                                                FontAwesomeIcons.apple,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 5,
                                                  color: Color(0x3314181B),
                                                  offset: Offset(0, 2),
                                                )
                                              ],
                                              shape: BoxShape.circle,
                                            ),
                                            alignment:
                                                const AlignmentDirectional(
                                                    0, 0),
                                            child: FaIcon(
                                              FontAwesomeIcons.facebookF,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: 24,
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 5,
                                                  color: Color(0x3314181B),
                                                  offset: Offset(0, 2),
                                                )
                                              ],
                                              shape: BoxShape.circle,
                                            ),
                                            alignment:
                                                const AlignmentDirectional(
                                                    0, 0),
                                            child: Icon(
                                              Icons.phone_sharp,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24, 24, 24, 24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20, 20, 20, 0),
                                      child: TextFormField(
                                        controller:
                                            emailAddressCreateController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Email Address',
                                          labelStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                          hintText: 'Enter your email...',
                                          hintStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(20, 24, 20, 24),
                                        ),
                                        style: const TextStyle(
                                          color: Color(0xFF0F1113),
                                        ),
                                        maxLines: null,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20, 12, 20, 0),
                                      child: TextFormField(
                                        controller: passwordCreateController,
                                        obscureText: passwordCreateVisibility,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                          hintText: 'Enter your password...',
                                          hintStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(20, 24, 20, 24),
                                          suffixIcon: InkWell(
                                            onTap: () => setState(
                                              () => passwordCreateVisibility =
                                                  passwordCreateVisibility,
                                            ),
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            child: Icon(
                                              passwordCreateVisibility
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Color(0xFF0F1113),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20, 12, 20, 0),
                                      child: TextFormField(
                                        controller: nameCreateController,
                                        obscureText: nameCreateVisibility,
                                        decoration: InputDecoration(
                                          labelText: 'Name',
                                          labelStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                          hintText: 'Enter your name...',
                                          hintStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(20, 24, 20, 24),
                                          suffixIcon: InkWell(
                                            onTap: () => setState(
                                              () => nameCreateVisibility =
                                                  nameCreateVisibility,
                                            ),
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            child: Icon(
                                              nameCreateVisibility
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Color(0xFF0F1113),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20, 12, 20, 0),
                                      child: TextFormField(
                                        controller: phoneCreateController,
                                        obscureText: phoneCreateVisibility,
                                        decoration: InputDecoration(
                                          labelText: 'Phone',
                                          labelStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                          hintText: 'Enter your phone...',
                                          hintStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(20, 24, 20, 24),
                                          suffixIcon: InkWell(
                                            onTap: () => setState(
                                              () => phoneCreateVisibility =
                                                  phoneCreateVisibility,
                                            ),
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            child: Icon(
                                              phoneCreateVisibility
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Color(0xFF0F1113),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 24, 0, 0),
                                      child: isLoading
                                          ? Shimmer.fromColors(
                                              baseColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              highlightColor: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                                height: 50,
                                                width: 230,
                                              ))
                                          : CustomButton(
                                              onTap: () {
                                                registerUser();

                                                //Get.toNamed(RouteHelper.homw);
                                              },
                                              text: "Create Account",
                                              width: 230,
                                              height: 50,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              color2: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              textSize: 20),
                                    ),
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 20, 12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 24, 0, 0),
                                            child: Text(
                                              'Sign up using a social account',
                                              style: TextStyle(
                                                color: Color(0x98FFFFFF),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              24, 8, 24, 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {},
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF616155),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 5,
                                                    color: Color(0x3314181B),
                                                    offset: Offset(0, 2),
                                                  )
                                                ],
                                                shape: BoxShape.circle,
                                              ),
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, 0),
                                              child: FaIcon(
                                                FontAwesomeIcons.google,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {},
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF616155),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 5,
                                                    color: Color(0x3314181B),
                                                    offset: Offset(0, 2),
                                                  )
                                                ],
                                                shape: BoxShape.circle,
                                              ),
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, 0),
                                              child: FaIcon(
                                                FontAwesomeIcons.apple,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {},
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF616155),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 5,
                                                    color: Color(0x3314181B),
                                                    offset: Offset(0, 2),
                                                  )
                                                ],
                                                shape: BoxShape.circle,
                                              ),
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, 0),
                                              child: FaIcon(
                                                FontAwesomeIcons.facebookF,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF616155),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 5,
                                                  color: Color(0x3314181B),
                                                  offset: Offset(0, 2),
                                                )
                                              ],
                                              shape: BoxShape.circle,
                                            ),
                                            alignment:
                                                const AlignmentDirectional(
                                                    0, 0),
                                            child: Icon(
                                              Icons.phone_sharp,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
