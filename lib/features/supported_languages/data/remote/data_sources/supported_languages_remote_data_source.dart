import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tdd_translate/features/supported_languages/data/remote/models/language_model.dart';

abstract class SupportedLanguagesRemoteDataSource {
  Future<List<LanguageModel>> fetch();
}

class SupportedLanguagesRemoteDataSourceImpl implements SupportedLanguagesRemoteDataSource {
  final Dio dio;
  final String languagesEndpoint = "languages";
  final Map<String, dynamic> queryParam = {"target": "en"};

  SupportedLanguagesRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<LanguageModel>> fetch() async {
    Response<dynamic> response = await dio.get(languagesEndpoint, queryParameters: queryParam);
    Map<String, dynamic> responseData = json.decode(response.data) as Map<String, dynamic>;
    List<dynamic> rawLanguages = responseData["data"]["languages"] as List<dynamic>;
    for (var language in rawLanguages) {
      language as Map<String, dynamic>;
    }
    return rawLanguages.map((language) => LanguageModel.fromJson(language)).toList();
  }
}
