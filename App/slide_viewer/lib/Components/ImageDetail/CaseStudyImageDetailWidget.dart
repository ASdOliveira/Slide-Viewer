import 'package:flutter/material.dart';

import '../../Services/Models/CaseStudyModel.dart';
import 'ImageDetailWidgetBase.dart';

class CaseStudyImageDetailWidget extends ImageDetailWidgetBase {
  final CaseStudyModel caseStudyModel;

  const CaseStudyImageDetailWidget({
    super.key,
    required this.caseStudyModel,
  });

  @override
  List<String> SortImagesToBeShown() {
    List<String> imagesToShow = [];

    if (caseStudyModel.images!.length > 0) {
      for (String img in caseStudyModel.images!) {
        imagesToShow.add('assets/caseStudies/' + img);
      }
    }

    return imagesToShow;
  }

  @override
  void FullScreenCurrentImage(BuildContext context, String imageToShow) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: imageToShow),
      ),
    );
  }
}
