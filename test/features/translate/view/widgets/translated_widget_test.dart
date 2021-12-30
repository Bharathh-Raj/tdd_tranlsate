import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/supported_languages/data/language_model.dart';
import 'package:tdd_translate/features/translate/data/translation_model.dart';
import 'package:tdd_translate/features/translate/domain/translation_wrapper.dart';
import 'package:tdd_translate/features/translate/view/translate_bloc/bloc.dart';
import 'package:tdd_translate/features/translate/view/widgets/translated_widget.dart';

import '../../../../helpers/buildMaterialWidget.dart';
import 'translated_widget_test.mocks.dart';

@GenerateMocks([TranslateBloc])
void main() {
  late MockTranslateBloc mockBloc;
  late StreamController<TranslateState> stateStreamController;

  setUp(() {
    mockBloc = MockTranslateBloc();
    stateStreamController = StreamController<TranslateState>.broadcast();
    when(mockBloc.stream).thenAnswer((_) => stateStreamController.stream);
  });

  tearDown(() {
    stateStreamController.close();
    mockBloc.close();
  });

  group("Simple cases", () {
    testWidgets("SizedBox should be built on initial State", (tester) async {
      when(mockBloc.state).thenReturn(TranslateState.initial());
      await buildMaterialWidget_BlocProvider<TranslateBloc>(
          tester: tester, bloc: mockBloc, child: TranslatedWidget());
      expect(find.byKey(ValueKey('Translate Initial State')), findsOneWidget);
    });

    testWidgets("CircularProgressIndicator should be built on loading State",
        (tester) async {
      when(mockBloc.state).thenReturn(TranslateState.loading());
      await buildMaterialWidget_BlocProvider<TranslateBloc>(
          tester: tester, bloc: mockBloc, child: TranslatedWidget());
      expect(find.byKey(ValueKey('Translate Loading State')), findsOneWidget);
    });

    testWidgets("Empty text should be built on empty State", (tester) async {
      when(mockBloc.state).thenReturn(TranslateState.empty());
      await buildMaterialWidget_BlocProvider<TranslateBloc>(
          tester: tester, bloc: mockBloc, child: TranslatedWidget());
      expect(find.text("Input text to translate"), findsOneWidget);
    });
  });

  group("Success cases", () {
    void setUpTranslatedState({bool shouldLangBeNull = false}) {
      when(mockBloc.state)
          .thenReturn(TranslateState.translated(translationWrapperList: [
        TranslationWrapper(
          inputText: "test input",
          destLangCode: "ta",
          sourceLangCode: "en",
          translation: TranslationModel(
              translatedText: "சோதனை உள்ளீடு", sourceLangCode: "en"),
          sourceLang: shouldLangBeNull
              ? null
              : LanguageModel(name: "English", language: "en"),
          destLang: shouldLangBeNull
              ? null
              : LanguageModel(name: "Tamil", language: "ta"),
        ),
      ]));
    }

    testWidgets("Title text should be built on translated State",
        (tester) async {
      setUpTranslatedState();
      await buildMaterialWidget_BlocProvider<TranslateBloc>(
          tester: tester, bloc: mockBloc, child: TranslatedWidget());
      expect(find.text('Translated Text'), findsOneWidget);
    });

    testWidgets("Translated text should be built on translated State",
        (tester) async {
      setUpTranslatedState();
      await buildMaterialWidget_BlocProvider<TranslateBloc>(
          tester: tester, bloc: mockBloc, child: TranslatedWidget());
      expect(find.text('சோதனை உள்ளீடு'), findsOneWidget);
    });

    testWidgets("Source text as English should be built on translated State",
        (tester) async {
      setUpTranslatedState();
      await buildMaterialWidget_BlocProvider<TranslateBloc>(
          tester: tester, bloc: mockBloc, child: TranslatedWidget());
      expect(find.byKey(ValueKey("Source is English")), findsOneWidget);
    });

    testWidgets("Dest text as Tamil should be built on translated State",
        (tester) async {
      setUpTranslatedState();
      await buildMaterialWidget_BlocProvider<TranslateBloc>(
          tester: tester, bloc: mockBloc, child: TranslatedWidget());
      expect(find.byKey(ValueKey("Dest is Tamil")), findsOneWidget);
    });

    testWidgets(
        "Source text as en should be built on translated State with lang null",
        (tester) async {
      setUpTranslatedState(shouldLangBeNull: true);
      await buildMaterialWidget_BlocProvider<TranslateBloc>(
          tester: tester, bloc: mockBloc, child: TranslatedWidget());
      expect(find.byKey(ValueKey("Source is en")), findsOneWidget);
    });

    testWidgets(
        "Dest text as ta should be built on translated State with lang null",
        (tester) async {
      setUpTranslatedState(shouldLangBeNull: true);
      await buildMaterialWidget_BlocProvider<TranslateBloc>(
          tester: tester, bloc: mockBloc, child: TranslatedWidget());
      expect(find.byKey(ValueKey("Dest is ta")), findsOneWidget);
    });
  });

  group("Failure cases", () {
    testWidgets("Failure text should be built on failure state",
        (tester) async {
      when(mockBloc.state).thenReturn(TranslateState.failure(FetchFailure()));
      await buildMaterialWidget_BlocProvider<TranslateBloc>(
          tester: tester, bloc: mockBloc, child: TranslatedWidget());
      expect(find.text("Remote Connection Failure"), findsOneWidget);
    });
  });
}
