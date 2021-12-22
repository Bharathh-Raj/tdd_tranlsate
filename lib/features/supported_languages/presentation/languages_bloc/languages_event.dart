import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'languages_event.freezed.dart';

@freezed
class LanguagesEvent with _$LanguagesEvent {
  const factory LanguagesEvent.fetch() = _fetch;

  const factory LanguagesEvent.putSelectedLang(String selectedLang) = _putSelectedLang;
}
