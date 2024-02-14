import 'package:flutter/material.dart';

import 'Components/Utils/SplashScreenWidget.dart';
import 'Services/CaseStudiesService.dart';
import 'Services/InjuriesGroupService.dart';
import 'Services/InjuryDetailService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjuriesGroupService().loadData();
  await InjuryDetailService().loadData();
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
