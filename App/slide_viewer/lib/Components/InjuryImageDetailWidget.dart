import 'package:flutter/material.dart';

class InjuryImageDetailWidget extends StatelessWidget {
  final String imageName;
  const InjuryImageDetailWidget({
    super.key,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    String image;
    if (imageName.isEmpty) {
      image = 'assets/images/default_image.jpg';
    } else {
      image = 'assets/laminas/' + imageName;
    }

    return Image.asset(
      image,
      height: 230,
      width: double.infinity,
      fit: BoxFit.fill,
    );
  }
}
