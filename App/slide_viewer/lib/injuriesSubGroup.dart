import 'dart:convert';
import 'package:flutter/material.dart';
import 'Components/H1TextWidget.dart';
import 'Components/H2TextWidget.dart';
import 'Components/SearchWidget.dart';
import 'InjuryDetail.dart';
import 'Style/CustomButtonStyle.dart';

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
      isError = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF672855),
          title: const SearchWidget()),
      backgroundColor: const Color(0xFFEAEFF3),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: H1TextWidget(
              text: widget.parentName,
            ),
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                scrollDirection: Axis.vertical,
                itemCount: buttonsFiltered.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => InjuryDetail(
                                parentId: buttonsFiltered[index].id,
                                parentName: buttonsFiltered[index].label),
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            transitionsBuilder: (_, a, __, c) =>
                                FadeTransition(opacity: a, child: c)),
                      );
                    },
                    style: customButtonStyle(),
                    child: H2TextWidget(
                      text: buttonsFiltered[index].label,
                      fontSize: 18,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
