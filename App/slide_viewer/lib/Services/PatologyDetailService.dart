import 'dart:convert';
import 'package:flutter/services.dart';

import 'Models/PatologyDetailModel.dart';

class PatologyDetailService {
  static final PatologyDetailService _instance =
      PatologyDetailService._internal();

  List<PatologyDetailModel> _injuriesDetails = [];

  PatologyDetailService._internal();

  factory PatologyDetailService() {
    return _instance;
  }

  Future<List<PatologyDetailModel>> loadData() async {
    String jsonContent =
        await rootBundle.loadString('assets/patologiesDetails.json');

    List<dynamic> jsonData = json.decode(jsonContent);

    _injuriesDetails =
        jsonData.map((item) => PatologyDetailModel.fromJson(item)).toList();
    _injuriesDetails.sort((a, b) => a.label.compareTo(b.label));

    return _injuriesDetails;
  }

  List<PatologyDetailModel> getList() {
    return _injuriesDetails;
  }

  List<PatologyDetailModel> getListFilteredByParent(int parentId) {
    return _injuriesDetails.where((item) => item.parent == parentId).toList();
  }

  PatologyDetailModel getListFilteredById(int id) {
    return _injuriesDetails.where((item) => item.id == id).first;
  }
}
