import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/detection.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/lang_detection.dart';
import 'package:tdd_translate/features/detect_language/domain/use_cases/detect_lang_use_case.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/get_lang_from_code_use_case.dart';

import 'bloc.dart';

class DetectLanguagesBloc
    extends Bloc<DetectLanguagesEvent, DetectLanguagesState> {
  final DetectLangUseCase detectLangUseCase;
  final GetLangFromCodeUseCase getLangFromCodeUseCase;

  DetectLanguagesBloc(
      {required this.detectLangUseCase, required this.getLangFromCodeUseCase})
      : super(const DetectLanguagesState.initial()) {
    on<DetectLanguagesEvent>((event, emit) async {
      await event.map(
        detect: (value) async {
          emit(const DetectLanguagesState.loading());
          await mapDetectEventToState(value.inputText, emit);
        },
      );
    });
  }

  Future<void> mapDetectEventToState(String inputText, Emitter emit) async {
    if (inputText.isEmpty) {
      emit(const DetectLanguagesState.empty());
      return;
    }
    Either<Failure, List<Detection>> detectionList =
        await detectLangUseCase(inputText);
    emit(await detectionList.fold((l) => DetectLanguagesState.failed(l),
        (r) async {
      final List<LangDetection> langDetectionList = [];
      for (Detection det in r) {
        final Language? lang = await getLangFromCodeUseCase(det.langCode);
        langDetectionList.add(LangDetection(detection: det, language: lang));
      }
      return DetectLanguagesState.detected(
          inputText: inputText, detectionList: langDetectionList);
    }));
  }
}
