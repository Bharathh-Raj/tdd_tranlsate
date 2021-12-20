import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/fetch_languages_use_case.dart';
import 'package:tdd_translate/features/supported_languages/presentation/languages_bloc/bloc.dart';

import '../../../../helpers/test_helpers.dart';
import 'languages_bloc_test.mocks.dart';

@GenerateMocks([FetchLanguagesUseCase])
void main() {
  late MockFetchLanguagesUseCase mockFetchLanguagesUseCase;
  late LanguagesBloc languagesBloc;

  setUp(() {
    mockFetchLanguagesUseCase = MockFetchLanguagesUseCase();
    languagesBloc = LanguagesBloc(fetchLanguagesUseCase: mockFetchLanguagesUseCase);
  });

  tearDown(() => languagesBloc.close());

  void setupFetchSuccess() {
    when(mockFetchLanguagesUseCase(const NoParam()))
        .thenAnswer((_) async => Right(fetchTestLanguageList()));
  }

  void setupFetchFailure() {
    when(mockFetchLanguagesUseCase(const NoParam()))
        .thenAnswer((_) async => Left(FetchFailure()));
  }

  test("Initial State should be LanguagesState.initial()", () {
    expect(languagesBloc.state, const LanguagesState.initial());
  });

  test("On fetch event, use case must be called", () async {
    setupFetchSuccess();
    languagesBloc.add(const LanguagesEvent.fetch());
    await untilCalled(mockFetchLanguagesUseCase(const NoParam()));
    verify(mockFetchLanguagesUseCase(const NoParam()));
  });

  blocTest<LanguagesBloc, LanguagesState>(
    'fetched state must be emitted on fetch success',
    build: () => languagesBloc,
    act: (bloc) {
      setupFetchSuccess();
      bloc.add(const LanguagesEvent.fetch());
    },
    expect: () => <LanguagesState>[LanguagesState.fetched(fetchTestLanguageList())],
  );

  blocTest<LanguagesBloc, LanguagesState>(
    'failure state must be emitted on fetch failure',
    build: () => languagesBloc,
    act: (bloc) {
      setupFetchFailure();
      bloc.add(const LanguagesEvent.fetch());
    },
    expect: () => <LanguagesState>[LanguagesState.failure(FetchFailure())],
  );
}
