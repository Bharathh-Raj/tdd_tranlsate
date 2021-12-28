import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/fetch_languages_use_case.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/get_selected_lang_code.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/put_selected_lang_code_use_case.dart';
import 'package:tdd_translate/features/supported_languages/presentation/languages_bloc/bloc.dart';

import '../../../../helpers/test_helpers.dart';
import 'languages_bloc_test.mocks.dart';

@GenerateMocks([
  FetchLanguagesUseCase,
  GetSelectedLangCodeUseCase,
  PutSelectedLangCodeUseCase
])
void main() {
  late MockFetchLanguagesUseCase mockFetchLanguagesUseCase;
  late MockGetSelectedLangCodeUseCase mockGetSelectedLangCodeUseCase;
  late MockPutSelectedLangCodeUseCase mockPutSelectedLangCodeUseCase;
  late LanguagesBloc languagesBloc;

  setUp(() {
    mockFetchLanguagesUseCase = MockFetchLanguagesUseCase();
    mockGetSelectedLangCodeUseCase = MockGetSelectedLangCodeUseCase();
    mockPutSelectedLangCodeUseCase = MockPutSelectedLangCodeUseCase();
    languagesBloc = LanguagesBloc(
        fetchLanguagesUseCase: mockFetchLanguagesUseCase,
        getSelectedLangCodeUseCase: mockGetSelectedLangCodeUseCase,
        putSelectedLangCodeUseCase: mockPutSelectedLangCodeUseCase);
  });

  tearDown(() => languagesBloc.close());

  void setupFetchSuccess() {
    when(mockFetchLanguagesUseCase(const NoParam()))
        .thenAnswer((_) async => Right(fetchTestLanguageList()));
  }

  void setUpSelectedLang() {
    when(mockGetSelectedLangCodeUseCase(const NoParam()))
        .thenAnswer((_) async => "en");
  }

  void setupFetchFailure() {
    when(mockFetchLanguagesUseCase(const NoParam()))
        .thenAnswer((_) async => Left(FetchFailure()));
  }

  group("Fetch event", () {
    test("Initial State should be LanguagesState.initial()", () {
      expect(languagesBloc.state, const LanguagesState.initial());
    });

    test("On fetch event, languagesFetchUseCase must be called", () async {
      setupFetchSuccess();
      setUpSelectedLang();
      languagesBloc.add(const LanguagesEvent.fetch());
      await untilCalled(mockFetchLanguagesUseCase(const NoParam()));
      verify(mockFetchLanguagesUseCase(const NoParam()));
    });

    test("On fetch event, getSelectedLangUseCase must be called", () async {
      setupFetchSuccess();
      setUpSelectedLang();
      languagesBloc.add(const LanguagesEvent.fetch());
      await untilCalled(mockGetSelectedLangCodeUseCase(const NoParam()));
      verify(mockGetSelectedLangCodeUseCase(const NoParam()));
    });

    blocTest<LanguagesBloc, LanguagesState>(
      'fetched state must be emitted on fetch success',
      build: () => languagesBloc,
      act: (bloc) {
        setupFetchSuccess();
        setUpSelectedLang();
        bloc.add(const LanguagesEvent.fetch());
      },
      expect: () => <LanguagesState>[
        LanguagesState.fetched(fetchTestLanguageList(), "en")
      ],
    );

    blocTest<LanguagesBloc, LanguagesState>(
      'failure state must be emitted on fetch failure',
      build: () => languagesBloc,
      act: (bloc) {
        setupFetchFailure();
        setUpSelectedLang();
        bloc.add(const LanguagesEvent.fetch());
      },
      expect: () => <LanguagesState>[LanguagesState.failure(FetchFailure())],
    );
  });

  group("PutSelectedLang event", () {
    setUpPutSelectedLangSuccess() {
      when(mockPutSelectedLangCodeUseCase("en"))
          .thenAnswer((_) async => const Right(Unit));
    }

    test("On PutSelectedLangEvent, putSelectedLangUseCase must be called",
        () async {
      setUpPutSelectedLangSuccess();
      languagesBloc.add(const LanguagesEvent.putSelectedLang("en"));
      await untilCalled(mockPutSelectedLangCodeUseCase("en"));
      verify(mockPutSelectedLangCodeUseCase("en"));
    });

    //TODO: Test putSelectedLangEvent
  });
}
