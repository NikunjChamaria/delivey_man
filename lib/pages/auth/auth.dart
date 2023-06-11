import 'dart:convert';

import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:delivery_man/widgets/custom_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateSoloAltWidget extends StatefulWidget {
  const AuthenticateSoloAltWidget({Key? key}) : super(key: key);

  @override
  _AuthenticateSoloAltWidgetState createState() =>
      _AuthenticateSoloAltWidgetState();
}

class _AuthenticateSoloAltWidgetState extends State<AuthenticateSoloAltWidget> {
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
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    initSharedPref();

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

    _unfocusNode.dispose();
    super.dispose();
  }

  void initSharedPref() async {
    preferences = await SharedPreferences.getInstance();
  }

  void registerUser() async {
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
        Get.toNamed(RouteHelper.homw, arguments: {'token': myToken});
      }
    } else {}
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
        print(preferences.getString('token').toString());
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
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
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
                    Container(
                      width: 240,
                      height: 60,
                      child: const Center(
                          child: Text(
                        "Mr. Delivery Man",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: white),
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
                      const Align(
                        alignment: Alignment(0, 0),
                        child: TabBar(
                          indicatorColor: white,
                          isScrollable: true,
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: white),
                          unselectedLabelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: white),
                          labelColor: white,
                          unselectedLabelColor: Color(0xFF4E5657),
                          labelPadding:
                              EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                          tabs: [
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
                                                color: lightGrey,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                            hintText: 'Enter your email...',
                                            hintStyle: TextStyle(
                                                color: lightGrey,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.white,
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
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(20, 24, 20, 24),
                                          ),
                                          style: TextStyle(
                                              color: lightGrey,
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
                                              color: lightGrey,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          hintText: 'Enter your password...',
                                          hintStyle: TextStyle(
                                              color: lightGrey,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.white,
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
                                          fillColor: Colors.white,
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
                                              color: white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        style: TextStyle(
                                            color: lightGrey,
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
                                            color: white,
                                            color2: black,
                                            textSize: 22)),
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 20, 0, 0),
                                      child: CustomButton(
                                          text: 'Forgot Password',
                                          width: 170,
                                          height: 40,
                                          color: Color(0xFF616155),
                                          color2: white,
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
                                              decoration: const BoxDecoration(
                                                color: black,
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
                                              child: const FaIcon(
                                                FontAwesomeIcons.google,
                                                color: white,
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
                                                color: black,
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
                                              child: const FaIcon(
                                                FontAwesomeIcons.apple,
                                                color: white,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: black,
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
                                            child: const FaIcon(
                                              FontAwesomeIcons.facebookF,
                                              color: white,
                                              size: 24,
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: black,
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
                                            child: const Icon(
                                              Icons.phone_sharp,
                                              color: white,
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
                            GetBuilder(builder: (_authcontroller) {
                              return SingleChildScrollView(
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
                                              borderSide: const BorderSide(
                                                color: Colors.white,
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
                                            fillColor: Colors.white,
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 12, 20, 0),
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
                                              borderSide: const BorderSide(
                                                color: Colors.white,
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
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(20, 24, 20, 24),
                                            suffixIcon: InkWell(
                                              onTap: () => setState(
                                                () => passwordCreateVisibility =
                                                    passwordCreateVisibility,
                                              ),
                                              focusNode: FocusNode(
                                                  skipTraversal: true),
                                              child: Icon(
                                                passwordCreateVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: lightGrey,
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 12, 20, 0),
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
                                              borderSide: const BorderSide(
                                                color: Colors.white,
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
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(20, 24, 20, 24),
                                            suffixIcon: InkWell(
                                              onTap: () => setState(
                                                () => nameCreateVisibility =
                                                    nameCreateVisibility,
                                              ),
                                              focusNode: FocusNode(
                                                  skipTraversal: true),
                                              child: Icon(
                                                nameCreateVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: lightGrey,
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 12, 20, 0),
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
                                              borderSide: const BorderSide(
                                                color: Colors.white,
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
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(20, 24, 20, 24),
                                            suffixIcon: InkWell(
                                              onTap: () => setState(
                                                () => phoneCreateVisibility =
                                                    phoneCreateVisibility,
                                              ),
                                              focusNode: FocusNode(
                                                  skipTraversal: true),
                                              child: Icon(
                                                phoneCreateVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: lightGrey,
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 24, 0, 0),
                                        child: CustomButton(
                                            onTap: () {
                                              registerUser();
                                              //Get.toNamed(RouteHelper.homw);
                                            },
                                            text: "Create Account",
                                            width: 230,
                                            height: 50,
                                            color: white,
                                            color2: black,
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 24, 0, 0),
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(24, 8, 24, 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
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
                                                child: const FaIcon(
                                                  FontAwesomeIcons.google,
                                                  color: white,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
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
                                                child: const FaIcon(
                                                  FontAwesomeIcons.apple,
                                                  color: white,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
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
                                                child: const FaIcon(
                                                  FontAwesomeIcons.facebookF,
                                                  color: white,
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
                                              child: const Icon(
                                                Icons.phone_sharp,
                                                color: white,
                                                size: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
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
