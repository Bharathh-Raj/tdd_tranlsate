import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/languages_repo.dart';

class FetchLanguagesUseCase implements UseCase<List<Language>, NoParam> {
  final LanguagesRepo languagesRepo;

  FetchLanguagesUseCase({required this.languagesRepo});

  @override
  Future<Either<Failure, List<Language>>> call(NoParam param) {
    return languagesRepo.fetch();
  }
}
