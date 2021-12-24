import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/languages_repo.dart';

class GetLangFromCodeUseCase extends UseCase<Language?, String> {
  final LanguagesRepo languagesRepo;

  GetLangFromCodeUseCase({required this.languagesRepo});

  @override
  Future<Language?> call(String param) {
    return Future.value(languagesRepo.getLangFromCode(langCode: param));
  }
}
