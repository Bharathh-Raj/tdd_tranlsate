import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/features/supported_languages/data/remote/data_sources/supported_languages_remote_data_source.dart';
import 'package:tdd_translate/features/supported_languages/data/remote/models/language_model.dart';

import '../../../../../fixtures/fixture_reader.dart';
import 'fetch_languages_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late SupportedLanguagesRemoteDataSourceImpl dataSource;
  late MockDio mockDio;
  late Response response;
  late String languagesFixtureString;

  setUp(() {
    mockDio = MockDio();
    dataSource = SupportedLanguagesRemoteDataSourceImpl(dio: mockDio);
    languagesFixtureString = fixture('supported_languages.json');
    response = Response(
        requestOptions: RequestOptions(path: dataSource.languagesEndpoint),
        data: languagesFixtureString);
  });

  void setUpMockDioSuccess() {
    when(mockDio.get(dataSource.languagesEndpoint, queryParameters: dataSource.queryParam))
        .thenAnswer((_) async {
      return response;
    });
  }

  group("Fetch Supported Languages - Success cases", () {
    test("Should perform a get request", () async {
      setUpMockDioSuccess();
      await dataSource.fetch();
      verify(mockDio.get(dataSource.languagesEndpoint, queryParameters: dataSource.queryParam));
    });
    test("Should return List<LanguageModel> on fetch", () async {
      setUpMockDioSuccess();
      final languageList = await dataSource.fetch();
      expect(languageList, isInstanceOf<List<LanguageModel>>());
    });
    test("Language list returned from fetching should be same as fixture's language list",
        () async {
      setUpMockDioSuccess();
      final fetchedLanguageList = await dataSource.fetch();
      final List<dynamic> fixtureRawLanguageList = ((json.decode(languagesFixtureString)
              as Map<String, dynamic>)["data"]["languages"] as List<dynamic>)
          .map((language) => language as Map<String, dynamic>)
          .toList();

      final List<LanguageModel> fixtureLanguageModelList =
          fixtureRawLanguageList.map((languageMap) => LanguageModel.fromJson(languageMap)).toList();
      expect(fixtureLanguageModelList, equals(fetchedLanguageList));
    });
  });

  void setUpMockDioFailure() {
    when(mockDio.get(dataSource.languagesEndpoint, queryParameters: dataSource.queryParam))
        .thenThrow(DioError(
            requestOptions: RequestOptions(path: dataSource.languagesEndpoint),
            error: "Test Error",
            type: DioErrorType.other));
  }

  group("Fetch Supported Languages - Failure cases", () {
    test("Should throw exception", () {
      setUpMockDioFailure();
      expect(() async => await dataSource.fetch(), throwsA(const TypeMatcher<DioError>()));
    });
  });
}
