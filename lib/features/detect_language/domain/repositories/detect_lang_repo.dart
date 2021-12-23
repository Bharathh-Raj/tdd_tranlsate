import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/detection.dart';

abstract class DetectLangRepo {
  Future<Either<Failure, List<Detection>>> detectLang(String inputText);
}
