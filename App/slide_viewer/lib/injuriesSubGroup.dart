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
      isError = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF672855),
        title: const TextField(
          cursorColor: Colors.white,
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFFFFF)),
          decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFF9C3C81),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              hintText: 'Pesquisar',
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFFFFF)),
              focusColor: Color(0xFFFFFFFF),
              prefixIconColor: Colors.white,
              hoverColor: Color(0xFF9C3C81)),
        ),
      ),
      backgroundColor: const Color(0xFFEAEFF3),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Text(
              widget.parentName,
              style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF672855)),
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
                                parentId: buttons[index].id,
                                parentName: buttons[index].label),
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            transitionsBuilder: (_, a, __, c) =>
                                FadeTransition(opacity: a, child: c)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: Text(
                      buttonsFiltered[index].label,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9C3C81)),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
