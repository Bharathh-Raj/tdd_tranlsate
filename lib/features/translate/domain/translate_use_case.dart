import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/translate/domain/translation.dart';

import 'translate_repo.dart';

class TranslateUseCase
    implements UseCaseWithFailure<List<Translation>, TranslationParam> {
  final TranslateRepo translateRepo;

  TranslateUseCase({required this.translateRepo});

  @override
  Future<Either<Failure, List<Translation>>> call(
      TranslationParam param) async {
    return await translateRepo.translate(
      inputText: param.inputText,
      destLangCode: param.destLangCode,
      sourceLangCode: param.sourceLangCode,
    );
  }
}

class TranslationParam {
  final String inputText;
  final String destLangCode;
  final String? sourceLangCode;

  TranslationParam(
      {required this.inputText,
      required this.destLangCode,
      this.sourceLangCode});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationParam &&
          runtimeType == other.runtimeType &&
          inputText == other.inputText &&
          destLangCode == other.destLangCode &&
          sourceLangCode == other.sourceLangCode;

  @override
  int get hashCode =>
      inputText.hashCode ^ destLangCode.hashCode ^ sourceLangCode.hashCode;
}
