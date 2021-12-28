import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/features/supported_languages/data/language_model.dart';
import 'package:tdd_translate/features/supported_languages/data/remote/data_sources/languages_remote_data_source.dart';

import '../../../../../fixtures/fixture_reader.dart';
import 'languages_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late LanguagesRemoteDataSourceImpl dataSource;
  late MockDio mockDio;
  late Response response;
  late Map<String, dynamic> languagesFixtureMap;

  setUp(() {
    mockDio = MockDio();
    dataSource = LanguagesRemoteDataSourceImpl(dio: mockDio);
    languagesFixtureMap = fixtureAsMap('supported_languages.json');
    response = Response(
        requestOptions: RequestOptions(path: dataSource.languagesEndpoint),
        data: languagesFixtureMap);
  });

  void setUpMockDioSuccess() {
    when(mockDio.get(dataSource.languagesEndpoint,
            queryParameters: dataSource.queryParam))
        .thenAnswer((_) async {
      return response;
    });
  }

  group("Fetch Supported Languages - Success cases", () {
    test("Should perform a get request", () async {
      setUpMockDioSuccess();
      await dataSource.fetch();
      verify(mockDio.get(dataSource.languagesEndpoint,
          queryParameters: dataSource.queryParam));
    });
    test("Should return List<LanguageModel> on fetch", () async {
      setUpMockDioSuccess();
      final languageList = await dataSource.fetch();
      expect(languageList, isInstanceOf<List<LanguageModel>>());
    });
    test(
        "Language list returned from fetching should be same as fixture's language list",
        () async {
      setUpMockDioSuccess();
      final fetchedLanguageList = await dataSource.fetch();
      final List<dynamic> fixtureRawLanguageList =
          (languagesFixtureMap["data"]["languages"] as List<dynamic>)
              .map((language) => language as Map<String, dynamic>)
              .toList();

      final List<LanguageModel> fixtureLanguageModelList =
          fixtureRawLanguageList
              .map((languageMap) => LanguageModel.fromJson(languageMap))
              .toList();
      expect(fixtureLanguageModelList, equals(fetchedLanguageList));
    });
  });

  void setUpMockDioFailure() {
    when(mockDio.get(dataSource.languagesEndpoint,
            queryParameters: dataSource.queryParam))
        .thenThrow(DioError(
            requestOptions: RequestOptions(path: dataSource.languagesEndpoint),
            error: "Test Error",
            type: DioErrorType.other));
  }

  group("Fetch Supported Languages - Failure cases", () {
    test("Should throw exception", () {
      setUpMockDioFailure();
      expect(() async => await dataSource.fetch(),
          throwsA(const TypeMatcher<DioError>()));
    });
  });
}
