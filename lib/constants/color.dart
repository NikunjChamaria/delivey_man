import 'package:flutter/material.dart';

const backGround = Color(0xFF212425);
const white = Colors.white;
const black = Colors.black;
const lightGrey = Color(0xFF3A3A3A);
const transparent = Colors.transparent;

const backgorundwhite = Color(0xFFf7f6f4);
const blue = Color.fromARGB(255, 225, 233, 239);
var lighterGrey = Colors.grey[500];

ThemeData darktheme = ThemeData(
    appBarTheme: const AppBarTheme(backgroundColor: backGround),
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        background: backGround,
        primary: lightGrey,
        secondary: white,
        surface: black,
        tertiary: black));

ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(backgroundColor: backGround),
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        background: backgorundwhite,
        primary: blue,
        secondary: black,
        surface: backgorundwhite,
        tertiary: lightGrey));
