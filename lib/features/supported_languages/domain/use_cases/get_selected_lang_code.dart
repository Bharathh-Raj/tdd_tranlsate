import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/languages_repo.dart';

class GetSelectedLangCodeUseCase implements UseCase<String, NoParam> {
  final LanguagesRepo languagesRepo;

  GetSelectedLangCodeUseCase({required this.languagesRepo});

  @override
  Future<String> call(NoParam param) {
    return Future.value(languagesRepo.getSelectedLanguageCode());
  }
}
