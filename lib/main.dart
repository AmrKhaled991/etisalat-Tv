import 'package:flutter/material.dart';
import 'package:etisalatdemotv/app.dart';
import 'package:etisalatdemotv/core/platform/platform_service.dart';

/// Application entry point.
///
/// 1. Detects device type (TV vs phone) via native MethodChannel
/// 2. Launches [App] with the result
///
/// All other wiring (Provider, ViewModel) happens inside [App].
/// 
/// 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //nooooooote
  // if we use web we can bot use platform.isAndroid but this will 
  // and we if i use web app will be landscape by defult

  // final isTV = await PlatformService.isTV();
  
  runApp(App(isTV: false));

}
