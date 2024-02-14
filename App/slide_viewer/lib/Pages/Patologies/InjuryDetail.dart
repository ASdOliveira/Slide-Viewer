import 'package:flutter/material.dart';

import '../../Components/ImageDetail/PatologyImageDetailWidget.dart';
import '../../Components/Text/H1TextWidget.dart';
import '../../Components/Text/DetailTextContainer.dart';
import '../../Components/Utils/DrawerWidget.dart';
import '../../Components/Utils/SearchWidget.dart';
import '../../Services/PatologyDetailService.dart';
import '../../Services/Models/PatologyDetailModel.dart';

class InjuryDetail extends StatefulWidget {
  final int Id;

  const InjuryDetail({super.key, required this.Id});

  @override
  InjuryDetailState createState() => InjuryDetailState();
}

class InjuryDetailState extends State<InjuryDetail> {
  late PatologyDetailModel injuryModel;

  InjuryDetailState();

  @override
  void initState() {
    super.initState();
    injuryModel = PatologyDetailService().getListFilteredById(widget.Id);
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
              child: PatologyImageDetailWidget(
                injuryModel: injuryModel,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DetailTextContainer(
                        title: "Descrição", body: injuryModel.description),
                    DetailTextContainer(
                        title: "Características Clínicas",
                        body: injuryModel.clinicalCharacs),
                    DetailTextContainer(
                        title: "Características Radiográficas",
                        body: injuryModel.radiographicalCharacs),
                    DetailTextContainer(
                        title: "Características Histopatológicas",
                        body: injuryModel.histopathological),
                    DetailTextContainer(
                        title: "Tratamento", body: injuryModel.treatment),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
