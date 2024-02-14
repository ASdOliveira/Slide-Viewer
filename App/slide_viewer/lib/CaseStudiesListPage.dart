import 'package:flutter/material.dart';

import 'CaseStudyDetail.dart';
import 'Components/Text/H1TextWidget.dart';
import 'Components/Text/H2TextWidget.dart';
import 'Components/Utils/DrawerWidget.dart';
import 'Services/CaseStudiesService.dart';
import 'Services/Models/CaseStudyModel.dart';
import 'Style/CustomButtonStyle.dart';

class CaseStudiesListPage extends StatefulWidget {
  const CaseStudiesListPage({super.key});

  @override
  CaseStudiesListPageState createState() => CaseStudiesListPageState();
}

class CaseStudiesListPageState extends State<CaseStudiesListPage> {
  List<CaseStudyModel> cases = CaseStudiesService().getList();

  CaseStudiesListPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF672855),
      ),
      backgroundColor: const Color(0xFFEAEFF3),
      drawer: DrawerWidget(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: H1TextWidget(
              text: "Estudos de caso",
            ),
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                scrollDirection: Axis.vertical,
                itemCount: cases.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                CaseStudyDetail(Id: cases[index].id),
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            transitionsBuilder: (_, a, __, c) =>
                                FadeTransition(opacity: a, child: c)),
                      );
                    },
                    style: customButtonStyle(),
                    child: H2TextWidget(
                      text: cases[index].label,
                      fontSize: 18,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
