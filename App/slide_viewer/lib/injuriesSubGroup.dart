import 'dart:convert';
import 'package:flutter/material.dart';

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
  bool isError = false; //To be Deleted.

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
            padding: const EdgeInsets.all(25),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey, // Background color
              ),
              onPressed: () {
                print(
                    'Botão ${buttonsFiltered[index].id} pressionado! Label: ${buttons[index].label}');
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           SecondScreen(localId: buttons[index].id)),
                // );
              },
              child: Text(buttonsFiltered[index].label),
            ),
          );
        },
      ),
    );
  }
}
