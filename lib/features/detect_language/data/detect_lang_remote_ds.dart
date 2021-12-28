import 'package:dio/dio.dart';
import 'package:tdd_translate/features/detect_language/data/detection_model.dart';

abstract class DetectLangRemoteDataSource {
  Future<List<DetectionModel>> detectLangFor(String text);
}

class DetectLangRemoteDataSourceImpl implements DetectLangRemoteDataSource {
  final Dio dio;

  DetectLangRemoteDataSourceImpl({required this.dio});

  String get endPoint => "detect";

  @override
  Future<List<DetectionModel>> detectLangFor(String text) async {
    Response<dynamic> response =
        await dio.get(endPoint, queryParameters: {"q": text});
    return _parse(response);
  }

  List<DetectionModel> _parse(Response response) {
    Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
    List<dynamic> rawDetections =
        responseData["data"]["detections"] as List<dynamic>;

    final List<DetectionModel> detectionModelList = [];

    for (var detectionList in rawDetections) {
      detectionList as List<dynamic>;
      for (var detection in detectionList) {
        detection as Map<String, dynamic>;
        detectionModelList.add(DetectionModel.fromJson(detection));
      }
    }
    return detectionModelList;
  }
}
