import 'package:flutter/material.dart';

TextStyle H1TextStyle() {
  return const TextStyle(
      fontSize: 22,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      color: Color(0xFF672855));
}

TextStyle H2TextStyle(double fontSize) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      color: const Color(0xFF9C3C81));
}

TextStyle bodyTextStyle() {
  return const TextStyle(
      fontSize: 16,
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w400,
      color: Color(0xFF404952));
}
