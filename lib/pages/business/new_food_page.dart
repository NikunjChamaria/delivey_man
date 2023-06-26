import 'dart:convert';

import 'package:delivery_man/constants/server.dart';
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

import '../../constants/color.dart';

class NewFoodPage extends StatefulWidget {
  final String resName;
  const NewFoodPage({super.key, required this.resName});

  @override
  State<NewFoodPage> createState() => _NewFoodPageState();
}

class _NewFoodPageState extends State<NewFoodPage> {
  TextEditingController foodName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController rating = TextEditingController();
  TextEditingController comments = TextEditingController();
  File? image;

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
    var url = Uri.parse(UPLOADFOODIMAGE);

    var request = http.MultipartRequest('POST', url);

    var multiport = await http.MultipartFile.fromPath('imagefood', image!.path);

    request.files.add(multiport);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    String email = JwtDecoder.decode(token!)['email'];

    request.fields['ownerEmail'] = email;
    request.fields['foodName'] = foodName.text;

    request.fields['resName'] = widget.resName;

    // ignore: unused_local_variable
    var respone = request.send();
  }

  Uint8List? imageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Align(
          alignment: const AlignmentDirectional(-1, 0),
          child: Text(
            'Create Product',
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
                "Upload Product photo :",
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
                        border: Border.all(color: lightGrey),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: white),
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
                "Product Name :",
                style: appstyle(Theme.of(context).colorScheme.secondary, 20,
                    FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 2, 10, 2),
                    child: TextFormField(
                      controller: foodName,
                      onChanged: (va) {
                        setState(() {});
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
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
                        suffixIcon: foodName.text.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  foodName.clear();
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
                "Price :",
                style: appstyle(Theme.of(context).colorScheme.secondary, 20,
                    FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 2, 10, 2),
                    child: TextFormField(
                      controller: price,
                      obscureText: false,
                      onChanged: (va) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: const TextStyle(
                          color: Color(0xFF060000),
                        ),
                        hintText: 'Price',
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
                        suffixIcon: price.text.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  price.clear();
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
                    color: white,
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
                "Comments :",
                style: appstyle(Theme.of(context).colorScheme.secondary, 20,
                    FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
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
              Center(
                child: GestureDetector(
                  onTap: () async {
                    var req = {
                      'resName': widget.resName,
                      'rating': num.parse(rating.text),
                      'name': foodName.text,
                      'comments': num.parse(comments.text),
                      'price': num.parse(price.text),
                    };
                    // ignore: unused_local_variable
                    var data = await http.post(Uri.parse(FOOD),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode(req));
                    //print(req);

                    uploadImage();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: lightGrey),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: white),
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
            ],
          ),
        ),
      ),
    );
  }
}
