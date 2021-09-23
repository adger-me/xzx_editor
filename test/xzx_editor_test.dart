import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xzx_editor/xzx_editor.dart';

void main() {
  const MethodChannel channel = MethodChannel('xzx_editor');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await XzxEditor.platformVersion, '42');
  });
}
