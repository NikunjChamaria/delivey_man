// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/constants/server.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:delivery_man/constants/height_spacer.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessProfileCreate extends StatefulWidget {
  String address;
  double lat;
  double long;
  BusinessProfileCreate(
      {super.key,
      required this.address,
      required this.lat,
      required this.long});

  @override
  State<BusinessProfileCreate> createState() => _BusinessProfileCreateState();
}

class _BusinessProfileCreateState extends State<BusinessProfileCreate> {
  TextEditingController resName = TextEditingController();
  TextEditingController businessemail = TextEditingController();
  TextEditingController rating = TextEditingController();
  TextEditingController dist = TextEditingController();
  TextEditingController comments = TextEditingController();
  TextEditingController foodType = TextEditingController();
  TextEditingController loaction = TextEditingController();
  TextEditingController averagePrice = TextEditingController();
  File? image;
  List foodTypeList = [];

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

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final temporaryImage = File(image.path);
      setState(() {
        this.image = temporaryImage;
      });
    } on PlatformException {
      if (kDebugMode) {
        print('lol');
      }
    }
  }

  Future<void> uploadImage() async {
    var url = Uri.parse(UPLOADIMAGE);

    var request = http.MultipartRequest('POST', url);

    var multiport = await http.MultipartFile.fromPath('image', image!.path);

    request.files.add(multiport);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String email = JwtDecoder.decode(token!)['email'];

    request.fields['ownerEmail'] = email;

    request.fields['resName'] = resName.text;

    // ignore: unused_local_variable
    var respone = request.send();
  }

  Uint8List? imageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Align(
          alignment: const AlignmentDirectional(-1, 0),
          child: Text(
            'Create Business',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: 80,
                    height: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: image == null
                        ? Image.network(
                            'https://cdn-icons-png.flaticon.com/512/147/147144.png?w=360',
                          )
                        : Image.file(image!),
                  ),
                ),
              ),
              const HeightSpacer(height: 10),
              Text(
                "Upload Business loaction photo :",
                style: appstyle(Theme.of(context).colorScheme.secondary, 20,
                    FontWeight.w600),
              ),
              const HeightSpacer(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Theme.of(context).colorScheme.secondary),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Upload Picture",
                        style: appstyle(Theme.of(context).colorScheme.secondary,
                            14, FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              const HeightSpacer(height: 10),
              Text(
                "Location :",
                style: appstyle(Theme.of(context).colorScheme.secondary, 20,
                    FontWeight.w600),
              ),
              widget.address == ""
                  ? Container()
                  : Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 2, 10, 2),
                            child: SizedBox(
                              width: double.maxFinite,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    widget.address,
                                    style: appstyle(
                                        Theme.of(context).colorScheme.secondary,
                                        16,
                                        FontWeight.normal),
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 2, 10, 2),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Center(
                          child: GestureDetector(
                            onTap: () async {
                              Position position = await _determinePosition();

                              Get.toNamed(RouteHelper.businessmap, arguments: {
                                "lat": position.latitude,
                                "long": position.longitude,
                                "address": ""
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "Set location from map",
                                style: appstyle(
                                    Theme.of(context).colorScheme.secondary,
                                    16,
                                    FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
              ),
              Text(
                "Business Name :",
                style: appstyle(Theme.of(context).colorScheme.secondary, 20,
                    FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 2, 10, 2),
                    child: TextFormField(
                      controller: resName,
                      onChanged: (va) {
                        setState(() {});
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Business Name',
                        labelStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        hintText: 'Name',
                        hintStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFCFCFD),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF060000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: resName.text.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  resName.clear();
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: Color(0xFF060000),
                                  size: 14,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "Business Email :",
                style: appstyle(Theme.of(context).colorScheme.secondary, 20,
                    FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 2, 10, 2),
                    child: TextFormField(
                      controller: businessemail,
                      obscureText: false,
                      onChanged: (va) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Business Email',
                        labelStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        hintText: 'Business Email',
                        hintStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFCFCFD),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF060000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: businessemail.text.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  businessemail.clear();
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: Color(0xFF060000),
                                  size: 14,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "Rating :",
                style: appstyle(Theme.of(context).colorScheme.secondary, 20,
                    FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 2, 10, 2),
                    child: TextFormField(
                      controller: rating,
                      obscureText: false,
                      onChanged: (va) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Rating',
                        labelStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        hintText: 'Rating',
                        hintStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFCFCFD),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF060000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: rating.text.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  rating.clear();
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: Color(0xFF060000),
                                  size: 14,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "Location Name :",
                style: appstyle(Theme.of(context).colorScheme.secondary, 20,
                    FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 2, 10, 2),
                    child: TextFormField(
                      controller: loaction,
                      obscureText: false,
                      onChanged: (va) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Average Price',
                        labelStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        hintText: 'Average Price',
                        hintStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFCFCFD),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF060000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: loaction.text.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  loaction.clear();
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: Color(0xFF060000),
                                  size: 14,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "Comments :",
                style: appstyle(Theme.of(context).colorScheme.secondary, 20,
                    FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 2, 10, 2),
                    child: TextFormField(
                      controller: comments,
                      obscureText: false,
                      onChanged: (va) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Coments',
                        labelStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        hintText: 'Comments',
                        hintStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFCFCFD),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF060000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: comments.text.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  comments.clear();
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: Color(0xFF060000),
                                  size: 14,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "Food Type :",
                style: appstyle(Theme.of(context).colorScheme.secondary, 20,
                    FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 2, 10, 2),
                    child: TextFormField(
                      controller: foodType,
                      onChanged: (va) {
                        setState(() {});
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Food Type',
                        labelStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        hintText: 'FoodType',
                        hintStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFCFCFD),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF060000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: foodType.text.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  foodType.clear();
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: Color(0xFF060000),
                                  size: 14,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              const HeightSpacer(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () {
                    foodTypeList.add(foodType.text);
                    //print(foodTypeList);
                    foodType.clear();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Theme.of(context).colorScheme.secondary),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "ADD",
                        style: appstyle(Theme.of(context).colorScheme.secondary,
                            18, FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              const HeightSpacer(height: 10),
              Text(
                "Average Price :",
                style: appstyle(Theme.of(context).colorScheme.secondary, 20,
                    FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 2, 10, 2),
                    child: TextFormField(
                      controller: averagePrice,
                      obscureText: false,
                      onChanged: (va) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Average Price',
                        labelStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        hintText: 'Average Price',
                        hintStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFCFCFD),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF060000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFEBFA14),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: averagePrice.text.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  averagePrice.clear();
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: Color(0xFF060000),
                                  size: 14,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    var token = preferences.getString('token');

                    String email = JwtDecoder.decode(token!)['email'];

                    var req = {
                      'resName': resName.text,
                      'rating': num.parse(rating.text),
                      'comments': num.parse(comments.text),
                      'averagePrice': num.parse(averagePrice.text),
                      'foodType': foodTypeList,
                      'location': loaction.text,
                      'ownerEmail': email,
                      'businessEmail': businessemail.text,
                      'address': widget.address,
                      "lat": widget.lat,
                      'long': widget.long
                    };
                    // ignore: unused_local_variable
                    var data = await http.post(Uri.parse(RESTAURANT),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode(req));
                    //print(req);

                    uploadImage();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Theme.of(context).colorScheme.secondary),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "ADD",
                        style: appstyle(Theme.of(context).colorScheme.secondary,
                            18, FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    print(widget.address);
                    print(widget.lat.toString());
                    print(widget.long.toString());
                  },
                  icon: const Icon(Icons.access_alarm)),
            ],
          ),
        ),
      ),
    );
  }
}
