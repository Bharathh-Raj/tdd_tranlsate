import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> buildMaterialWidget(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      home: child,
    ),
  );
  await tester.pump();
}

Future<void> buildMaterialWidget_BlocProvider<T extends BlocBase>(
    {required WidgetTester tester,
    required T bloc,
    required Widget child}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<T>.value(
        value: bloc,
        child: Scaffold(body: child),
      ),
    ),
  );
  await tester.pump();
}
