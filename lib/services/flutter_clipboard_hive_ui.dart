import 'package:flutter/services.dart';

class FlutterClipboardHiveUi {
  static Future<void> copy(String text) {
    return Clipboard.setData(ClipboardData(text: text));
  }

  static Future<String?> getData() async {
    var result = await Clipboard.getData(Clipboard.kTextPlain);
    if (result != null) {
      return result.text;
    } else {
      return null;
    }
  }
}
