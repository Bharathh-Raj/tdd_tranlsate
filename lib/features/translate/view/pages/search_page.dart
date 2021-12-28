import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_translate/features/detect_language/presentation/detect_languages_bloc/bloc.dart';
import 'package:tdd_translate/features/detect_language/presentation/widgets/detected_languages_widget.dart';
import 'package:tdd_translate/features/supported_languages/presentation/languages_bloc/bloc.dart';
import 'package:tdd_translate/features/supported_languages/presentation/widgets/language_selection_widget.dart';
import 'package:tdd_translate/features/translate/view/translate_bloc/bloc.dart';
import 'package:tdd_translate/features/translate/view/widgets/translated_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translate'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const LanguageSelectionWidget(),
            TextField(
              controller: textEditingController,
              textInputAction: TextInputAction.go,
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Detected Languages",
              style: Theme.of(context).textTheme.headline6,
            ),
            const DetectedLanguagesWidget(),
            Text(
              "Translated Texts",
              style: Theme.of(context).textTheme.headline6,
            ),
            const TranslatedWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<DetectLanguagesBloc>().add(
                          DetectLanguagesEvent.detect(
                              inputText: textEditingController.text));
                    },
                    child: const Text("Detect"),
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: context.read<LanguagesBloc>().state is Fetched
                        ? () {
                            context.read<TranslateBloc>().add(
                                TranslateEvent.translate(
                                    inputText: textEditingController.text,
                                    destLangCode: (context
                                            .read<LanguagesBloc>()
                                            .state as Fetched)
                                        .selectedLangCode));
                          }
                        : null,
                    child: const Text("Translate"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
