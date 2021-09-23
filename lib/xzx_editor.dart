
import 'dart:async';

import 'package:flutter/services.dart';

class XzxEditor {
  static const MethodChannel _channel = MethodChannel('xzx_editor');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
