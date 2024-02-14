import 'package:flutter/material.dart';

import 'PatologiesSubGroup.dart';
import '../../Components/Text/H1TextWidget.dart';
import '../../Components/Text/H2TextWidget.dart';
import '../../Components/Utils/DrawerWidget.dart';
import '../../Components/Utils/SearchWidget.dart';
import '../../Services/PatologiesGroupService.dart';
import '../../Services/Models/PatologiesGroupModel.dart';
import '../../Styles/CustomButtonStyle.dart';

class PatologiesGroup extends StatefulWidget {
  const PatologiesGroup({super.key});

  @override
  PatologiesGroupState createState() => PatologiesGroupState();
}

class PatologiesGroupState extends State<PatologiesGroup> {
  List<PatologiesGroupModel> buttons = PatologiesGroupService().getList();

  @override
  void initState() {
    super.initState();
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
          const Padding(
            padding: EdgeInsets.all(35.0),
            child: H1TextWidget(
              text: "Grupos de Lesões",
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
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => PatologiesSubGroup(
                                parentId: buttons[index].id,
                                parentName: buttons[index].label),
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            transitionsBuilder: (_, a, __, c) =>
                                FadeTransition(opacity: a, child: c)),
                      );
                    },
                    style: customButtonStyle(),
                    child: H2TextWidget(
                      text: buttons[index].label,
                      fontSize: 15,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
