import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final void Function()? onTap;
  final Color color;
  final Color color2;
  final double textSize;

  const CustomButton(
      {super.key,
      required this.text,
      required this.width,
      required this.height,
      this.onTap,
      required this.color,
      required this.color2,
      required this.textSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.transparent,
              width: 1,
            )),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: color2, fontWeight: FontWeight.bold, fontSize: textSize),
          ),
        ),
      ),
    );
  }
}


//140,51