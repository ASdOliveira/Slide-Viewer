import 'package:flutter/material.dart';
import 'Services/InjuriesGroupService.dart';
import 'injuriesGroup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjuriesGroupService().loadData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: InjuriesGroup());
  }
}
