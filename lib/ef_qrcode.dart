import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class EfQrcode {
  static const MethodChannel _channel =
  const MethodChannel('ef_qrcode');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Uint8List> generate({
    String content,
    int size = 1024,
    String backgroundColor,
    String foregroundColor,
    Uint8List watermark}) async {
    final Uint8List result = await _channel.invokeMethod(
        'generate',
        <String, dynamic>{
          "content": content,
          "size": size,
          "backgroundColor": backgroundColor,
          "foregroundColor": foregroundColor,
          "watermark": watermark,
        }
    );
    if (result is Uint8List) {
      return result;
    } else if (result is Error) {
      throw result;
    }
    return null;
  }
}
