import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/fetch_languages_use_case.dart';
import 'package:tdd_translate/features/supported_languages/presentation/languages_bloc/bloc.dart';

class LanguagesBloc extends Bloc<LanguagesEvent, LanguagesState> {
  final FetchLanguagesUseCase fetchLanguagesUseCase;

  LanguagesBloc({required this.fetchLanguagesUseCase})
      : super(const LanguagesState.initial()) {
    on<LanguagesEvent>((event, emit) async {
      await event.map(fetch: (fetchEvent) async {
        await _mapFetchEventToState(emit);
      });
    });
  }

  Future<void> _mapFetchEventToState(Emitter emit) async {
    final Either<Failure, List<Language>> fetchResult =
        await fetchLanguagesUseCase(const NoParam());
    emit(fetchResult.fold((failure) => LanguagesState.failure(failure),
        (languageList) => LanguagesState.fetched(languageList)));
  }
}
