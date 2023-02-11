import 'dart:math' as math;

class IdGenerator {
  static String generate() {
    math.Random random = math.Random(DateTime.now().millisecond);
    const String hexDigits = "0123456789abcdef";
    int length = 36;
    final List<String> uuid = List.generate(length, (_) => "");

    for (int i = 0; i < length; i++) {
      final int hexPos = random.nextInt(16);
      uuid[i] = (hexDigits.substring(hexPos, hexPos + 1));
    }

    int pos = (int.parse(uuid[19], radix: 16) & 0x3) | 0x8;

    uuid[14] = "4";
    uuid[19] = hexDigits.substring(pos, pos + 1);

    uuid[8] = uuid[13] = uuid[18] = uuid[23] = "-";

    final StringBuffer buffer = StringBuffer();
    buffer.writeAll(uuid);
    return buffer.toString();
  }
}
