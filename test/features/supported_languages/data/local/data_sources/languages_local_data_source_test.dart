import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/features/supported_languages/data/language_model.dart';
import 'package:tdd_translate/features/supported_languages/data/local/data_sources/languages_local_data_source.dart';

import '../../../../../fixtures/fixture_reader.dart';
import 'languages_local_data_source_test.mocks.dart';

@GenerateMocks([Box])
void main() {
  late LanguagesLocalDataSource languagesLocalDataSource;
  late MockBox mockBox;

  final List<Map<String, dynamic>> langListRawMap =
      (fixtureAsMap('supported_languages.json')["data"]["languages"]
              as List<dynamic>)
          .map((rawLang) => rawLang as Map<String, dynamic>)
          .toList();

  setUp(() {
    mockBox = MockBox();
    languagesLocalDataSource = LanguagesLocalDataSourceImpl(hiveBox: mockBox);
  });

  void setUpFetchSuccess() {
    when(mockBox.get(any)).thenReturn(langListRawMap);
  }

  void setUpFetchNull() {
    when(mockBox.get(any)).thenReturn(null);
  }

  group("Fetch", () {
    test("get() should be called from Box object", () {
      setUpFetchSuccess();
      languagesLocalDataSource.fetch();
      verify(mockBox.get(any));
    });

    test("Returns null when nothing is stored", () {
      setUpFetchNull();
      expect(languagesLocalDataSource.fetch(), null);
    });

    test("Should return List<LanguageModel> on fetch success", () {
      setUpFetchSuccess();
      List<LanguageModel>? langListMap = languagesLocalDataSource.fetch();
      expect(langListMap,
          langListRawMap.map((lang) => LanguageModel.fromJson(lang)).toList());
    });
  });

  void setUpWriteSuccess() {
    when(mockBox.put("LangListKey", any)).thenAnswer((_) async {});
  }

  group("Write", () {
    test("put() should be called from Box object", () async {
      setUpWriteSuccess();
      await languagesLocalDataSource.write([]);
      verify(mockBox.put("LangListKey", any));
    });

    test("Should call put after converting LanguageModel to map", () async {
      setUpWriteSuccess();
      const LanguageModel languageModel =
          LanguageModel(name: "Tamil", language: "ta");
      await languagesLocalDataSource.write([languageModel]);
      verify(mockBox.put("LangListKey", [
        {"name": "Tamil", "language": "ta"}
      ]));
    });
  });

  group("GetSelectedLanguageName", () {
    void setUpGetSelectedLangSuccess() {
      when(mockBox.get('SelectedLangCodeKey')).thenReturn("en");
    }

    test("get() should be called", () {
      setUpGetSelectedLangSuccess();
      languagesLocalDataSource.getSelectedLanguageCode();
      verify(mockBox.get('SelectedLangCodeKey'));
    });

    test("LanguageCode should be returned on fetch success", () {
      setUpGetSelectedLangSuccess();
      final String? selectedLangCode =
          languagesLocalDataSource.getSelectedLanguageCode();
      expect(selectedLangCode, "en");
    });

    void setUpNotSelectedAnyLang() {
      when(mockBox.get('SelectedLangCodeKey')).thenReturn(null);
    }

    test("Should return null when no language selected", () {
      setUpNotSelectedAnyLang();
      final String? selectedLangCode =
          languagesLocalDataSource.getSelectedLanguageCode();
      expect(selectedLangCode, null);
    });
  });

  group("PutSelectedLanguageCode", () {
    void setUpWriteSuccess() {
      when(mockBox.put("SelectedLangCodeKey", "en")).thenAnswer((_) async {});
    }

    test("put() should be called", () async {
      setUpWriteSuccess();
      await languagesLocalDataSource.putSelectedLanguageCode(langCode: "en");
      verify(mockBox.put("SelectedLangCodeKey", "en"));
    });
  });
}
