import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tdd_translate/features/detect_language/data/detect_lang_remote_ds.dart';
import 'package:tdd_translate/features/detect_language/data/detect_lang_repo_impl.dart';
import 'package:tdd_translate/features/detect_language/domain/repositories/detect_lang_repo.dart';
import 'package:tdd_translate/features/detect_language/domain/use_cases/detect_lang_use_case.dart';
import 'package:tdd_translate/features/supported_languages/data/local/data_sources/languages_local_data_source.dart';
import 'package:tdd_translate/features/supported_languages/data/remote/data_sources/languages_remote_data_source.dart';
import 'package:tdd_translate/features/supported_languages/data/repositories/language_repo_impl.dart';
import 'package:tdd_translate/features/supported_languages/domain/repositories/languages_repo.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/fetch_languages_use_case.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/get_lang_from_code_use_case.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/get_selected_lang_code.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/put_selected_lang_code_use_case.dart';

final GetIt locator = GetIt.instance;

Future<void> init() async {
  locator.registerLazySingleton<Dio>(() => Dio(BaseOptions(
      baseUrl: "https://translation.googleapis.com/language/translate/v2/",
      queryParameters: {"key": "AIzaSyBB6R_Vv9kZim-QmrEhNo5X9Y8yTpXKQ84"})));

  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  await _initFetchLanguagesDependencies(locator);
  _initDetectLanguagesDependencies(locator);
}

Future<void> _initFetchLanguagesDependencies(GetIt locator) async {
  locator.registerLazySingleton<LanguagesRemoteDataSource>(
      () => LanguagesRemoteDataSourceImpl(dio: locator()));
  //TODO: CLOSE ALL HIVE BOXes

  final Box hiveBox = await Hive.openBox('LanguageBox');
  locator.registerLazySingleton<LanguagesLocalDataSource>(
      () => LanguagesLocalDataSourceImpl(hiveBox: hiveBox));

  locator.registerLazySingleton<LanguagesRepo>(
      () => LanguagesRepoImpl(remoteDataSource: locator(), localDataSource: locator()));

  locator.registerLazySingleton<FetchLanguagesUseCase>(
      () => FetchLanguagesUseCase(languagesRepo: locator()));

  locator.registerLazySingleton<GetSelectedLangCodeUseCase>(
      () => GetSelectedLangCodeUseCase(languagesRepo: locator()));

  locator.registerLazySingleton<PutSelectedLangCodeUseCase>(
      () => PutSelectedLangCodeUseCase(languagesRepo: locator()));

  locator.registerLazySingleton<GetLangFromCodeUseCase>(
      () => GetLangFromCodeUseCase(languagesRepo: locator()));
}

void _initDetectLanguagesDependencies(GetIt locator) {
  locator.registerLazySingleton<DetectLangRemoteDataSource>(
      () => DetectLangRemoteDataSourceImpl(dio: locator()));
  locator.registerLazySingleton<DetectLangRepo>(
      () => DetectLangRepoImpl(detectLangRemoteDataSource: locator()));
  locator.registerLazySingleton<DetectLangUseCase>(
      () => DetectLangUseCase(detectLangRepo: locator()));
}
