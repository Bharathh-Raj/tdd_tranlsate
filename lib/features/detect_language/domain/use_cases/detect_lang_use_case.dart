import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/detection.dart';
import 'package:tdd_translate/features/detect_language/domain/repositories/detect_lang_repo.dart';

class DetectLangUseCase implements UseCaseWithFailure<List<Detection>, String> {
  final DetectLangRepo detectLangRepo;

  DetectLangUseCase({required this.detectLangRepo});

  @override
  Future<Either<Failure, List<Detection>>> call(String param) async {
    return await detectLangRepo.detectLang(param);
  }
}
