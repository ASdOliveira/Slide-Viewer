import 'package:flutter/material.dart';

import 'ImageDetailWidgetBase.dart';
import '../../Pages/Others/WebSlideViewPage.dart';
import '../../Services/InternetCheckerService.dart';
import '../../Services/Models/PatologyDetailModel.dart';
import '../../Styles/CustomTextStyle.dart';

class PatologyImageDetailWidget extends ImageDetailWidgetBase {
  final PatologyDetailModel injuryModel;

  const PatologyImageDetailWidget({
    super.key,
    required this.injuryModel,
  });

  @override
  List<String> SortImagesToBeShown() {
    List<String> imagesToShow = [];

    if (injuryModel.imageName.isNotEmpty) {
      imagesToShow.add('assets/laminas/' + injuryModel.imageName);
    }
    if (injuryModel.extraImages!.length > 0) {
      for (String img in injuryModel.extraImages!) {
        imagesToShow.add('assets/laminas/ImagensExtra/' + img);
      }
    }

    return imagesToShow;
  }

  @override
  void FullScreenCurrentImage(BuildContext context, String imageToShow) {
    if (imageToShow.contains("ImagensExtra")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImage(imageUrl: imageToShow),
        ),
      );
    } else {
      _ShowImageAccordingInternetConnection(context, injuryModel.url);
    }
  }

  void NavigateAccordingImageType(BuildContext context, String imageToShow) {
    if (imageToShow.contains("ImagensExtra")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImage(imageUrl: imageToShow),
        ),
      );
    } else {
      _ShowImageAccordingInternetConnection(context, injuryModel.url);
    }
  }

  void _ShowImageAccordingInternetConnection(BuildContext context, String url) {
    InternetCheckerService().hasInternetConnection().then((hasConnection) {
      if (hasConnection) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebSlideViewPage(selectedUrl: url)));
      } else {
        var snackBar = SnackBar(
          content: Text(
            "Para ver em detalhes, é necessário conexão com a internet",
            style: subTitle3TextStyle(),
          ),
          duration: const Duration(seconds: 4),
          showCloseIcon: true,
          backgroundColor: const Color.fromARGB(255, 128, 77, 113),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
}
