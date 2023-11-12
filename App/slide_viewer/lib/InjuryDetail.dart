import 'dart:convert';
import 'package:flutter/material.dart';
import 'WebSlideView.dart';

class Data {
  final int parent;
  final String description;
  final String clinicalCharacs;
  final String radiographicalCharacs;
  final String histopathological;
  final String treatment;
  final String imageName;
  final String url;

  Data(
      {required this.parent,
      required this.description,
      required this.clinicalCharacs,
      required this.radiographicalCharacs,
      required this.histopathological,
      required this.treatment,
      required this.imageName,
      required this.url});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        parent: json['parent'],
        description: json['description'],
        clinicalCharacs: json['clinicalCharacs'],
        radiographicalCharacs: json['radiographicalCharacs'],
        histopathological: json['histopathological'],
        treatment: json['treatment'],
        imageName: json['imageName'],
        url: json['url']);
  }
}

class InjuryDetail extends StatefulWidget {
  final int parentId;
  final String parentName;

  const InjuryDetail(
      {super.key, required this.parentId, required this.parentName});

  @override
  InjuryDetailState createState() => InjuryDetailState();
}

class InjuryDetailState extends State<InjuryDetail> {
  List<Data> data = [];
  List<Data> dataFiltered = [];
  bool isError = false;

  InjuryDetailState();

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      String jsonContent = await DefaultAssetBundle.of(context)
          .loadString('assets/patologiesDetails.json');

      List<dynamic> jsonData = json.decode(jsonContent);
      setState(() {
        data = jsonData.map((item) => Data.fromJson(item)).toList();
        dataFiltered =
            data.where((item) => item.parent == widget.parentId).toList();
        isError = dataFiltered.isEmpty;
      });
    } catch (e) {
      print(e);
      isError = true;
    }
  }

  Container customTextContainer(String title, String body) {
    return Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Container(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9C3C81)),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF404952)),
            ),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (dataFiltered.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      );
    }

    Data injuryInfo = dataFiltered.first;

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
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
              child: Text(
                widget.parentName,
                style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF672855)),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/displasia_fibrosa.jpg',
                    height: 230,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      color: const Color(0xFFEAECF3),
                      child: IconButton(
                        onPressed: () {
                          //Add action to open the Image
                        },
                        color: const Color(0xFF672855),
                        icon: const Icon(Icons.zoom_out_map),
                        iconSize: 35,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customTextContainer("Descrição", injuryInfo.description),
                    customTextContainer(
                        "Características Clínicas", injuryInfo.clinicalCharacs),
                    customTextContainer("Características Radiográficas",
                        injuryInfo.radiographicalCharacs),
                    customTextContainer("Características Histopatológicas",
                        injuryInfo.histopathological),
                    customTextContainer("Tratamento", injuryInfo.treatment),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
