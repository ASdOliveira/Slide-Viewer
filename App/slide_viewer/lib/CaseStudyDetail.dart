import 'package:flutter/material.dart';
import 'package:slide_viewer/Services/CaseStudiesService.dart';
import 'Components/CaseStudyImageDetailWidget.dart';
import 'Components/DrawerWidget.dart';
import 'Components/H1TextWidget.dart';
import 'Components/InjuryDetailTextContainer.dart';
import 'Services/Models/CaseStudyModel.dart';

class CaseStudyDetail extends StatefulWidget {
  final int Id;

  const CaseStudyDetail({super.key, required this.Id});

  @override
  CaseStudyDetailState createState() => CaseStudyDetailState();
}

class CaseStudyDetailState extends State<CaseStudyDetail> {
  late CaseStudyModel caseStudy;

  CaseStudyDetailState();

  @override
  void initState() {
    super.initState();
    caseStudy = CaseStudiesService().getCaseById(widget.Id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF672855),
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
                text: caseStudy.label, //Title
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: CaseStudyImageDetailWidget(caseStudyModel: caseStudy),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InjuryDetailTextContainer(
                        title: "Descrição", body: caseStudy.description),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
