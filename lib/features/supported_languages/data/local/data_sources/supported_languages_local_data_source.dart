import 'package:tdd_translate/features/supported_languages/data/remote/models/language_model.dart';

abstract class SupportedLanguagesLocalDataSource {
  Future<List<LanguageModel>> fetch();

  Future<void> write(List<LanguageModel> languageList);
}

class SupportedLanguagesLocalDataSourceImpl implements SupportedLanguagesLocalDataSource {
  @override
  Future<List<LanguageModel>> fetch() {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  @override
  Future<void> write(List<LanguageModel> languageList) {
    // TODO: implement write
    throw UnimplementedError();
  }
}
