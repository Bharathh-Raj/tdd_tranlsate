import 'package:hive/hive.dart';
import 'package:tdd_translate/features/supported_languages/data/language_model.dart';

abstract class LanguagesLocalDataSource {
  List<LanguageModel>? fetch();

  Future<void> write(List<LanguageModel> languageList);
}

class LanguagesLocalDataSourceImpl implements LanguagesLocalDataSource {
  final Box hiveBox;
  final String _languageListKey = "LangListKey";

  LanguagesLocalDataSourceImpl({required this.hiveBox});

  @override
  List<LanguageModel>? fetch() {
    final List<dynamic>? langList = hiveBox.get(_languageListKey);
    List<Map<String, dynamic>>? langListMap =
        langList?.map((e) => Map<String, dynamic>.from(e)).toList();
    // (hiveBox.get(_languageListKey) as List<dynamic>).cast<Map<String, dynamic>>();
    if (langListMap != null) {
      List<LanguageModel> langModelList =
          langListMap.map((lang) => LanguageModel.fromJson(lang)).toList();
      return langModelList;
    }
  }

  @override
  Future<void> write(List<LanguageModel> languageList) async {
    List<Map<String, dynamic>> langListMap =
        languageList.map((lang) => lang.toJson()).toList();
    return await hiveBox.put(_languageListKey, langListMap);
  }
}
