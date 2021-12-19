import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/supported_languages/data/local/data_sources/supported_languages_local_data_source.dart';
import 'package:tdd_translate/features/supported_languages/data/remote/data_sources/supported_languages_remote_data_source.dart';
import 'package:tdd_translate/features/supported_languages/data/remote/models/language_model.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/supported_languages_repo.dart';

class SupportedLanguagesRepoImpl implements SupportedLanguagesRepo {
  final SupportedLanguagesRemoteDataSource remoteDataSource;
  final SupportedLanguagesLocalDataSource localDataSource;

  SupportedLanguagesRepoImpl({required this.remoteDataSource, required this.localDataSource});

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
      return await _localFetch();
    }
  }

  Future<Either<Failure, List<Language>>> _localFetch() async {
    try {
      List<Language> localLanguageList = await localDataSource.fetch();
      return Right(localLanguageList);
    } catch (e) {
      return Left(FetchFailure());
    }
  }
}
