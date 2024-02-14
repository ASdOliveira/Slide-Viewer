import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';

const double imageHeight = 230;

abstract class ImageDetailWidgetBase extends StatelessWidget {
  const ImageDetailWidgetBase({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> imagesToShow = SortImagesToBeShown();

    if (imagesToShow.length == 0) {
      //if there arn't any image, nothing should be shown
      return SizedBox.shrink();
    } else if (imagesToShow.length == 1) {
      //if there're only one image. The carroussel isn't needed
      return Container(
          child: GestureDetector(
              onTap: () {
                FullScreenCurrentImage(context, imagesToShow.first);
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
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 2.0, enlargeCenterPage: true, height: 230),
          items: imageSliders,
        ),
      );
    }
  }

  List<String> SortImagesToBeShown();

  void FullScreenCurrentImage(BuildContext context, String imageToShow);

  List<Widget> formatImageSliders(BuildContext context, List<String> imgList) {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: GestureDetector(
                onTap: () => FullScreenCurrentImage(
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
