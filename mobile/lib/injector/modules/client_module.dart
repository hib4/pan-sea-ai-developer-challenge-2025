import 'package:kanca/core/core.dart';
import 'package:kanca/injector/injector.dart';

class ClientModule {
  ClientModule._();

  static void init() {
    final injector = Injector.instance;

    injector.registerLazySingleton<DioClient>(DioClient.new);
  }
}
