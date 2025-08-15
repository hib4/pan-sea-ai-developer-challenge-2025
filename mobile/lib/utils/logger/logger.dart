import 'package:logger/logger.dart';

final logger = Logger();

extension Log on Object {
  void log() => logger.i(toString());
}
