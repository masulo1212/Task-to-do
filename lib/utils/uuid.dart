import 'package:uuid/uuid.dart';

class GenId {
  static var uuid = const Uuid();

  static String genUuid() {
    return uuid.v1();
  }
}
