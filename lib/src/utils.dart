import 'dart:async';
import 'dart:ui';
import 'dart:convert';

import 'package:flutter/services.dart';

class Utils {
  static Future<String> imageToBase64(Image image) async {
    ByteData imageBytes = (await image.toByteData());
    return base64Encode(imageBytes.buffer.asInt32List());
  }
}