import 'package:flutter/material.dart';

import 'PatologyDetail.dart';
import '../Base/ButtonListBase.dart';
import '../../Services/PatologyDetailService.dart';

class PatologiesSubGroup extends ButtonListBase {
  final int parentId;
  final String parentName;
  const PatologiesSubGroup(
      {super.key, required this.parentId, required this.parentName})
      : super(buttonColumns: 1, pageTitle: parentName, showSearchWidget: true);

  @override
  dynamic fillButtonList() {
    return PatologyDetailService().getListFilteredByParent(parentId);
  }

  @override
  PageRouteBuilder NavigateTo(int Id, [String? label]) {
    return PageRouteBuilder(
        pageBuilder: (_, __, ___) => PatologyDetail(Id: Id),
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c));
  }
}
