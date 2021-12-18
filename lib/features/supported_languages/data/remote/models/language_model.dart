import 'package:tdd_translate/features/supported_languages/domain/entities/language.dart';

class LanguageModel extends Language {
  const LanguageModel({required String language, required String name})
      : super(name: name, code: language);

  factory LanguageModel.fromJson(Map<String, dynamic> json) =>
      LanguageModel(language: json["language"], name: json["name"]);
}
