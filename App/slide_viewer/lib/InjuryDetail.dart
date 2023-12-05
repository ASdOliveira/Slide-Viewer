import 'package:flutter/material.dart';
import 'package:slide_viewer/Services/InjuryDetailService.dart';
import 'package:slide_viewer/Services/Models/InjuryDetailModel.dart';
import 'Components/DrawerWidget.dart';
import 'Components/H1TextWidget.dart';
import 'Components/InjuryDetailTextContainer.dart';
import 'Components/InjuryImageDetailWidget.dart';
import 'Components/SearchWidget.dart';
import 'Style/CustomTextStyle.dart';
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
                  InjuryImageDetailWidget(imageName: injuryModel.imageName),
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
                                var snackBar = SnackBar(
                                  content: Text(
                                    "Para ver em detalhes, é necessário conexão com a internet",
                                    style: subTitle3TextStyle(),
                                  ),
                                  duration: const Duration(seconds: 4),
                                  showCloseIcon: true,
                                  backgroundColor:
                                      const Color.fromARGB(255, 128, 77, 113),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
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
