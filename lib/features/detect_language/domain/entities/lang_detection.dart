import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/detection.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';

part 'lang_detection.freezed.dart';

@freezed
class LangDetection with _$LangDetection {
  const factory LangDetection(
      {required Detection detection, required Language? language}) = _LangDetection;
}
