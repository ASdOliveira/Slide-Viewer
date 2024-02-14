import 'dart:convert';
import 'package:flutter/services.dart';

import 'Models/CaseStudyModel.dart';

class CaseStudiesService {
  static final CaseStudiesService _instance = CaseStudiesService._internal();

  List<CaseStudyModel> _caseStudies = [];

  CaseStudiesService._internal();

  factory CaseStudiesService() {
    return _instance;
  }

  Future<List<CaseStudyModel>> loadData() async {
    String jsonContent = await rootBundle.loadString('assets/caseStudies.json');

    List<dynamic> jsonData = json.decode(jsonContent);

    _caseStudies =
        jsonData.map((item) => CaseStudyModel.fromJson(item)).toList();
    _caseStudies.sort((a, b) => a.label.compareTo(b.label));

    return _caseStudies;
  }

  List<CaseStudyModel> getList() {
    return _caseStudies;
  }

  CaseStudyModel getCaseById(int id) {
    return _caseStudies.where((item) => item.id == id).first;
  }
}
