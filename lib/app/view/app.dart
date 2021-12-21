import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_translate/core/locator.dart';
import 'package:tdd_translate/features/supported_languages/presentation/languages_bloc/bloc.dart';
import 'package:tdd_translate/features/translate/view/pages/search_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TDD Translate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<LanguagesBloc>(
          create: (context) => LanguagesBloc(fetchLanguagesUseCase: locator())
            ..add(const LanguagesEvent.fetch()),
          child: const SearchPage()),
    );
  }
}
