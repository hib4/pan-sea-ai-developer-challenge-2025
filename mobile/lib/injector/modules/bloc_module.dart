import 'package:kanca/features/story/bloc/story_bloc.dart';
import 'package:kanca/injector/injector.dart';

class BlocModule {
  BlocModule._();

  static void init() {
    final injector = Injector.instance;

    injector.registerFactory<StoryBloc>(
      () => StoryBloc(repository: injector()),
    );
  }
}
