import 'dart:async';
import 'package:flutter/services.dart';
export 'widget/widget.dart';

class XzxEditor {
  static const MethodChannel _channel = MethodChannel('xzx_editor');

  /// 获取版本号
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
