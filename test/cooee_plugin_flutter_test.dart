import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cooee_plugin_flutter/cooee_plugin_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('cooee_plugin_flutter');

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
    expect(await CooeePluginFlutter.platformVersion, '42');
  });
}
