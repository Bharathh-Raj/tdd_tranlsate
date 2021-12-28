import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/features/translate/data/data_source/remote_translate_ds.dart';
import 'package:tdd_translate/features/translate/data/translation_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'remote_translate_ds_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late RemoteTranslateDSImpl remoteTranslateDS;
  late MockDio mockDio;

  late Map<String, dynamic> queryWithSource;
  late Map<String, dynamic> queryAutoSource;

  late Map<String, dynamic> translateAutoSourceFixtureMap;
  late Map<String, dynamic> translateWithSourceFixtureMap;

  late Response responseOfAutoSource;
  late Response responseOfManualSource;

  setUp(() {
    mockDio = MockDio();
    remoteTranslateDS = RemoteTranslateDSImpl(dio: mockDio);

    queryAutoSource = {'q': 'test', 'target': 'ta'};
    queryWithSource = {'q': 'test', 'source': 'en', 'target': 'ta'};

    translateAutoSourceFixtureMap = fixtureAsMap('translate_auto_source.json');
    translateWithSourceFixtureMap = fixtureAsMap('translate_with_source.json');

    responseOfAutoSource = Response(
        requestOptions: RequestOptions(
            path: remoteTranslateDS.endPoint, queryParameters: queryAutoSource),
        data: translateAutoSourceFixtureMap);

    responseOfManualSource = Response(
        requestOptions: RequestOptions(
            path: remoteTranslateDS.endPoint, queryParameters: queryWithSource),
        data: translateWithSourceFixtureMap);
  });

  group("translate() method", () {
    group("Basic cases", () {
      setUpAutoSourceSuccess() {
        when(mockDio.get(remoteTranslateDS.endPoint,
                queryParameters: queryAutoSource))
            .thenAnswer((_) async => responseOfAutoSource);
      }

      test("get() method of Dio should be called", () async {
        setUpAutoSourceSuccess();
        await remoteTranslateDS.translate(
            inputText: 'test', destLangCode: "ta");
        verify(mockDio.get(remoteTranslateDS.endPoint,
            queryParameters: queryAutoSource));
      });
    });

    group("Success cases for auto source lang", () {
      setUpAutoSourceSuccess() {
        when(mockDio.get(remoteTranslateDS.endPoint,
                queryParameters: queryAutoSource))
            .thenAnswer((_) async => responseOfAutoSource);
      }

      test("List<TranslationModel> should be returned on translate success",
          () async {
        setUpAutoSourceSuccess();
        final translationModelList = await remoteTranslateDS.translate(
            inputText: 'test', destLangCode: "ta");
        expect(translationModelList, isInstanceOf<List<TranslationModel>>());
      });

      test(
          "sourceLangCode property of TranslationModel should not be null on auto source lang",
          () async {
        setUpAutoSourceSuccess();
        final translationModelList = await remoteTranslateDS.translate(
            inputText: 'test', destLangCode: "ta");
        expect(translationModelList.first.sourceLangCode, isNotNull);
      });
    });

    group("Failure cases for auto source lang", () {
      setUpAutoSourceFailure() {
        when(mockDio.get(remoteTranslateDS.endPoint,
                queryParameters: queryAutoSource))
            .thenThrow(Exception());
      }

      test("Exception should be thrown on exception", () async {
        setUpAutoSourceFailure();
        expect(
            () async => await remoteTranslateDS.translate(
                inputText: 'test', destLangCode: "ta"),
            throwsA(const TypeMatcher<Exception>()));
      });
    });

    group("Success cases for manual source lang", () {
      setUpAutoSourceSuccess() {
        when(mockDio.get(remoteTranslateDS.endPoint,
                queryParameters: queryWithSource))
            .thenAnswer((_) async => responseOfManualSource);
      }

      test("List<TranslationModel> should be returned on translate success",
          () async {
        setUpAutoSourceSuccess();
        final translationModelList = await remoteTranslateDS.translate(
            inputText: 'test', destLangCode: "ta", sourceLangCode: "en");
        expect(translationModelList, isInstanceOf<List<TranslationModel>>());
      });

      test(
          "sourceLangCode property of TranslationModel should be null on manual source lang",
          () async {
        setUpAutoSourceSuccess();
        final translationModelList = await remoteTranslateDS.translate(
            inputText: 'test', destLangCode: "ta", sourceLangCode: 'en');
        expect(translationModelList.first.sourceLangCode, isNull);
      });
    });

    group("Failure cases for manual source lang", () {
      setUpAutoSourceFailure() {
        when(mockDio.get(remoteTranslateDS.endPoint,
                queryParameters: queryWithSource))
            .thenThrow(Exception());
      }

      test("Exception should be thrown on exception", () async {
        setUpAutoSourceFailure();
        expect(
            () async => await remoteTranslateDS.translate(
                inputText: 'test', destLangCode: "ta", sourceLangCode: "en"),
            throwsA(const TypeMatcher<Exception>()));
      });
    });
  });
}
