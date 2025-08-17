import 'package:kanca/data/data.dart';

mixin ChatRepository {
  Stream<ChatChunkModel?> chatStream({required String prompt});
}
