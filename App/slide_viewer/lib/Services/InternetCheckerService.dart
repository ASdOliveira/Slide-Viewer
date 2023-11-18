import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetCheckerService {
  static final InternetCheckerService _instance =
      InternetCheckerService._internal();

  InternetCheckerService._internal();

  factory InternetCheckerService() {
    return _instance;
  }

  final InternetConnectionChecker customInstance =
      InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 1),
    checkInterval: const Duration(seconds: 10),
  );

  Future<bool> hasInternetConnection() async {
    return await customInstance.hasConnection;
  }
}
