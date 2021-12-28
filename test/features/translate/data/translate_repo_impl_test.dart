import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/translate/data/data_source/remote_translate_ds.dart';
import 'package:tdd_translate/features/translate/data/tranlate_repo_impl.dart';
import 'package:tdd_translate/features/translate/data/translation_model.dart';
import 'package:tdd_translate/features/translate/domain/translate_repo.dart';
import 'package:tdd_translate/features/translate/domain/translation.dart';

import 'translate_repo_impl_test.mocks.dart';

@GenerateMocks([RemoteTranslateDS])
void main() {
  late TranslateRepo translateRepo;
  late MockRemoteTranslateDS mockRemoteTranslateDS;

  setUp(() {
    mockRemoteTranslateDS = MockRemoteTranslateDS();
    translateRepo = TranslateRepoImpl(remoteTranslateDS: mockRemoteTranslateDS);
  });

  group("translate() method", () {
    group("Basic cases", () {
      void setUpSuccessFetch() {
        when(mockRemoteTranslateDS.translate(
                inputText: "test", destLangCode: "en"))
            .thenAnswer(
                (_) async => [TranslationModel(translatedText: "test")]);
      }

      test("RemoteTranslateDS translate() method must be called", () async {
        setUpSuccessFetch();
        await translateRepo.translate(inputText: "test", destLangCode: "en");
        verify(mockRemoteTranslateDS.translate(
            inputText: "test", destLangCode: "en"));
      });
    });

    group("Success cases", () {
      void setUpSuccessFetch() {
        when(mockRemoteTranslateDS.translate(
                inputText: "test", destLangCode: "en"))
            .thenAnswer(
                (_) async => [TranslationModel(translatedText: "test")]);
      }

      test("isRight should be true for successful translate", () async {
        setUpSuccessFetch();
        Either<Failure, List<Translation>> result = await translateRepo
            .translate(inputText: "test", destLangCode: "en");
        expect(result.isRight(), isTrue);
      });

      test("isRight should be of type Translation on success translate",
          () async {
        setUpSuccessFetch();
        Either<Failure, List<Translation>> result = await translateRepo
            .translate(inputText: "test", destLangCode: "en");
        expect(result, isInstanceOf<Right<Failure, List<Translation>>>());
      });
    });

    group("Failure cases", () {
      void setUpFailureFetch() {
        when(mockRemoteTranslateDS.translate(
                inputText: "test", destLangCode: "en"))
            .thenThrow(Exception());
      }

      test("isLeft should be true for failure translate", () async {
        setUpFailureFetch();
        Either<Failure, List<Translation>> result = await translateRepo
            .translate(inputText: "test", destLangCode: "en");
        expect(result.isLeft(), isTrue);
      });

      test("isLeft should be of type Translation on failure translate",
          () async {
        setUpFailureFetch();
        Either<Failure, List<Translation>> result = await translateRepo
            .translate(inputText: "test", destLangCode: "en");
        expect(result, isInstanceOf<Left<Failure, List<Translation>>>());
      });
    });
  });
}
