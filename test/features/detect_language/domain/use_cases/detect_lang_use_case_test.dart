import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/detect_language/data/detection_model.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/detection.dart';
import 'package:tdd_translate/features/detect_language/domain/repositories/detect_lang_repo.dart';
import 'package:tdd_translate/features/detect_language/domain/use_cases/detect_lang_use_case.dart';

import 'detect_lang_use_case_test.mocks.dart';

@GenerateMocks([DetectLangRepo])
void main() {
  late DetectLangUseCase detectLangUseCase;
  late MockDetectLangRepo mockDetectLangRepo;

  setUp(() {
    mockDetectLangRepo = MockDetectLangRepo();
    detectLangUseCase = DetectLangUseCase(detectLangRepo: mockDetectLangRepo);
  });

  group("Success Cases", () {
    setUpDetectSuccess() {
      when(mockDetectLangRepo.detectLang("test")).thenAnswer((_) async =>
          Right([DetectionModel(isReliable: true, confidence: 1, language: "en")]));
    }

    test("detectLang method from langRepo must be called", () async {
      setUpDetectSuccess();
      await detectLangUseCase("test");
      verify(mockDetectLangRepo.detectLang("test"));
    });

    test("If succeeds, isRight should be true", () async {
      setUpDetectSuccess();
      Either<Failure, List<Detection>> result = await detectLangUseCase("test");
      expect(result.isRight(), isTrue);
    });

    test("If succeeds, return type should be List<Detection>", () async {
      setUpDetectSuccess();
      Either<Failure, List<Detection>> result = await detectLangUseCase("test");
      expect(result, isInstanceOf<Right<Failure, List<Detection>>>());
    });
  });

  group("Failure Cases", () {
    setUpDetectFailure() {
      when(mockDetectLangRepo.detectLang("test"))
          .thenAnswer((_) async => Left(FetchFailure()));
    }

    test("isLeft should be true on failure", () async {
      setUpDetectFailure();
      Either<Failure, List<Detection>> result = await detectLangUseCase("test");
      expect(result.isLeft(), isTrue);
    });

    test("return type should be Failure on failure", () async {
      setUpDetectFailure();
      Either<Failure, List<Detection>> result = await detectLangUseCase("test");
      expect(result, isInstanceOf<Left<Failure, List<Detection>>>());
    });
  });
}
