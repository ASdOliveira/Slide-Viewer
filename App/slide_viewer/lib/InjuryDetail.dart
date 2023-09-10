import 'dart:convert';
import 'package:flutter/material.dart';
import 'WebSlideView.dart';

class Data {
  final int parent;
  final String description;
  final String clinicalCharacs;
  final String radiographicalCharacs;
  final String histopathological;
  final String treatment;
  final String imageName;
  final String url;

  Data(
      {required this.parent,
      required this.description,
      required this.clinicalCharacs,
      required this.radiographicalCharacs,
      required this.histopathological,
      required this.treatment,
      required this.imageName,
      required this.url});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        parent: json['parent'],
        description: json['description'],
        clinicalCharacs: json['clinicalCharacs'],
        radiographicalCharacs: json['radiographicalCharacs'],
        histopathological: json['histopathological'],
        treatment: json['treatment'],
        imageName: json['imageName'],
        url: json['url']);
  }
}

class InjuryDetail extends StatefulWidget {
  final int parentId;
  final String parentName;

  const InjuryDetail(
      {super.key, required this.parentId, required this.parentName});

  @override
  InjuryDetailState createState() => InjuryDetailState();
}

class InjuryDetailState extends State<InjuryDetail> {
  List<Data> data = [];
  List<Data> dataFiltered = [];
  bool isError = false;

  InjuryDetailState();

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      String jsonContent = await DefaultAssetBundle.of(context)
          .loadString('assets/patologiesDetails.json');

      List<dynamic> jsonData = json.decode(jsonContent);
      setState(() {
        data = jsonData.map((item) => Data.fromJson(item)).toList();
        dataFiltered =
            data.where((item) => item.parent == widget.parentId).toList();
        isError = dataFiltered.isEmpty;
      });
    } catch (e) {
      print(e);
      isError = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dataFiltered.length == 0) {
      return const CircularProgressIndicator();
    }

    Text CustomSectionTitle(String textToDisplay) {
      return Text(
        textToDisplay,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }

    Text CustomContent(String textToDisplay) {
      return Text(textToDisplay, textAlign: TextAlign.justify);
    }

    Data data = dataFiltered.first;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Center(
              child: Text(widget.parentName, textAlign: TextAlign.center)),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                CustomSectionTitle("Descrição"),
                const SizedBox(height: 10),
                CustomContent(data.description),
                const SizedBox(height: 10),
                CustomSectionTitle("Características Clínicas"),
                const SizedBox(height: 10),
                CustomContent(data.clinicalCharacs),
                const SizedBox(height: 10),
                CustomSectionTitle("Características Radiográficas"),
                const SizedBox(height: 10),
                CustomContent(data.radiographicalCharacs),
                const SizedBox(height: 10),
                CustomSectionTitle("Histopatológico"),
                const SizedBox(height: 10),
                CustomContent(data.histopathological),
                const SizedBox(height: 10),
                CustomSectionTitle("Tratamento"),
                const SizedBox(height: 10),
                CustomContent(data.treatment),
                const SizedBox(height: 10),
                CustomSectionTitle("Lâmina (clique para ampliar)"),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => WebSlideView(
                              title: widget.parentName,
                              selectedUrl: data.url,
                            )));
                  },
                  child: Image.asset('assets/images/${data.imageName}'),
                ),
              ],
            ),
          ),
        ));
  }
}
