import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'translate_event.freezed.dart';

@freezed
class TranslateEvent with _$TranslateEvent {
  const factory TranslateEvent.translate(
      {required String inputText,
      required String destLangCode,
      String? sourceLangCode}) = Translate;
}
