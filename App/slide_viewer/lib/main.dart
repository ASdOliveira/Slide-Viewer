import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class ButtonData {
  final int id;
  final String label;

  ButtonData({required this.id, required this.label});

  factory ButtonData.fromJson(Map<String, dynamic> json) {
    return ButtonData(
      id: json['id'],
      label: json['label'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<ButtonData> buttons = [];

  @override
  void initState() {
    super.initState();
    loadButtonData();
  }

  Future<void> loadButtonData() async {
    // Ler o arquivo JSON
    String jsonContent = await DefaultAssetBundle.of(context)
        .loadString('assets/patologies.json');

    // Converter o JSON em uma lista de objetos ButtonData
    List<dynamic> jsonData = json.decode(jsonContent);
    setState(() {
      buttons = jsonData.map((item) => ButtonData.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            'Grupo de lesões',
            textAlign: TextAlign.center,
          )),
        ),
        body: ListView.builder(
          itemCount: buttons.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(25),
              child: ElevatedButton(
                onPressed: () {
                  // print(
                  //     'Botão ${buttons[index].id} pressionado! Label: ${buttons[index].label}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SecondScreen()),
                  );
                },
                child: Text(buttons[index].label),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Segunda Tela'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Voltar para a Primeira Tela'),
        ),
      ),
    );
  }
}
