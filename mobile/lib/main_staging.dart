import 'package:flutter/widgets.dart';
import 'package:kanca/app/app.dart';
import 'package:kanca/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap(() => const App());
}
