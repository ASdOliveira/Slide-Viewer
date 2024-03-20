import 'package:flutter/material.dart';

import '../../Components/Text/BodyTextWidget.dart';
import '../../Components/Text/H1TextWidget.dart';
import '../../Components/Text/H2TextWidget.dart';
import '../../Components/Utils/DrawerWidget.dart';
import '../../Components/Utils/SearchWidget.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xFF672855),
            title: const SearchWidget()),
        backgroundColor: const Color(0xFFFFFFFF),
        drawer: DrawerWidget(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H1TextWidget(text: "Sobre o aplicativo"),
                const SizedBox(height: 18),
                BodyTextWidget(
                    text: "O aplicativo foi desenvolvido para acadêmicos"
                        " da área de odontologia com o objetivo de auxiliar no aprendizado"
                        " sobre o diagnóstico das principais patologias orais."),
                const SizedBox(height: 18),
                H2TextWidget(
                  text: "Colaboradores",
                  fontSize: 18,
                ),
                const SizedBox(height: 16),
                BodyTextWidget(
                    text: "Profº Dr. Danyel Elias da Cruz Perez – "
                        "Universidade Federal de Pernambuco\n\n"
                        "Fernanda Gabriela Delfino Ferreira Oliveira – "
                        "Cirurgiã-dentista e Mestranda pela Universidade Federal de Pernambuco\n\n"
                        "MsC. Arysson Silva de Oliveira – Desenvolvedor de Software e Engenheiro Eletrônico\n\n"
                        "Jayne Silva de Oliveira – Design e Mestranda pela Universidade Federal de Pernambuco"),
                const SizedBox(height: 18),
                H2TextWidget(
                  text: "Bibliografia",
                  fontSize: 18,
                ),
                const SizedBox(height: 18),
                BodyTextWidget(
                    text:
                        "Editorial Board of the WHO Classification of Tumors. Head and neck tumors [Internet; beta version ahead of print]. Lyon (France): International Agency for Cancer Research;2022 [cited 2024]. (WHO tumor classification series, 5thed.; vol.9). Available at: http://tumorclassification.iarc.who.int.chapters/52.\n\nNEVILLE, Brad. Patologia oral e maxilofacial. 4 ed. Rio de Janeiro: Elsevier, 2016, 912 ISBN: 978-85-352-6564-4."),
                const SizedBox(height: 18),
                H2TextWidget(
                  text: "Contato",
                  fontSize: 18,
                ),
                const SizedBox(height: 18),
                BodyTextWidget(text: "fernanda.delfino@ufpe.br"),
              ],
            ),
          ),
        ));
  }
}
