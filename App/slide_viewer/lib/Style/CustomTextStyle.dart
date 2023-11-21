import 'package:flutter/material.dart';

TextStyle H1TextStyle() {
  return const TextStyle(
      fontSize: 22,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      color: Color(0xFF672855));
}

TextStyle H1WhiteTextStyle() {
  return const TextStyle(
      fontSize: 24,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      color: Color(0xFFFFFFFF));
}

TextStyle H2TextStyle(double fontSize) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      color: const Color(0xFF9C3C81));
}

TextStyle subTitle3TextStyle() {
  return const TextStyle(
      fontSize: 15,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFFFF));
}

TextStyle bodyTextStyle() {
  return const TextStyle(
      fontSize: 16,
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w400,
      color: Color(0xFF404952));
}

TextStyle searchButtonTextStyle() {
  return const TextStyle(
      fontSize: 16,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      color: Color(0xFFFFFFFF));
}
