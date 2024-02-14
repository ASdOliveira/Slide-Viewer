import 'package:flutter/material.dart';

import '../../Components/Text/DetailTextContainer.dart';
import '../../Services/PatologyDetailService.dart';
import '../Base/DetailBase.dart';

class PatologyDetail extends DetailBase {
  final int Id;

  const PatologyDetail({super.key, required this.Id})
      : super(Id: Id, showSearchWidget: true);

  @override
  dynamic getModel(int Id) {
    return PatologyDetailService().getListFilteredById(Id);
  }

  @override
  List<Widget> GetFields(Model) {
    return [
      DetailTextContainer(title: "Descrição", body: Model.description),
      DetailTextContainer(
          title: "Características Clínicas", body: Model.clinicalCharacs),
      DetailTextContainer(
          title: "Características Radiográficas",
          body: Model.radiographicalCharacs),
      DetailTextContainer(
          title: "Características Histopatológicas",
          body: Model.histopathological),
      DetailTextContainer(title: "Tratamento", body: Model.treatment),
    ];
  }
}
