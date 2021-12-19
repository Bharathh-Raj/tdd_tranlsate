// import 'package:mockito/mockito.dart';
//
// @GenerateMocks([Dio])

import 'dart:convert';

import 'package:tdd_translate/features/supported_languages/data/remote/models/language_model.dart';

import '../fixtures/fixture_reader.dart';

List<LanguageModel> fetchTestLanguageList() {
  final List<dynamic> fixtureRawLanguageList = ((json.decode(fixture('supported_languages.json'))
          as Map<String, dynamic>)["data"]["languages"] as List<dynamic>)
      .map((language) => language as Map<String, dynamic>)
      .toList();
  final List<LanguageModel> fixtureLanguageModelList =
      fixtureRawLanguageList.map((languageMap) => LanguageModel.fromJson(languageMap)).toList();
  return fixtureLanguageModelList;
}
