import 'package:tdd_translate/features/translate/domain/translation.dart';

class TranslationModel extends Translation {
  TranslationModel({required String translatedText, String? sourceLangCode})
      : super(translatedText: translatedText, sourceLangCode: sourceLangCode);

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      translatedText: json['translatedText'],
      sourceLangCode: json['detectedSourceLanguage'],
    );
  }
}
