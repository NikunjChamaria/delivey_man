import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String message,
    {bool isError = true, String title = "Error"}) {
  Get.snackbar(title, message,
      titleText: Text(
        title,
        style: appstyle(white, 18, FontWeight.w600),
      ),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent);
}
