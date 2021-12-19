import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/supported_languages/data/local/data_sources/supported_languages_local_data_source.dart';
import 'package:tdd_translate/features/supported_languages/data/remote/data_sources/supported_languages_remote_data_source.dart';
import 'package:tdd_translate/features/supported_languages/data/remote/models/language_model.dart';
import 'package:tdd_translate/features/supported_languages/data/repositories/supported_language_repo_impl.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/supported_languages_repo.dart';

import '../../../../helpers/test_helpers.dart';
import 'supported_language_repo_impl_test.mocks.dart';

@GenerateMocks([SupportedLanguagesRemoteDataSource, SupportedLanguagesLocalDataSource])
void main() {
  late SupportedLanguagesRepo supportedLanguagesRepo;
  late MockSupportedLanguagesRemoteDataSource remoteDataSource;
  late MockSupportedLanguagesLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = MockSupportedLanguagesRemoteDataSource();
    localDataSource = MockSupportedLanguagesLocalDataSource();
    supportedLanguagesRepo = SupportedLanguagesRepoImpl(
        remoteDataSource: remoteDataSource, localDataSource: localDataSource);
  });

  void setUpRemoteFetchSuccess() {
    when(remoteDataSource.fetch()).thenAnswer((realInvocation) async => fetchTestLanguageList());
  }

  group("Fetch - Success Cases", () {
    test("Should call fetch from remote data source", () async {
      setUpRemoteFetchSuccess();
      await supportedLanguagesRepo.fetch();
      verify(remoteDataSource.fetch());
    });
    test("Should return value with type Either<Failure, List<Language>>", () async {
      setUpRemoteFetchSuccess();
      final langList = await supportedLanguagesRepo.fetch();
      expect(langList, isInstanceOf<Either<Failure, List<Language>>>());
    });
    test("isRight should be true when success", () async {
      setUpRemoteFetchSuccess();
      final Either<Failure, List<Language>> langList = await supportedLanguagesRepo.fetch();
      expect(langList.isRight(), isTrue);
    });

    void setUpLocalWriteSuccess() {
      when(localDataSource.write(any)).thenAnswer((_) async {});
    }

    void setUpLocalWriteFailure() {
      when(localDataSource.write(any)).thenThrow(Exception());
    }

    group("Local Write on Remote Fetch Success", () {
      test("Should call localWrite on remote fetch success", () async {
        setUpRemoteFetchSuccess();
        setUpLocalWriteSuccess();
        final Either<Failure, List<Language>> langList = await supportedLanguagesRepo.fetch();
        langList.fold((l) => expect(langList.isLeft(), isFalse),
            (r) => verify(localDataSource.write(r as List<LanguageModel>)));
      });

      test("Should not return anything on localWrite succeeds", () async {
        setUpRemoteFetchSuccess();
        setUpLocalWriteSuccess();
        final Either<Failure, List<Language>> langList = await supportedLanguagesRepo.fetch();
        langList.fold(
            (l) => expect(langList.isLeft(), isFalse),
            (r) => expect(
                localDataSource.write(r as List<LanguageModel>), isInstanceOf<Future<void>>()));
      });

      test("LocalWrite failure should not affect the language list return", () async {
        setUpRemoteFetchSuccess();
        setUpLocalWriteFailure();
        final Either<Failure, List<Language>> langList = await supportedLanguagesRepo.fetch();
        expect(langList.isRight(), isTrue);
      });
    });
  });

  void setUpRemoteFetchFailure() {
    when(remoteDataSource.fetch()).thenThrow(Exception());
    when(localDataSource.fetch()).thenAnswer((realInvocation) async => fetchTestLanguageList());
  }

  group("Remote Fetch Failure", () {
    test("Remote Fetch Failure triggers local fetch", () async {
      setUpRemoteFetchFailure();
      await supportedLanguagesRepo.fetch();
      verify(localDataSource.fetch());
    });

    test("Local Fetch should be of type Either<Failure, List<Language>>", () async {
      setUpRemoteFetchFailure();
      final Either<Failure, List<Language>> langList = await supportedLanguagesRepo.fetch();
      expect(langList, isInstanceOf<Either<Failure, List<Language>>>());
    });

    test("isRight should be true on remote fetch failure but local fetch succeeds", () async {
      setUpRemoteFetchFailure();
      final Either<Failure, List<Language>> langList = await supportedLanguagesRepo.fetch();
      expect(langList.isRight(), isTrue);
    });
  });

  void setUpRemoteAndLocalFetchFailure() {
    when(remoteDataSource.fetch()).thenThrow(Exception());
    when(localDataSource.fetch()).thenThrow(Exception());
  }

  group("Remote and Local Fetch Failure", () {
    test("isLeft should be true on both remote and local fetch failure", () async {
      setUpRemoteAndLocalFetchFailure();
      final Either<Failure, List<Language>> langList = await supportedLanguagesRepo.fetch();
      expect(langList.isLeft(), isTrue);
    });
  });
}