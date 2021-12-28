import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/features/supported_languages/data/language_model.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/get_lang_from_code_use_case.dart';
import 'package:tdd_translate/features/translate/data/translation_model.dart';
import 'package:tdd_translate/features/translate/domain/translate_use_case.dart';
import 'package:tdd_translate/features/translate/domain/translation_wrapper.dart';
import 'package:tdd_translate/features/translate/view/translate_bloc/bloc.dart';

import 'translate_bloc_test.mocks.dart';

@GenerateMocks([TranslateUseCase, GetLangFromCodeUseCase])
void main() {
  late TranslateBloc translateBloc;
  late MockTranslateUseCase mockTranslateUseCase;
  late MockGetLangFromCodeUseCase mockGetLangFromCodeUseCase;

  setUp(() {
    mockTranslateUseCase = MockTranslateUseCase();
    mockGetLangFromCodeUseCase = MockGetLangFromCodeUseCase();
    translateBloc = TranslateBloc(
        translateUseCase: mockTranslateUseCase,
        getLangFromCodeUseCase: mockGetLangFromCodeUseCase);
  });

  tearDown(() {
    translateBloc.close();
  });

  group("translate event", () {
    setUp(() {
      when(mockGetLangFromCodeUseCase("ta")).thenAnswer(
          (_) async => const LanguageModel(language: 'ta', name: "Tamil"));
      when(mockGetLangFromCodeUseCase("en")).thenAnswer(
          (_) async => const LanguageModel(language: 'en', name: "English"));
    });
    group("Basis tests", () {
      void setUpTranslateSuccess() {
        when(mockTranslateUseCase(
                TranslationParam(inputText: "test", destLangCode: "ta")))
            .thenAnswer((_) async => Right([
                  TranslationModel(
                      translatedText: "சோதனை", sourceLangCode: "en")
                ]));
      }

      test("Initial state should be TranslateState.initial", () {
        expect(translateBloc.state, const TranslateState.initial());
      });

      blocTest<TranslateBloc, TranslateState>(
        "useCase must be called on translate event",
        build: () => translateBloc,
        setUp: setUpTranslateSuccess,
        act: (bloc) => bloc.add(const TranslateEvent.translate(
            inputText: "test", destLangCode: "ta")),
        verify: (bloc) => verify(mockTranslateUseCase(
                TranslationParam(inputText: "test", destLangCode: "ta")))
            .called(1),
      );
    });

    group("Success cases", () {
      void setUpTranslateWithAutoSourceSuccess() {
        when(mockTranslateUseCase(
                TranslationParam(inputText: "test", destLangCode: "ta")))
            .thenAnswer((_) async => Right([
                  TranslationModel(
                      translatedText: "சோதனை", sourceLangCode: "en")
                ]));
      }

      blocTest<TranslateBloc, TranslateState>(
        "getLangFromCodeUseCase must be called on translate success",
        build: () => translateBloc,
        setUp: setUpTranslateWithAutoSourceSuccess,
        act: (bloc) => bloc.add(const TranslateEvent.translate(
            inputText: "test", destLangCode: "ta")),
        verify: (bloc) => verify(mockGetLangFromCodeUseCase("en")),
      );

      blocTest<TranslateBloc, TranslateState>(
          "Must yield LoadingState and TranslatedState on translate success",
          build: () => translateBloc,
          setUp: setUpTranslateWithAutoSourceSuccess,
          act: (bloc) => bloc.add(const TranslateEvent.translate(
              inputText: "test", destLangCode: "ta")),
          expect: () => <TranslateState>[
                const TranslateState.loading(),
                TranslateState.translated(translationWrapperList: [
                  TranslationWrapper(
                      inputText: 'test',
                      destLangCode: "ta",
                      sourceLangCode: "en",
                      destLang:
                          const LanguageModel(language: "ta", name: "Tamil"),
                      sourceLang:
                          const LanguageModel(language: "en", name: "English"),
                      translation: TranslationModel(
                          translatedText: "சோதனை", sourceLangCode: "en")),
                ])
              ]);
    });
  });
}
