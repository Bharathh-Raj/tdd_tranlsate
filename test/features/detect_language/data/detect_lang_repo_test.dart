import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/detect_language/data/detect_lang_remote_ds.dart';
import 'package:tdd_translate/features/detect_language/data/detect_lang_repo_impl.dart';
import 'package:tdd_translate/features/detect_language/data/detection_model.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/detection.dart';
import 'package:tdd_translate/features/detect_language/domain/repositories/detect_lang_repo.dart';

import 'detect_lang_repo_test.mocks.dart';

@GenerateMocks([DetectLangRemoteDataSource])
void main() {
  late DetectLangRepo detectLangRepo;
  late MockDetectLangRemoteDataSource mockDetectLangRemoteDataSource;

  setUp(() {
    mockDetectLangRemoteDataSource = MockDetectLangRemoteDataSource();
    detectLangRepo =
        DetectLangRepoImpl(detectLangRemoteDataSource: mockDetectLangRemoteDataSource);
  });

  group("detectLang method test", () {
    group("Success Cases", () {
      void setUpLangDetectSuccess() {
        when(mockDetectLangRemoteDataSource.detectLangFor("test")).thenAnswer((_) async =>
            [DetectionModel(language: "en", confidence: 0.5, isReliable: false)]);
      }

      test("detectLangFor method of data source should be called", () async {
        setUpLangDetectSuccess();
        await detectLangRepo.detectLang("test");
        verify(mockDetectLangRemoteDataSource.detectLangFor("test"));
      });

      test("isRight should be true for detection success", () async {
        setUpLangDetectSuccess();
        final Either<Failure, List<Detection>> result =
            await detectLangRepo.detectLang("test");
        expect(result.isRight(), isTrue);
      });

      test("Right should be of type List<Detection> on detection success", () async {
        setUpLangDetectSuccess();
        final Either<Failure, List<Detection>> result =
            await detectLangRepo.detectLang("test");
        expect(result, isInstanceOf<Right<Failure, List<Detection>>>());
      });
    });

    group("Failure cases", () {
      void setUpLangDetectFailure() {
        when(mockDetectLangRemoteDataSource.detectLangFor("test")).thenThrow(Exception());
      }

      test("isLeft should be true on detection failure", () async {
        setUpLangDetectFailure();
        final Either<Failure, List<Detection>> result =
            await detectLangRepo.detectLang("test");
        expect(result.isLeft(), isTrue);
      });

      test("Left should be of type Failure on detection failure", () async {
        setUpLangDetectFailure();
        final Either<Failure, List<Detection>> result =
            await detectLangRepo.detectLang("test");
        expect(result, isInstanceOf<Left<Failure, List<Detection>>>());
      });
    });
  });
}
