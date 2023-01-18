import 'package:uuid/uuid.dart';
 class IdGenerator {
  static String generate() {
    return const Uuid().v4();
  }
}