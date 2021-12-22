import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/languages_repo.dart';

class PutSelectedLangCodeUseCase implements UseCaseWithFailure<void, String> {
  final LanguagesRepo languagesRepo;

  PutSelectedLangCodeUseCase({required this.languagesRepo});

  @override
  Future<Either<Failure, void>> call(String param) async {
    return await languagesRepo.putSelectedLanguageCode(langCode: param);
  }
}
