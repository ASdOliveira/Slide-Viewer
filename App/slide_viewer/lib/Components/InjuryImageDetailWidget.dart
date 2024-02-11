import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';

import '../Services/InternetCheckerService.dart';
import '../Services/Models/InjuryDetailModel.dart';
import '../Style/CustomTextStyle.dart';
import '../WebSlideView.dart';

const double imageHeight = 230;

class InjuryImageDetailWidget extends StatelessWidget {
  final InjuryDetailModel injuryModel;

  const InjuryImageDetailWidget({
    super.key,
    required this.injuryModel,
  });

  @override
  Widget build(BuildContext context) {
    List<String> imagesToShow = [];

    if (injuryModel.imageName.isNotEmpty) {
      imagesToShow.add('assets/laminas/' + injuryModel.imageName);
    }
    if (injuryModel.extraImages!.length > 0) {
      for (String img in injuryModel.extraImages!) {
        imagesToShow.add('assets/laminas/ImagensExtra/' + img);
      }
    }

    if (imagesToShow.length == 0) {
      //if there arn't any image, nothing should be shown
      return SizedBox.shrink();
    } else if (imagesToShow.length == 1) {
      //if there're only one image. The carroussel isn't needed
      return Container(
          child: GestureDetector(
              onTap: () {
                NavigateAccordingImageType(context, imagesToShow.first);
              },
              child: Hero(
                  tag: imagesToShow.first,
                  child: Image.asset(
                    imagesToShow.first,
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ))));
    } else {
      List<Widget> imageSliders = formatImageSliders(context, imagesToShow);
      return Container(
        //todo: add gestureDetector.
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 2.0, enlargeCenterPage: true, height: 230),
          items: imageSliders,
        ),
      );
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
      ShowImageAccordingInternetConnection(context, injuryModel.url);
    }
  }

  List<Widget> formatImageSliders(BuildContext context, List<String> imgList) {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: GestureDetector(
                onTap: () => NavigateAccordingImageType(
                    context, imgList.elementAt(imgList.indexOf(item))),
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.asset(
                            item,
                            fit: BoxFit.cover,
                            width: 1000.0,
                            height: imageHeight,
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ))
        .toList();
    return imageSliders;
  }

  void ShowImageAccordingInternetConnection(BuildContext context, String url) {
    InternetCheckerService().hasInternetConnection().then((hasConnection) {
      if (hasConnection) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebSlideView(selectedUrl: url)));
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

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: PhotoView(
              imageProvider: AssetImage(imageUrl),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2.0,
              initialScale: PhotoViewComputedScale.contained,
            ),
          ),
        ),
      ),
    );
  }
}
