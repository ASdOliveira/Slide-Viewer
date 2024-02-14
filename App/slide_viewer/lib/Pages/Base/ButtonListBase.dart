import 'package:flutter/material.dart';

import '../../Components/Text/H1TextWidget.dart';
import '../../Components/Text/H2TextWidget.dart';
import '../../Components/Utils/DrawerWidget.dart';
import '../../Components/Utils/SearchWidget.dart';
import '../../Styles/CustomButtonStyle.dart';

abstract class ButtonListBase extends StatelessWidget {
  final String pageTitle;
  final int buttonColumns;
  final bool showSearchWidget;
  const ButtonListBase(
      {super.key,
      required this.pageTitle,
      required this.buttonColumns,
      required this.showSearchWidget});

  dynamic fillButtonList();
  PageRouteBuilder NavigateTo(int Id, [String label]);

  @override
  Widget build(BuildContext context) {
    List<dynamic> buttons = fillButtonList();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFF672855),
          title: showSearchWidget ? SearchWidget() : SizedBox.shrink()),
      backgroundColor: const Color(0xFFEAEFF3),
      drawer: DrawerWidget(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(35.0),
            child: H1TextWidget(
              text: pageTitle,
            ),
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: buttonColumns,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: buttonColumns == 1 ? 3 : 1.3),
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
                        NavigateTo(buttons[index].id, buttons[index].label),
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
