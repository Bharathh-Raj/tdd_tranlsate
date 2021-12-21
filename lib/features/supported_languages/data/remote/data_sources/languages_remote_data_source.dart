import 'package:dio/dio.dart';
import 'package:tdd_translate/features/supported_languages/data/language_model.dart';

abstract class LanguagesRemoteDataSource {
  Future<List<LanguageModel>> fetch();
}

class LanguagesRemoteDataSourceImpl implements LanguagesRemoteDataSource {
  final Dio dio;
  final String languagesEndpoint = "languages";
  final Map<String, dynamic> queryParam = {"target": "en"};

  LanguagesRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<LanguageModel>> fetch() async {
    Response<dynamic> response =
        await dio.get(languagesEndpoint, queryParameters: queryParam);
    Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
    List<dynamic> rawLanguages = responseData["data"]["languages"] as List<dynamic>;
    for (var language in rawLanguages) {
      language as Map<String, dynamic>;
    }
    return rawLanguages.map((language) => LanguageModel.fromJson(language)).toList();
  }
}
