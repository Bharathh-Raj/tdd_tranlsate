import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/translate/domain/translation.dart';

part 'translation_wrapper.freezed.dart';

@freezed
class TranslationWrapper with _$TranslationWrapper {
  const factory TranslationWrapper(
      {required String inputText,
      required String destLangCode,
      required String sourceLangCode,
      required Translation translation,
      Language? sourceLang,
      Language? destLang}) = _TranslationWrapper;
}
