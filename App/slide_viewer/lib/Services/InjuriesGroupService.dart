import 'dart:convert';
import 'package:flutter/services.dart';

import 'Models/InjuriesGroupModel.dart';

class InjuriesGroupService {
  static final InjuriesGroupService _instance =
      InjuriesGroupService._internal();

  List<InjuriesGroupModel> _injuriesGroups = [];

  InjuriesGroupService._internal();

  factory InjuriesGroupService() {
    return _instance;
  }

  Future<List<InjuriesGroupModel>> loadData() async {
    String jsonContent = await rootBundle.loadString('assets/patologies.json');

    List<dynamic> jsonData = json.decode(jsonContent);

    _injuriesGroups =
        jsonData.map((item) => InjuriesGroupModel.fromJson(item)).toList();
    _injuriesGroups.sort((a, b) => a.label.compareTo(b.label));

    return _injuriesGroups;
  }

  List<InjuriesGroupModel> getList() {
    return _injuriesGroups;
  }
}
