import 'package:flutter/material.dart';

import '../../Components/ImageDetail/CaseStudyImageDetailWidget.dart';
import '../../Components/ImageDetail/PatologyImageDetailWidget.dart';
import '../../Components/Text/H1TextWidget.dart';
import '../../Components/Utils/DrawerWidget.dart';
import '../../Components/Utils/SearchWidget.dart';
import '../../Services/Models/CaseStudyModel.dart';
import '../../Services/Models/PatologyDetailModel.dart';

abstract class DetailBase extends StatelessWidget {
  final int Id;
  final bool showSearchWidget;
  const DetailBase(
      {super.key, required this.Id, required this.showSearchWidget});

  dynamic getModel(int Id);
  List<Widget> GetFields(dynamic Model);

  Widget _GetImageDetailWidget(dynamic Model) {
    if (Model is PatologyDetailModel) {
      return PatologyImageDetailWidget(PatologyModel: Model);
    } else if (Model is CaseStudyModel) {
      return CaseStudyImageDetailWidget(caseStudyModel: Model);
    }

    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    dynamic Model = getModel(Id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF672855),
        title: showSearchWidget ? SearchWidget() : null,
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
                text: Model.label,
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: _GetImageDetailWidget(Model)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: GetFields(Model)),
              ),
            ),
          ]),
    );
  }
}
