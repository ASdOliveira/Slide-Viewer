import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:slide_viewer/injuriesSubGroup.dart';

class ButtonData {
  final int id;
  final String label;

  ButtonData({required this.id, required this.label});

  factory ButtonData.fromJson(Map<String, dynamic> json) {
    return ButtonData(
      id: json['id'],
      label: json['label'],
    );
  }
}

class InjuriesGroup extends StatefulWidget {
  const InjuriesGroup({super.key});

  @override
  InjuriesGroupState createState() => InjuriesGroupState();
}

class InjuriesGroupState extends State<InjuriesGroup> {
  List<ButtonData> buttons = [];

  @override
  void initState() {
    super.initState();
    loadButtonData();
  }

  Future<void> loadButtonData() async {
    try {
      String jsonContent = await DefaultAssetBundle.of(context)
          .loadString('assets/patologies.json');

      List<dynamic> jsonData = json.decode(jsonContent);
      setState(() {
        buttons = jsonData.map((item) => ButtonData.fromJson(item)).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Center(
              child: Text('Grupo de lesões', textAlign: TextAlign.center)),
        ),
        body: ListView.builder(
          itemCount: buttons.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey, // Background color
                ),
                onPressed: () {
                  // print(
                  //     'Botão ${buttons[index].id} pressionado! Label: ${buttons[index].label}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InjuriesSubGroup(
                            parentId: buttons[index].id,
                            parentName: buttons[index].label)),
                  );
                },
                child: Text(buttons[index].label),
              ),
            );
          },
        ),
      ),
    );
  }
}
