import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/detect_language/data/detect_lang_remote_ds.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/detection.dart';
import 'package:tdd_translate/features/detect_language/domain/repositories/detect_lang_repo.dart';

class DetectLangRepoImpl implements DetectLangRepo {
  final DetectLangRemoteDataSource detectLangRemoteDataSource;

  DetectLangRepoImpl({required this.detectLangRemoteDataSource});

  @override
  Future<Either<Failure, List<Detection>>> detectLang(String inputText) async {
    try {
      List<Detection> detectionList =
          await detectLangRemoteDataSource.detectLangFor(inputText);
      return Right(detectionList);
    } catch (e) {
      return Left(FetchFailure(errorObject: e));
    }
  }
}
