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
        buttons.sort((a, b) => a.label.compareTo(b.label));
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
          backgroundColor: const Color(0xFF672855),
          title: const Center(
              child: Text('Grupo de lesões', textAlign: TextAlign.center)),
        ),
        backgroundColor: const Color(0xFFEAEFF3),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(35.0),
              child: Text(
                "Grupo de Lesões",
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF672855)),
              ),
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.3),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  scrollDirection: Axis.vertical,
                  itemCount: buttons.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InjuriesSubGroup(
                                  parentId: buttons[index].id,
                                  parentName: buttons[index].label)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: Text(
                        buttons[index].label,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF672855)),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
