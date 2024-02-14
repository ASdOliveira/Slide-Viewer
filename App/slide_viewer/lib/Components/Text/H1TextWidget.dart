import 'package:flutter/material.dart';

import '../../Styles/CustomTextStyle.dart';

class H1TextWidget extends StatelessWidget {
  final String text;
  const H1TextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: H1TextStyle(),
    );
  }
}
