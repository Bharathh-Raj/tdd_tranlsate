import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/translate/domain/translation.dart';

abstract class TranslateRepo {
  Future<Either<Failure, List<Translation>>> translate({
    required String inputText,
    required String destLangCode,
    String? sourceLangCode,
  });
}
