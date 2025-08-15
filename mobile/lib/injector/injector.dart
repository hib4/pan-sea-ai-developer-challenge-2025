import 'package:get_it/get_it.dart';
import 'package:kanca/injector/modules/modules.dart';

class Injector {
  Injector._();

  static GetIt instance = GetIt.instance;

  static void init() {
    ClientModule.init();
    RepositoryModule.init();
    BlocModule.init();
  }

  static void reset() {
    instance.reset();
  }

  static void resetLazySingleton() {
    instance.resetLazySingleton();
  }
}
