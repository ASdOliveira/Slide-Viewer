import 'package:flutter/material.dart';

import '../../Components/ImageDetail/PatologyImageDetailWidget.dart';
import '../../Components/Text/H1TextWidget.dart';
import '../../Components/Text/DetailTextContainer.dart';
import '../../Components/Utils/DrawerWidget.dart';
import '../../Components/Utils/SearchWidget.dart';
import '../../Services/PatologyDetailService.dart';
import '../../Services/Models/PatologyDetailModel.dart';

class PatologyDetail extends StatefulWidget {
  final int Id;

  const PatologyDetail({super.key, required this.Id});

  @override
  PatologyDetailState createState() => PatologyDetailState();
}

class PatologyDetailState extends State<PatologyDetail> {
  late PatologyDetailModel PatologyModel;

  PatologyDetailState();

  @override
  void initState() {
    super.initState();
    PatologyModel = PatologyDetailService().getListFilteredById(widget.Id);
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
                text: PatologyModel.label,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: PatologyImageDetailWidget(
                PatologyModel: PatologyModel,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DetailTextContainer(
                        title: "Descrição", body: PatologyModel.description),
                    DetailTextContainer(
                        title: "Características Clínicas",
                        body: PatologyModel.clinicalCharacs),
                    DetailTextContainer(
                        title: "Características Radiográficas",
                        body: PatologyModel.radiographicalCharacs),
                    DetailTextContainer(
                        title: "Características Histopatológicas",
                        body: PatologyModel.histopathological),
                    DetailTextContainer(
                        title: "Tratamento", body: PatologyModel.treatment),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
