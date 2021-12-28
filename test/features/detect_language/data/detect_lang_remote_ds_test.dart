import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/features/detect_language/data/detect_lang_remote_ds.dart';
import 'package:tdd_translate/features/detect_language/data/detection_model.dart';

import '../../../fixtures/fixture_reader.dart';
import 'detect_lang_remote_ds_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late DetectLangRemoteDataSourceImpl detectLangRemoteDataSource;
  late MockDio mockDio;

  late Response response;
  late Map<String, dynamic> detectionsFixtureMap;

  setUp(() {
    mockDio = MockDio();
    detectLangRemoteDataSource = DetectLangRemoteDataSourceImpl(dio: mockDio);
    detectionsFixtureMap = fixtureAsMap('detections.json');
    response = Response(
        requestOptions: RequestOptions(
            path: detectLangRemoteDataSource.endPoint,
            queryParameters: {"q": "test"}),
        data: detectionsFixtureMap);
  });

  group("detectLangFor method", () {
    group("Success cases", () {
      void setUpDetectSuccess() {
        when(mockDio.get(detectLangRemoteDataSource.endPoint,
                queryParameters: anyNamed("queryParameters")))
            .thenAnswer((_) async => response);
      }

      test("dio.get() method must be called", () async {
        setUpDetectSuccess();
        await detectLangRemoteDataSource.detectLangFor("test");
        verify(mockDio.get(detectLangRemoteDataSource.endPoint,
            queryParameters: {"q": "test"}));
      });

      test("Should return List<DetectionModel> on success", () async {
        setUpDetectSuccess();
        final detectionModelList =
            await detectLangRemoteDataSource.detectLangFor("test");
        expect(detectionModelList, isInstanceOf<List<DetectionModel>>());
      });
    });

    group("Failure cases", () {
      void setUpDetectFailure() {
        when(mockDio.get(detectLangRemoteDataSource.endPoint,
                queryParameters: anyNamed("queryParameters")))
            .thenThrow(DioError(
                requestOptions:
                    RequestOptions(path: detectLangRemoteDataSource.endPoint),
                error: "Test Error",
                type: DioErrorType.other));
      }

      test("Should throw exception", () {
        setUpDetectFailure();
        expect(() => detectLangRemoteDataSource.detectLangFor("test"),
            throwsA(const TypeMatcher<DioError>()));
      });
    });
  });
}
