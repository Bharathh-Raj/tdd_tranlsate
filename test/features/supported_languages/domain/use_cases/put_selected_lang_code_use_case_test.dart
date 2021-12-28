import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/languages_repo.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/put_selected_lang_code_use_case.dart';

import 'get_selected_lang_code_test.mocks.dart';

@GenerateMocks([LanguagesRepo])
void main() {
  late MockLanguagesRepo mockLanguagesRepo;
  late PutSelectedLangCodeUseCase putSelectedLangCodeUseCase;

  setUp(() {
    mockLanguagesRepo = MockLanguagesRepo();
    putSelectedLangCodeUseCase =
        PutSelectedLangCodeUseCase(languagesRepo: mockLanguagesRepo);
  });

  group("Success Cases", () {
    void setUpPutSuccess() {
      when(mockLanguagesRepo.putSelectedLanguageCode(langCode: "en"))
          .thenAnswer((_) async => const Right(Unit));
    }

    test("putSelectedLanguageCode() from languagesRepo should be called", () {
      setUpPutSuccess();
      putSelectedLangCodeUseCase("en");
      verify(mockLanguagesRepo.putSelectedLanguageCode(langCode: "en"));
    });

    test("isRight should be true on put success", () async {
      setUpPutSuccess();
      Either<Failure, void> selectedLang =
          await putSelectedLangCodeUseCase("en");
      expect(selectedLang.isRight(), isTrue);
    });

    test("isRight(Unit) should be returned on put success", () async {
      setUpPutSuccess();
      Either<Failure, void> selectedLang =
          await putSelectedLangCodeUseCase("en");
      expect(selectedLang, const Right(Unit));
    });
  });
  group("Failure cases", () {
    void setUpFetchFailure() {
      when(mockLanguagesRepo.putSelectedLanguageCode(langCode: "en"))
          .thenAnswer((_) async => Left(FetchFailure()));
    }

    test("isLeft should be returned on failure case", () async {
      setUpFetchFailure();
      Either<Failure, void> selectedLang =
          await putSelectedLangCodeUseCase("en");
      expect(selectedLang.isLeft(), isTrue);
    });
  });
}
