import 'dart:convert';
import 'package:flutter/material.dart';
import 'InjuryDetail.dart';

class ButtonData {
  final int id;
  final String label;
  final int parent;

  ButtonData({required this.id, required this.label, required this.parent});

  factory ButtonData.fromJson(Map<String, dynamic> json) {
    return ButtonData(
        id: json['id'], label: json['label'], parent: json['parent']);
  }
}

class InjuriesSubGroup extends StatefulWidget {
  final int parentId;
  final String parentName;
  const InjuriesSubGroup(
      {super.key, required this.parentId, required this.parentName});

  @override
  InjuriesSubGroupState createState() => InjuriesSubGroupState();
}

class InjuriesSubGroupState extends State<InjuriesSubGroup> {
  List<ButtonData> buttons = [];
  List<ButtonData> buttonsFiltered = [];
  bool isError = false;

  InjuriesSubGroupState();

  @override
  void initState() {
    super.initState();
    loadButtonData();
  }

  Future<void> loadButtonData() async {
    try {
      String jsonContent = await DefaultAssetBundle.of(context)
          .loadString('assets/patologiesSubGroups.json');

      List<dynamic> jsonData = json.decode(jsonContent);
      setState(() {
        buttons = jsonData.map((item) => ButtonData.fromJson(item)).toList();
        buttonsFiltered =
            buttons.where((item) => item.parent == widget.parentId).toList();
        buttonsFiltered.sort((a, b) => a.label.compareTo(b.label));
        isError = buttonsFiltered.isEmpty;
      });
    } catch (e) {
      print(e);
      isError = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isError) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.parentName),
        ),
        body: const Center(
          child: Text('Ocorreu um erro ao carregar a lista de botões.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title:
            Center(child: Text(widget.parentName, textAlign: TextAlign.center)),
      ),
      body: ListView.builder(
        itemCount: buttonsFiltered.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(27),
            child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InjuryDetail(
                              parentId: buttonsFiltered[index].id,
                              parentName: buttonsFiltered[index].label)),
                    );
                  },
                  child: Text(buttonsFiltered[index].label),
                )),
          );
        },
      ),
    );
  }
}
