import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/lang_detection.dart';

part 'detect_languages_state.freezed.dart';

@freezed
class DetectLanguagesState with _$DetectLanguagesState {
  const factory DetectLanguagesState.initial() = Initial;

  const factory DetectLanguagesState.loading() = Loading;

  const factory DetectLanguagesState.empty() = Empty;

  const factory DetectLanguagesState.detected(
      {required String inputText,
      required List<LangDetection> detectionList}) = Detected;

  const factory DetectLanguagesState.failed(Failure failure) = Failed;
}
