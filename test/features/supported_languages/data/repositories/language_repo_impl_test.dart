import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/supported_languages/data/language_model.dart';
import 'package:tdd_translate/features/supported_languages/data/local/data_sources/languages_local_data_source.dart';
import 'package:tdd_translate/features/supported_languages/data/remote/data_sources/languages_remote_data_source.dart';
import 'package:tdd_translate/features/supported_languages/data/repositories/language_repo_impl.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/languages_repo.dart';

import '../../../../helpers/test_helpers.dart';
import 'language_repo_impl_test.mocks.dart';

@GenerateMocks([LanguagesRemoteDataSource, LanguagesLocalDataSource])
void main() {
  late LanguagesRepo languagesRepo;
  late MockLanguagesRemoteDataSource remoteDataSource;
  late MockLanguagesLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = MockLanguagesRemoteDataSource();
    localDataSource = MockLanguagesLocalDataSource();
    languagesRepo = LanguagesRepoImpl(
        remoteDataSource: remoteDataSource, localDataSource: localDataSource);
  });

  void setUpRemoteFetchSuccess() {
    when(remoteDataSource.fetch())
        .thenAnswer((realInvocation) async => fetchTestLanguageList());
  }

  group("Fetch - Success Cases", () {
    test("Should call fetch from remote data source", () async {
      setUpRemoteFetchSuccess();
      await languagesRepo.fetch();
      verify(remoteDataSource.fetch());
    });
    test("Should return value with type Either<Failure, List<Language>>",
        () async {
      setUpRemoteFetchSuccess();
      final langList = await languagesRepo.fetch();
      expect(langList, isInstanceOf<Either<Failure, List<Language>>>());
    });
    test("isRight should be true when success", () async {
      setUpRemoteFetchSuccess();
      final Either<Failure, List<Language>> langList =
          await languagesRepo.fetch();
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
        final Either<Failure, List<Language>> langList =
            await languagesRepo.fetch();
        langList.fold((l) => expect(langList.isLeft(), isFalse),
            (r) => verify(localDataSource.write(r as List<LanguageModel>)));
      });

      test("Should not return anything on localWrite succeeds", () async {
        setUpRemoteFetchSuccess();
        setUpLocalWriteSuccess();
        final Either<Failure, List<Language>> langList =
            await languagesRepo.fetch();
        langList.fold(
            (l) => expect(langList.isLeft(), isFalse),
            (r) => expect(localDataSource.write(r as List<LanguageModel>),
                isInstanceOf<Future<void>>()));
      });

      test("LocalWrite failure should not affect the language list return",
          () async {
        setUpRemoteFetchSuccess();
        setUpLocalWriteFailure();
        final Either<Failure, List<Language>> langList =
            await languagesRepo.fetch();
        expect(langList.isRight(), isTrue);
      });
    });
  });

  void setUpRemoteFetchFailure() {
    when(remoteDataSource.fetch()).thenThrow(Exception());
    when(localDataSource.fetch()).thenReturn(fetchTestLanguageList());
  }

  void setUpRemoteFetchFailureLocalFetchNull() {
    when(remoteDataSource.fetch()).thenThrow(Exception());
    when(localDataSource.fetch()).thenReturn(null);
  }

  group("Remote Fetch Failure", () {
    test("Remote Fetch Failure triggers local fetch", () async {
      setUpRemoteFetchFailure();
      await languagesRepo.fetch();
      verify(localDataSource.fetch());
    });

    test("Local Fetch should be of type Either<Failure, List<Language>>",
        () async {
      setUpRemoteFetchFailure();
      final Either<Failure, List<Language>> langList =
          await languagesRepo.fetch();
      expect(langList, isInstanceOf<Either<Failure, List<Language>>>());
    });

    test(
        "isRight should be true on remote fetch failure but local fetch succeeds",
        () async {
      setUpRemoteFetchFailure();
      final Either<Failure, List<Language>> langList =
          await languagesRepo.fetch();
      expect(langList.isRight(), isTrue);
    });

    test(
        "isLeft should be true on remote fetch failure and local fetch is null",
        () async {
      setUpRemoteFetchFailureLocalFetchNull();
      final Either<Failure, List<Language>> langList =
          await languagesRepo.fetch();
      expect(langList.isLeft(), isTrue);
    });
  });

  void setUpRemoteAndLocalFetchFailure() {
    when(remoteDataSource.fetch()).thenThrow(Exception());
    when(localDataSource.fetch()).thenThrow(Exception());
  }

  group("Remote and Local Fetch Failure", () {
    test("isLeft should be true on both remote and local fetch failure",
        () async {
      setUpRemoteAndLocalFetchFailure();
      final Either<Failure, List<Language>> langList =
          await languagesRepo.fetch();
      expect(langList.isLeft(), isTrue);
    });
  });

  group("getSelectedLanguageCode()", () {
    test("getSelectedLanguageCode() of localDataSource should be called", () {
      languagesRepo.getSelectedLanguageCode();
      verify(localDataSource.getSelectedLanguageCode());
    });

    test("Default langCode should be english", () {
      expect(languagesRepo.defaultLangCode, "en");
    });

    void setUpGetSelectedLangSuccess() {
      when(localDataSource.getSelectedLanguageCode()).thenReturn("en");
    }

    test("en should be returned on fetch success", () {
      setUpGetSelectedLangSuccess();
      final String langList = languagesRepo.getSelectedLanguageCode();
      expect(langList, "en");
    });

    void setUpGetSelectedLangNull() {
      when(localDataSource.getSelectedLanguageCode()).thenReturn(null);
    }

    test("en should be returned on fetch null", () {
      setUpGetSelectedLangNull();
      final String langList = languagesRepo.getSelectedLanguageCode();
      expect(langList, "en");
    });

    void setUpGetSelectedLangFailure() {
      when(localDataSource.getSelectedLanguageCode()).thenThrow(Exception());
    }

    test("en should be returned on fetch failure", () {
      setUpGetSelectedLangFailure();
      final String langList = languagesRepo.getSelectedLanguageCode();
      expect(langList, "en");
    });
  });

  group("putSelectedLanguageCode", () {
    test("putSelectedLanguageCode() of localDataSource must be called", () {
      languagesRepo.putSelectedLanguageCode(langCode: "en");
      verify(localDataSource.putSelectedLanguageCode(langCode: "en"));
    });

    void setUpPutSelectedLangSuccess() {
      when(localDataSource.putSelectedLanguageCode(langCode: "en"))
          .thenAnswer((_) async {});
    }

    test("isRight should be true on successful fetch", () async {
      setUpPutSelectedLangSuccess();
      Either<Failure, void> selectedLangCode =
          await languagesRepo.putSelectedLanguageCode(langCode: "en");
      expect(selectedLangCode.isRight(), isTrue);
    });

    test("Right(Unit) should be returned on successful fetch", () async {
      setUpPutSelectedLangSuccess();
      Either<Failure, void> selectedLangCode =
          await languagesRepo.putSelectedLanguageCode(langCode: "en");
      expect(selectedLangCode, const Right(Unit));
    });

    void setUpPutSelectedLangFailure() {
      when(localDataSource.putSelectedLanguageCode(langCode: "en"))
          .thenThrow(Exception());
    }

    test("isLeft should be true on failure fetch", () async {
      setUpPutSelectedLangFailure();
      Either<Failure, void> selectedLangCode =
          await languagesRepo.putSelectedLanguageCode(langCode: "en");
      expect(selectedLangCode.isLeft(), isTrue);
    });
  });

  group("getLangFromCode() method test", () {
    void setUpLocalFetchSuccess() {
      when(localDataSource.fetch()).thenReturn(fetchTestLanguageList());
    }

    void setUpLocalFetchNull() {
      when(localDataSource.fetch()).thenReturn(null);
    }

    test("fetch() method from localDataSource must be called", () {
      setUpLocalFetchSuccess();
      languagesRepo.getLangFromCode(langCode: "en");
      verify(localDataSource.fetch());
    });

    test("Language should be returned on successful match", () {
      setUpLocalFetchSuccess();
      final Language? lang = languagesRepo.getLangFromCode(langCode: "en");
      expect(lang, const LanguageModel(name: "English", language: "en"));
    });

    test("null should be returned when lang", () {
      setUpLocalFetchNull();
      final Language? lang = languagesRepo.getLangFromCode(langCode: "test");
      expect(lang, isNull);
    });
  });
}
