import 'package:flutter/material.dart';

import 'Components/Utils/SplashScreenWidget.dart';
import 'Services/CaseStudiesService.dart';
import 'Services/PatologiesGroupService.dart';
import 'Services/PatologyDetailService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PatologiesGroupService().loadData();
  await PatologyDetailService().loadData();
  await CaseStudiesService().loadData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: SplashScreenWidget());
  }
}
