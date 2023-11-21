import 'package:flutter/material.dart';
import 'package:slide_viewer/injuriesGroup.dart';

import '../Style/CustomTextStyle.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF672855),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 70,
                  width: 75,
                ),
                const SizedBox(width: 20),
                Text(
                  "Nome do App",
                  style: H1WhiteTextStyle(),
                )
              ],
            )),
            ListTile(
              title: Text(
                'Grupo de Lesões',
                style: subTitle3TextStyle(),
              ),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InjuriesGroup()));
              },
            ),
            ListTile(
              title: Text(
                'Estudos de Caso',
                style: subTitle3TextStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Sobre',
                style: subTitle3TextStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
