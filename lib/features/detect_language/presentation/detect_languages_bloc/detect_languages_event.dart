import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'detect_languages_event.freezed.dart';

@freezed
class DetectLanguagesEvent with _$DetectLanguagesEvent {
  const factory DetectLanguagesEvent.detect({required String inputText}) =
      _detect;
}
