import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/detection.dart';
import 'package:tdd_translate/features/detect_language/domain/use_cases/detect_lang_use_case.dart';

import 'bloc.dart';

class DetectLanguagesBloc extends Bloc<DetectLanguagesEvent, DetectLanguagesState> {
  final DetectLangUseCase detectLangUseCase;

  DetectLanguagesBloc({required this.detectLangUseCase})
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
    Either<Failure, List<Detection>> detectionList = await detectLangUseCase(inputText);
    emit(detectionList.fold((l) => DetectLanguagesState.failed(l),
        (r) => DetectLanguagesState.detected(inputText: inputText, detectionList: r)));
  }
}
