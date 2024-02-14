import 'package:flutter/material.dart';

import 'CaseStudyDetail.dart';
import '../Base/ButtonListBase.dart';
import '../../Services/CaseStudiesService.dart';

class CaseStudiesListPage extends ButtonListBase {
  const CaseStudiesListPage({super.key})
      : super(
            buttonColumns: 1,
            pageTitle: "Estudos de caso",
            showSearchWidget: false);

  @override
  dynamic fillButtonList() {
    return CaseStudiesService().getList();
  }

  @override
  PageRouteBuilder NavigateTo(int Id, [String? label]) {
    return PageRouteBuilder(
        pageBuilder: (_, __, ___) => CaseStudyDetail(Id: Id),
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c));
  }
}
