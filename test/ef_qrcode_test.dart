import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ef_qrcode/ef_qrcode.dart';

void main() {
  const MethodChannel channel = MethodChannel('ef_qrcode');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await EfQrcode.platformVersion, '42');
  });
}
