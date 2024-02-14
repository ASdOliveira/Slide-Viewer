import 'package:flutter/material.dart';

import '../../Components/Text/DetailTextContainer.dart';
import '../../Services/CaseStudiesService.dart';
import '../Base/DetailBase.dart';

class CaseStudyDetail extends DetailBase {
  final int Id;

  const CaseStudyDetail({super.key, required this.Id})
      : super(Id: Id, showSearchWidget: false);

  @override
  dynamic getModel(int Id) {
    return CaseStudiesService().getCaseById(Id);
  }

  @override
  List<Widget> GetFields(Model) {
    return [
      DetailTextContainer(title: "Descrição", body: Model.description),
    ];
  }
}
