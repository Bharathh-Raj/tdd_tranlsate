import 'package:dio/dio.dart';
import 'package:tdd_translate/features/translate/data/translation_model.dart';

abstract class RemoteTranslateDS {
  Future<List<TranslationModel>> translate(
      {required String inputText, required String destLangCode, String? sourceLangCode});
}

class RemoteTranslateDSImpl implements RemoteTranslateDS {
  final Dio dio;

  RemoteTranslateDSImpl({required this.dio});

  String get endPoint => "";

  @override
  Future<List<TranslationModel>> translate(
      {required String inputText,
      required String destLangCode,
      String? sourceLangCode}) async {
    final Response<dynamic> response = await dio.get(endPoint, queryParameters: {
      'q': inputText,
      if (sourceLangCode != null) 'source': sourceLangCode,
      'target': destLangCode
    });
    return _parse(response);
  }

  List<TranslationModel> _parse(Response<dynamic> response) {
    Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
    final List rawTranslationList = responseData['data']['translations'] as List;
    final List<TranslationModel> translationModleList = [];
    for (var translation in rawTranslationList) {
      translationModleList
          .add(TranslationModel.fromJson(translation as Map<String, dynamic>));
    }
    return translationModleList;
  }
}
