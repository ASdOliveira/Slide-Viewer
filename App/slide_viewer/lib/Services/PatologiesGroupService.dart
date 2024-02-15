import 'dart:convert';
import 'package:flutter/services.dart';

import 'Models/PatologiesGroupModel.dart';

class PatologiesGroupService {
  static final PatologiesGroupService _instance =
      PatologiesGroupService._internal();

  List<PatologiesGroupModel> _PatologiesGroups = [];

  PatologiesGroupService._internal();

  factory PatologiesGroupService() {
    return _instance;
  }

  Future<List<PatologiesGroupModel>> loadData() async {
    String jsonContent =
        await rootBundle.loadString('assets/json/patologies.json');

    List<dynamic> jsonData = json.decode(jsonContent);

    _PatologiesGroups =
        jsonData.map((item) => PatologiesGroupModel.fromJson(item)).toList();
    _PatologiesGroups.sort((a, b) => a.label.compareTo(b.label));

    return _PatologiesGroups;
  }

  List<PatologiesGroupModel> getList() {
    return _PatologiesGroups;
  }
}
