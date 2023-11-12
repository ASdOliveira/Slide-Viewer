import 'dart:convert';
import 'package:flutter/services.dart';

import 'Models/InjuryDetailModel.dart';

class InjuryDetailService {
  static final InjuryDetailService _instance = InjuryDetailService._internal();

  List<InjuryDetailModel> _injuriesDetails = [];

  InjuryDetailService._internal();

  factory InjuryDetailService() {
    return _instance;
  }

  Future<List<InjuryDetailModel>> loadData() async {
    String jsonContent =
        await rootBundle.loadString('assets/patologiesDetails.json');

    List<dynamic> jsonData = json.decode(jsonContent);

    _injuriesDetails =
        jsonData.map((item) => InjuryDetailModel.fromJson(item)).toList();
    _injuriesDetails.sort((a, b) => a.label.compareTo(b.label));

    return _injuriesDetails;
  }

  List<InjuryDetailModel> getList() {
    return _injuriesDetails;
  }

  List<InjuryDetailModel> getListFilteredByParent(int parentId) {
    return _injuriesDetails.where((item) => item.parent == parentId).toList();
  }

  InjuryDetailModel getListFilteredById(int id) {
    return _injuriesDetails.where((item) => item.id == id).first;
  }
}
