import 'dart:io';

import 'package:flutter/services.dart';
class PlatformService {
  PlatformService._();

  static const _channel = MethodChannel('com.etisalat.tv/platform');

  static bool? _isTV;

  static Future<bool> isTV() async {
    if (_isTV != null) return _isTV!;

    if (!Platform.isAndroid) {
      _isTV = false;
      return false;
    }

    try {
      _isTV = await _channel.invokeMethod<bool>('isTV') ?? false;
    } on PlatformException {
      _isTV = false;
    }

    return _isTV!;
  }
}
