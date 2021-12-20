import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/fetch_languages_use_case.dart';
import 'package:tdd_translate/features/supported_languages/presentation/languages_bloc/bloc.dart';

import 'languages_event.dart';
import 'languages_state.dart';

class LanguagesBloc extends Bloc<LanguagesEvent, LanguagesState> {
  final FetchLanguagesUseCase fetchLanguagesUseCase;

  LanguagesBloc({required this.fetchLanguagesUseCase})
      : super(const LanguagesState.initial()) {
    on<LanguagesEvent>((event, emit) {
      event.map(fetch: (fetchEvent) async {
        emit(await _mapFetchEventToState());
      });
    });
  }

  Future<LanguagesState> _mapFetchEventToState() async {
    final Either<Failure, List<Language>> fetchResult =
        await fetchLanguagesUseCase(const NoParam());
    return fetchResult.fold((failure) => LanguagesState.failure(failure),
        (languageList) => LanguagesState.fetched(languageList));
  }
}
