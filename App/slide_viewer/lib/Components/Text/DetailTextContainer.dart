import 'package:flutter/material.dart';

import 'BodyTextWidget.dart';
import 'H2TextWidget.dart';

class DetailTextContainer extends StatelessWidget {
  final String title;
  final String body;
  const DetailTextContainer(
      {super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Container(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            H2TextWidget(
              text: title,
              fontSize: 18,
            ),
            const SizedBox(height: 10),
            BodyTextWidget(text: body),
          ]),
        ));
  }
}
