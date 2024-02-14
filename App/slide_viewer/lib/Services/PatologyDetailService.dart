import 'dart:convert';
import 'package:flutter/services.dart';

import 'Models/PatologyDetailModel.dart';

class PatologyDetailService {
  static final PatologyDetailService _instance =
      PatologyDetailService._internal();

  List<PatologyDetailModel> _PatologiesDetails = [];

  PatologyDetailService._internal();

  factory PatologyDetailService() {
    return _instance;
  }

  Future<List<PatologyDetailModel>> loadData() async {
    String jsonContent =
        await rootBundle.loadString('assets/patologiesDetails.json');

    List<dynamic> jsonData = json.decode(jsonContent);

    _PatologiesDetails =
        jsonData.map((item) => PatologyDetailModel.fromJson(item)).toList();
    _PatologiesDetails.sort((a, b) => a.label.compareTo(b.label));

    return _PatologiesDetails;
  }

  List<PatologyDetailModel> getList() {
    return _PatologiesDetails;
  }

  List<PatologyDetailModel> getListFilteredByParent(int parentId) {
    return _PatologiesDetails.where((item) => item.parent == parentId).toList();
  }

  PatologyDetailModel getListFilteredById(int id) {
    return _PatologiesDetails.where((item) => item.id == id).first;
  }
}
