import 'package:flutter/material.dart';

import 'PatologiesSubGroup.dart';
import '../Base/ButtonListBase.dart';
import '../../Services/PatologiesGroupService.dart';

class PatologiesGroup extends ButtonListBase {
  const PatologiesGroup({super.key})
      : super(
            pageTitle: "Grupos de Lesões",
            buttonColumns: 2,
            showSearchWidget: true);

  @override
  dynamic fillButtonList() {
    return PatologiesGroupService().getList();
  }

  @override
  PageRouteBuilder NavigateTo(int Id, [String? label]) {
    return PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            PatologiesSubGroup(parentId: Id, parentName: label!),
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c));
  }
}
