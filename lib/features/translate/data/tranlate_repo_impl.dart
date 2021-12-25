import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/translate/domain/translate_repo.dart';
import 'package:tdd_translate/features/translate/domain/translation.dart';

import 'data_source/remote_translate_ds.dart';

class TranslateRepoImpl implements TranslateRepo {
  final RemoteTranslateDS remoteTranslateDS;

  TranslateRepoImpl({required this.remoteTranslateDS});

  @override
  Future<Either<Failure, List<Translation>>> translate(
      {required String inputText,
      required String destLangCode,
      String? sourceLangCode}) async {
    try {
      final List<Translation> translationList = await remoteTranslateDS.translate(
          inputText: inputText,
          destLangCode: destLangCode,
          sourceLangCode: sourceLangCode);
      return Right(translationList);
    } catch (e) {
      return Left(FetchFailure(errorObject: e));
    }
  }
}
