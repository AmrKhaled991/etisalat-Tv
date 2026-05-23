import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:etisalatdemotv/app.dart';
import 'package:etisalatdemotv/core/platform/platform_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool isTV = kIsWeb ? true : await PlatformService.isTV();

  runApp(App(isTV: isTV));
}
