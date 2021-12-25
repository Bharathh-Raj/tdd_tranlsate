import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/get_lang_from_code_use_case.dart';
import 'package:tdd_translate/features/translate/domain/translate_use_case.dart';
import 'package:tdd_translate/features/translate/domain/translation.dart';
import 'package:tdd_translate/features/translate/domain/translation_wrapper.dart';

import 'bloc.dart';

class TranslateBloc extends Bloc<TranslateEvent, TranslateState> {
  final TranslateUseCase translateUseCase;
  final GetLangFromCodeUseCase getLangFromCodeUseCase;

  TranslateBloc({required this.translateUseCase, required this.getLangFromCodeUseCase})
      : super(const TranslateState.initial()) {
    on<TranslateEvent>((event, emit) async {
      await event.map(
        translate: (value) async {
          emit(const TranslateState.loading());
          await _mapTranslateEventToState(value, emit);
        },
      );
    });
  }

  Future<void> _mapTranslateEventToState(event, Emitter<TranslateState> emit) async {
    final Either<Failure, List<Translation>> translateResult = await translateUseCase(
        TranslationParam(
            inputText: event.inputText,
            destLangCode: event.destLangCode,
            sourceLangCode: event.sourceLangCode));

    emit(await translateResult.fold((l) => TranslateState.failure(l), (r) async {
      final List<TranslationWrapper> translationWrapperList = [];
      for (Translation translation in r) {
        translationWrapperList.add(await getTranslationWrapper(
            translation: translation,
            inputText: event.inputText,
            destLangCode: event.destLangCode,
            inpLangCode: event.sourceLangCode));
      }
      return TranslateState.translated(translationWrapperList: translationWrapperList);
    }));
  }

  Future<TranslationWrapper> getTranslationWrapper(
      {required Translation translation,
      required String inputText,
      required String destLangCode,
      String? inpLangCode}) async {
    final String? sourceLangCode = inpLangCode ?? translation.sourceLangCode;
    final Language? sourceLang = await getLangFromCodeUseCase(sourceLangCode!);
    final Language? destLang = await getLangFromCodeUseCase(destLangCode);

    final TranslationWrapper translationWrapper = TranslationWrapper(
      inputText: inputText,
      destLangCode: destLangCode,
      sourceLangCode: sourceLangCode,
      translation: translation,
      sourceLang: sourceLang,
      destLang: destLang,
    );

    return translationWrapper;
  }
}
