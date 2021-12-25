import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/translate/domain/translation_wrapper.dart';

part 'translate_state.freezed.dart';

@freezed
class TranslateState with _$TranslateState {
  const factory TranslateState.initial() = Initial;

  const factory TranslateState.loading() = _loading;

  const factory TranslateState.translated(
      {required List<TranslationWrapper> translationWrapperList}) = _translated;

  const factory TranslateState.failure(Failure failure) = _failure;
}
