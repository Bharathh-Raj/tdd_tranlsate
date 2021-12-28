import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';

abstract class LanguagesRepo {
  Future<Either<Failure, List<Language>>> fetch();

  String getSelectedLanguageCode();

  Future<Either<Failure, void>> putSelectedLanguageCode(
      {required String langCode});

  Language? getLangFromCode({required String langCode});

  String get defaultLangCode;
}
