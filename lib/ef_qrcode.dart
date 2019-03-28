import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class EfQrcode {
  static const MethodChannel _channel =
      const MethodChannel('ef_qrcode');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<File> generate(String content, String backgroundColor, String foregroundColor) async {
    final String result = await _channel.invokeMethod('generate', {"content": content, "backgroundColor": backgroundColor, "foregroundColor": foregroundColor});
    if (result is String) {
      return new File(result);
    } else if (result is Error) {
      throw result;
    }
    return null;
  }
}
