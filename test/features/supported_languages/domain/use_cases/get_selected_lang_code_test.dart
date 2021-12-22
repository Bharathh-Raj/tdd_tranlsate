import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/usecase.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/languages_repo.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/get_selected_lang_code.dart';

import 'get_selected_lang_code_test.mocks.dart';

@GenerateMocks([LanguagesRepo])
void main() {
  late MockLanguagesRepo mockLanguagesRepo;
  late GetSelectedLangCodeUseCase getSelectedLangCodeUseCase;

  setUp(() {
    mockLanguagesRepo = MockLanguagesRepo();
    getSelectedLangCodeUseCase =
        GetSelectedLangCodeUseCase(languagesRepo: mockLanguagesRepo);
  });

  group("Success Cases", () {
    void setUpFetchSuccess() {
      when(mockLanguagesRepo.getSelectedLanguageCode()).thenReturn("en");
    }

    test("getSelectedLanguageCode() from languagesRepo should be called", () {
      setUpFetchSuccess();
      getSelectedLangCodeUseCase(const NoParam());
      verify(mockLanguagesRepo.getSelectedLanguageCode());
    });

    test("en should be returned on fetch success", () async {
      setUpFetchSuccess();
      String selectedLang = await getSelectedLangCodeUseCase(const NoParam());
      expect(selectedLang, "en");
    });
  });
}
