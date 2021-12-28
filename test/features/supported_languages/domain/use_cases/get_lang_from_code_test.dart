import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/features/supported_languages/data/language_model.dart';
import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/languages_repo.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/get_lang_from_code_use_case.dart';

import 'get_lang_from_code_test.mocks.dart';

@GenerateMocks([LanguagesRepo])
void main() {
  late GetLangFromCodeUseCase getLangFromCodeUseCase;
  late MockLanguagesRepo mockLanguagesRepo;

  setUp(() {
    mockLanguagesRepo = MockLanguagesRepo();
    getLangFromCodeUseCase =
        GetLangFromCodeUseCase(languagesRepo: mockLanguagesRepo);
  });

  group("Success Cases", () {
    setUpSuccess() {
      when(mockLanguagesRepo.getLangFromCode(langCode: "en"))
          .thenReturn(const LanguageModel(language: "en", name: "English"));
    }

    test("Should call getLangFromCode() method from repo", () async {
      setUpSuccess();
      await getLangFromCodeUseCase("en");
      verify(mockLanguagesRepo.getLangFromCode(langCode: "en"));
    });

    test("Language instance should be true on successful fetch", () async {
      setUpSuccess();
      Language? result = await getLangFromCodeUseCase("en");
      expect(result, isInstanceOf<Language>());
    });
  });

  group("Failure cases", () {
    setUpFailure() {
      when(mockLanguagesRepo.getLangFromCode(langCode: "en")).thenReturn(null);
    }

    test("null should be returned on failure get", () async {
      setUpFailure();
      Language? result = await getLangFromCodeUseCase("en");
      expect(result, isNull);
    });
  });
}
