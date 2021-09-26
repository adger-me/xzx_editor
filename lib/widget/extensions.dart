import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// widget 扩展
extension WidgetExt on Widget {
  GestureDetector intoGesture({
    BuildContext? context,
    GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
  }) => GestureDetector(
    child: this,
    onTap: onTap,
    onDoubleTap: onDoubleTap,
    onLongPress: onLongPress,
    behavior: HitTestBehavior.translucent,
  );
}

// String 扩展
extension StringExt on String {
  double toDouble() => double.parse(this);

  int toInt() => int.parse(this);

  /// 转成 color
  Color toColor() {
    var defaultColor = Colors.black;

    if (!contains("#")) {
      return defaultColor;
    }
    var hexColor = replaceAll("#", "");
    /// 如果是6位，前加0xff
    if (hexColor.length == 6) {
      hexColor = "0xff" + hexColor;
      var color = Color(int.parse(hexColor));
      return color;
    }
    /// 如果是8位，前加0x
    if (hexColor.length == 8) {
      var color = Color(int.parse("0x$hexColor"));
      return color;
    }
    return defaultColor;
  }
}

/// 泛型扩展
extension AllExt<T> on T {
  T apply(Function(T e) f) {
    f(this);
    return this;
  }

  R let<R>(R Function(T e) f) {
    return f(this);
  }
}

/// 解决当输入框内容全为字母且长度超过63不能继续输入的bug
extension TextEdCtrlExt on TextEditingController {
  void fixed63Length() {
    addListener(() {
      if (text.length == 63 && Platform.isAndroid) {
        text += " ";
        selection = TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.downstream,
            offset: text.length - 1,
          ),
        );
      }
    });
  }
}
