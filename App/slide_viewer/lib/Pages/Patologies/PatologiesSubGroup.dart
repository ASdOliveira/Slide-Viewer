import 'package:flutter/material.dart';

import 'PatologyDetail.dart';
import '../../Components/Text/H1TextWidget.dart';
import '../../Components/Text/H2TextWidget.dart';
import '../../Components/Utils/DrawerWidget.dart';
import '../../Components/Utils/SearchWidget.dart';
import '../../Services/PatologyDetailService.dart';
import '../../Services/Models/PatologyDetailModel.dart';
import '../../Styles/CustomButtonStyle.dart';

class PatologiesSubGroup extends StatefulWidget {
  final int parentId;
  final String parentName;
  const PatologiesSubGroup(
      {super.key, required this.parentId, required this.parentName});

  @override
  PatologiesSubGroupState createState() => PatologiesSubGroupState();
}

class PatologiesSubGroupState extends State<PatologiesSubGroup> {
  List<PatologyDetailModel> buttonsFiltered = [];

  PatologiesSubGroupState();

  @override
  void initState() {
    super.initState();
    buttonsFiltered =
        PatologyDetailService().getListFilteredByParent(widget.parentId);
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
                                PatologyDetail(Id: buttonsFiltered[index].id),
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
