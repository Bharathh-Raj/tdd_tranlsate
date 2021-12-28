import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/translate/data/translation_model.dart';
import 'package:tdd_translate/features/translate/domain/translate_repo.dart';
import 'package:tdd_translate/features/translate/domain/translate_use_case.dart';
import 'package:tdd_translate/features/translate/domain/translation.dart';

import 'translate_use_case_test.mocks.dart';

@GenerateMocks([TranslateRepo])
void main() {
  late TranslateUseCase translateUseCase;
  late MockTranslateRepo mockTranslateRepo;

  setUp(() {
    mockTranslateRepo = MockTranslateRepo();
    translateUseCase = TranslateUseCase(translateRepo: mockTranslateRepo);
  });

  group("Success cases", () {
    void setUpTranslateSuccess() {
      when(mockTranslateRepo.translate(
              inputText: "test", destLangCode: "ta", sourceLangCode: null))
          .thenAnswer((_) async => Right([
                TranslationModel(translatedText: "சோதனை", sourceLangCode: "en")
              ]));
    }

    test("Should call translate() method from repo", () async {
      setUpTranslateSuccess();
      await translateUseCase(TranslationParam(
          inputText: "test", destLangCode: "ta", sourceLangCode: null));
      verify(mockTranslateRepo.translate(
          inputText: "test", destLangCode: "ta", sourceLangCode: null));
    });

    test("isRight should be true on translate success", () async {
      setUpTranslateSuccess();
      final Either<Failure, List<Translation>> result = await translateUseCase(
          TranslationParam(
              inputText: "test", destLangCode: "ta", sourceLangCode: null));
      expect(result.isRight(), isTrue);
    });

    test("Should be of type Translation on translate success", () async {
      setUpTranslateSuccess();
      final Either<Failure, List<Translation>> result = await translateUseCase(
          TranslationParam(
              inputText: "test", destLangCode: "ta", sourceLangCode: null));
      expect(result, isInstanceOf<Right<Failure, List<Translation>>>());
    });
  });

  group("Failure cases", () {
    void setUpTranslateFailure() {
      when(mockTranslateRepo.translate(
              inputText: "test", destLangCode: "ta", sourceLangCode: null))
          .thenAnswer((_) async => Left(FetchFailure()));
    }

    test("isLeft should be true on translate failure", () async {
      setUpTranslateFailure();
      final Either<Failure, List<Translation>> result = await translateUseCase(
          TranslationParam(
              inputText: "test", destLangCode: "ta", sourceLangCode: null));
      expect(result.isLeft(), isTrue);
    });

    test("Should be of type Failure on translate failure", () async {
      setUpTranslateFailure();
      final Either<Failure, List<Translation>> result = await translateUseCase(
          TranslationParam(
              inputText: "test", destLangCode: "ta", sourceLangCode: null));
      expect(result, isInstanceOf<Left<Failure, List<Translation>>>());
    });
  });
}
