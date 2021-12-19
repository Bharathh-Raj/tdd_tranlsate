import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';

abstract class SupportedLanguagesRepo {
  Future<Either<Failure, List<Language>>> fetch();
}
