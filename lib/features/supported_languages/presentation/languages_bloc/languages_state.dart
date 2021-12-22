import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';

part 'languages_state.freezed.dart';

@freezed
class LanguagesState with _$LanguagesState {
  const factory LanguagesState.initial() = _initial;

  const factory LanguagesState.fetched(
      List<Language> languageList, String selectedLangCode) = _fetched;

  const factory LanguagesState.failure(Failure failure) = _failure;
}
