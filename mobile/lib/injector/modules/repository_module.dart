import 'package:kanca/data/data.dart';
import 'package:kanca/injector/injector.dart';

class RepositoryModule {
  RepositoryModule._();

  static void init() {
    final injector = Injector.instance;

    injector.registerFactory<StoryRepository>(
      () => StoryRepositoryImpl(client: injector()),
    );

    injector.registerFactory<ChatRepository>(
      () => ChatRepositoryImpl(dioClient: injector()),
    );
  }
}
