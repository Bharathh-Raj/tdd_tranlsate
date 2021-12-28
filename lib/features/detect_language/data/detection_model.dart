import 'package:tdd_translate/features/detect_language/domain/entities/detection.dart';

class DetectionModel extends Detection {
  DetectionModel(
      {required String language,
      required double confidence,
      required bool isReliable})
      : super(langCode: language, accuracy: confidence, isReliable: isReliable);

  factory DetectionModel.fromJson(Map<String, dynamic> json) => DetectionModel(
      language: json['language'],
      confidence: (json['confidence'] as num).toDouble(),
      isReliable: json['isReliable']);

  Map<String, dynamic> toJson() {
    return {
      "confidence": accuracy,
      "isReliable": isReliable,
      "language": langCode,
    };
  }
}
