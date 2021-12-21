import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/languages_repo.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/fetch_languages_use_case.dart';

import '../../../../helpers/test_helpers.dart';
import 'fetch_languages_use_case_test.mocks.dart';

@GenerateMocks([LanguagesRepo])
void main() {
  late FetchLanguagesUseCase fetchLanguagesUseCase;
  late MockLanguagesRepo mockLanguagesRepo;

  setUp(() {
    mockLanguagesRepo = MockLanguagesRepo();
    fetchLanguagesUseCase = FetchLanguagesUseCase(languagesRepo: mockLanguagesRepo);
  });

  void setupFetchSuccess() {
    when(mockLanguagesRepo.fetch())
        .thenAnswer((_) async => Right(fetchTestLanguageList()));
  }

  group("Fetch success", () {
    test("Should call fetch method from repository", () async {
      setupFetchSuccess();
      await fetchLanguagesUseCase(const NoParam());
      verify(mockLanguagesRepo.fetch());
    });

    test("should be of type Either<Failure, List<Language>> on success", () async {
      setupFetchSuccess();
      final langList = await fetchLanguagesUseCase(const NoParam());
      expect(langList, isInstanceOf<Either<Failure, List<Language>>>());
    });

    test("isRight should be true on success", () async {
      setupFetchSuccess();
      final Either<Failure, List<Language>> langList =
          await fetchLanguagesUseCase(const NoParam());
      expect(langList.isRight(), isTrue);
    });
  });

  void setupFetchFailure() {
    when(mockLanguagesRepo.fetch()).thenAnswer((_) async => Left(FetchFailure()));
  }

  group("Fetch Failure", () {
    test("isLeft should be true on success", () async {
      setupFetchFailure();
      final Either<Failure, List<Language>> langList =
          await fetchLanguagesUseCase(const NoParam());
      expect(langList.isLeft(), isTrue);
    });
  });
}
