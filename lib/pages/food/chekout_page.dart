import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  Widget build(BuildContext context) {
    // bool isCheckOut = true;
    return Scaffold(
        backgroundColor: backGround,
        appBar: AppBar(
          backgroundColor: backGround,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: white,
              size: 16,
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            /*setState(() {
              isCheckOut = false;
            });*/
          },
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
            child: Container(
              width: double.infinity,
              height: 90,
              decoration: const BoxDecoration(
                color: white,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBFA14),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0xFF212425),
                        offset: Offset(1, 1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF212425),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('\$330',
                                    style:
                                        appstyle(black, 18, FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                        Text(' Proceed To Checkout',
                            style: appstyle(black, 14, FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
