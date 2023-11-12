import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:slide_viewer/Components/DrawerWidget.dart';
import 'Components/H1TextWidget.dart';
import 'Components/H2TextWidget.dart';
import 'Components/SearchWidget.dart';
import 'InjuryDetail.dart';
import 'Services/InjuryDetailService.dart';
import 'Services/Models/InjuryDetailModel.dart';
import 'Style/CustomButtonStyle.dart';

class InjuriesSubGroup extends StatefulWidget {
  final int parentId;
  final String parentName;
  const InjuriesSubGroup(
      {super.key, required this.parentId, required this.parentName});

  @override
  InjuriesSubGroupState createState() => InjuriesSubGroupState();
}

class InjuriesSubGroupState extends State<InjuriesSubGroup> {
  List<InjuryDetailModel> buttonsFiltered = [];

  InjuriesSubGroupState();

  @override
  void initState() {
    super.initState();
    buttonsFiltered =
        InjuryDetailService().getListFilteredByParent(widget.parentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFF672855),
          title: const SearchWidget()),
      backgroundColor: const Color(0xFFEAEFF3),
      drawer: DrawerWidget(),
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
                            pageBuilder: (_, __, ___) =>
                                InjuryDetail(Id: buttonsFiltered[index].id),
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
