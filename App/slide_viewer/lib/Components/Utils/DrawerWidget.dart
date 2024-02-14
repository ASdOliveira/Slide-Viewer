import 'package:flutter/material.dart';

import '../../Pages/Others/AboutPage.dart';
import '../../Pages/CaseStudies/CaseStudiesListPage.dart';
import '../../Pages/Patologies/PatologiesGroup.dart';
import '../../Styles/CustomTextStyle.dart';

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
                const SizedBox(width: 15),
                Text(
                  "Guia de Patologia Oral",
                  style: H1WhiteTextStyle(),
                )
              ],
            )),
            ListTile(
              title: Text(
                'Grupos de Lesões',
                style: subTitle3TextStyle(),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PatologiesGroup()));
              },
            ),
            ListTile(
              title: Text(
                'Estudos de Caso',
                style: subTitle3TextStyle(),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CaseStudiesListPage()));
              },
            ),
            ListTile(
              title: Text(
                'Sobre',
                style: subTitle3TextStyle(),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
