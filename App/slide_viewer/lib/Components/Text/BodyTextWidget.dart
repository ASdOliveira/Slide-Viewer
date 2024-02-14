import 'package:flutter/material.dart';

import '../../Styles/CustomTextStyle.dart';

class BodyTextWidget extends StatelessWidget {
  final String text;
  const BodyTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: bodyTextStyle(),
    );
  }
}
