import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/fetch_languages_use_case.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/get_selected_lang_code.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/put_selected_lang_code_use_case.dart';
import 'package:tdd_translate/features/supported_languages/presentation/languages_bloc/bloc.dart';

class LanguagesBloc extends Bloc<LanguagesEvent, LanguagesState> {
  final FetchLanguagesUseCase fetchLanguagesUseCase;
  final GetSelectedLangCodeUseCase getSelectedLangCodeUseCase;
  final PutSelectedLangCodeUseCase putSelectedLangCodeUseCase;

  LanguagesBloc(
      {required this.fetchLanguagesUseCase,
      required this.getSelectedLangCodeUseCase,
      required this.putSelectedLangCodeUseCase})
      : super(const LanguagesState.initial()) {
    on<LanguagesEvent>((event, emit) async {
      await event.map(
        fetch: (fetchEvent) async {
          await _mapFetchEventToState(emit);
        },
        putSelectedLang: (putSelectedLangEvent) async {
          await _mapPutSelectedLangEventToState(
              putSelectedLangEvent.selectedLang, emit);
        },
      );
    });
  }

  Future<void> _mapFetchEventToState(Emitter emit) async {
    final Either<Failure, List<Language>> fetchResult =
        await fetchLanguagesUseCase(const NoParam());
    final String selectedLang =
        await getSelectedLangCodeUseCase(const NoParam());
    emit(fetchResult.fold((failure) => LanguagesState.failure(failure),
        (languageList) => LanguagesState.fetched(languageList, selectedLang)));
  }

  Future<void> _mapPutSelectedLangEventToState(
      String selectedLang, Emitter emit) async {
    final Either<Failure, void> fetchResult =
        await putSelectedLangCodeUseCase(selectedLang);

    // Previous state should be fetched
    state.maybeWhen(
        fetched: (languageList, selectedLangCode) {
          emit(fetchResult.fold((failure) => LanguagesState.failure(failure),
              (unit) => LanguagesState.fetched(languageList, selectedLang)));
        },
        orElse: () {});
  }
}
