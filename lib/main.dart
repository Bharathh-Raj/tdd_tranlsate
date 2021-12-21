import 'package:flutter/material.dart';

import 'app/view/app.dart';
import 'core/locator.dart' as locator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await locator.init();
  runApp(const App());
}
