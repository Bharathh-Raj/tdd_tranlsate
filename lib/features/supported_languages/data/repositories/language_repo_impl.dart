import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/supported_languages/data/language_model.dart';
import 'package:tdd_translate/features/supported_languages/data/local/data_sources/languages_local_data_source.dart';
import 'package:tdd_translate/features/supported_languages/data/remote/data_sources/languages_remote_data_source.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/languages_repo.dart';

class LanguagesRepoImpl implements LanguagesRepo {
  final LanguagesRemoteDataSource remoteDataSource;
  final LanguagesLocalDataSource localDataSource;

  LanguagesRepoImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  String get defaultLangCode => "en";

  @override
  Future<Either<Failure, List<Language>>> fetch() async {
    try {
      List<Language> remoteLanguageList = await remoteDataSource.fetch();
      try {
        await localDataSource.write(remoteLanguageList as List<LanguageModel>);
      } catch (e) {
        log("Local Language List write failure");
      }
      return Right(remoteLanguageList);
    } catch (e) {
      return _localFetch(e);
    }
  }

  Either<Failure, List<Language>> _localFetch(Object e) {
    try {
      //TODO: Is it ok to pass empty list?
      List<Language>? localLanguageList = localDataSource.fetch();
      if (localLanguageList != null) {
        return Right(localLanguageList);
      }
      return Left(FetchFailure(errorObject: e));
    } catch (e) {
      return Left(FetchFailure(errorObject: e));
    }
  }

  @override
  String getSelectedLanguageCode() {
    try {
      final String selectedLangCode =
          localDataSource.getSelectedLanguageCode() ?? defaultLangCode;
      return selectedLangCode;
    } catch (e) {
      return defaultLangCode;
    }
  }

  @override
  Future<Either<Failure, void>> putSelectedLanguageCode(
      {required String langCode}) async {
    try {
      await localDataSource.putSelectedLanguageCode(langCode: langCode);
      return const Right(Unit);
    } catch (e) {
      return Left(FetchFailure(errorObject: e));
    }
  }

  @override
  Language? getLangFromCode({required String langCode}) {
    final List<LanguageModel>? langList = localDataSource.fetch();
    if (langList != null) {
      return langList.firstWhere((lang) => lang.code == langCode);
    }
  }
}
