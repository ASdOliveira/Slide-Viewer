import 'package:flutter/material.dart';
import 'package:slide_viewer/Services/InjuryDetailService.dart';
import 'package:slide_viewer/Services/Models/InjuryDetailModel.dart';
import 'Components/DrawerWidget.dart';
import 'Components/H1TextWidget.dart';
import 'Components/InjuryDetailTextContainer.dart';
import 'Components/SearchWidget.dart';
import 'WebSlideView.dart';
import 'Services/InternetCheckerService.dart';

class InjuryDetail extends StatefulWidget {
  final int Id;

  const InjuryDetail({super.key, required this.Id});

  @override
  InjuryDetailState createState() => InjuryDetailState();
}

class InjuryDetailState extends State<InjuryDetail> {
  late InjuryDetailModel injuryModel;

  InjuryDetailState();

  @override
  void initState() {
    super.initState();
    injuryModel = InjuryDetailService().getListFilteredById(widget.Id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF672855),
        title: const SearchWidget(),
      ),
      drawer: DrawerWidget(),
      backgroundColor: const Color(0xFFEAEFF3),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
              child: H1TextWidget(
                text: injuryModel.label,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/default_image.jpg',
                    height: 230,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      color: const Color(0xFFEAECF3),
                      child: IconButton(
                        onPressed: () {
                          if (injuryModel.url.isNotEmpty) {
                            InternetCheckerService()
                                .hasInternetConnection()
                                .then((hasConnection) {
                              if (hasConnection) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebSlideView(
                                              selectedUrl: injuryModel.url,
                                              title: injuryModel.label,
                                            )));
                              } else {
                                // Fluttertoast.showToast(
                                //     msg: "This is Center Short Toast",
                                //     toastLength: Toast.LENGTH_SHORT,
                                //     gravity: ToastGravity.CENTER,
                                //     timeInSecForIosWeb: 1,
                                //     backgroundColor: Colors.red,
                                //     textColor: Colors.white,
                                //     fontSize: 16.0);
                              }
                            });
                          }
                        },
                        color: const Color(0xFF672855),
                        icon: const Icon(Icons.zoom_out_map),
                        iconSize: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InjuryDetailTextContainer(
                        title: "Descrição", body: injuryModel.description),
                    InjuryDetailTextContainer(
                        title: "Características Clínicas",
                        body: injuryModel.clinicalCharacs),
                    InjuryDetailTextContainer(
                        title: "Características Radiográficas",
                        body: injuryModel.radiographicalCharacs),
                    InjuryDetailTextContainer(
                        title: "Características Histopatológicas",
                        body: injuryModel.histopathological),
                    InjuryDetailTextContainer(
                        title: "Tratamento", body: injuryModel.treatment),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
