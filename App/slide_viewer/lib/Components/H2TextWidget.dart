import 'package:flutter/material.dart';

import '../Style/CustomTextStyle.dart';

class H2TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  const H2TextWidget({super.key, required this.text, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      softWrap: true,
      style: H2TextStyle(fontSize),
    );
  }
}
