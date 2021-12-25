import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_translate/core/locator.dart';
import 'package:tdd_translate/features/detect_language/presentation/detect_languages_bloc/bloc.dart';
import 'package:tdd_translate/features/supported_languages/presentation/languages_bloc/bloc.dart';
import 'package:tdd_translate/features/translate/view/pages/search_page.dart';
import 'package:tdd_translate/features/translate/view/translate_bloc/bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TDD Translate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(providers: [
        BlocProvider<LanguagesBloc>(
          create: (context) => LanguagesBloc(
              fetchLanguagesUseCase: locator(),
              getSelectedLangCodeUseCase: locator(),
              putSelectedLangCodeUseCase: locator())
            ..add(const LanguagesEvent.fetch()),
        ),
        BlocProvider<DetectLanguagesBloc>(
          create: (context) => DetectLanguagesBloc(
              detectLangUseCase: locator(), getLangFromCodeUseCase: locator()),
        ),
        BlocProvider<TranslateBloc>(
          create: (context) => TranslateBloc(
            getLangFromCodeUseCase: locator(),
            translateUseCase: locator(),
          ),
        ),
      ], child: const SearchPage()),
    );
  }
}
