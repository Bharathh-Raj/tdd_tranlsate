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
        title: const Text('TDD Translate'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TextField(
                  controller: textEditingController,
                  textInputAction: TextInputAction.go,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Input text",
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2.0)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(width: 2.0),
                    ),
                  ),
                ),
                const LanguageSelectionWidget(),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            const TranslatedWidget(),
            const DetectedLanguagesWidget(),
            BlocBuilder<LanguagesBloc, LanguagesState>(
              builder: (context, state) {
                return Row(
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
                        onPressed: state.maybeMap(
                          orElse: () => null,
                          fetched: (value) {
                            return () {
                              context.read<TranslateBloc>().add(
                                  TranslateEvent.translate(
                                      inputText: textEditingController.text,
                                      destLangCode: value.selectedLangCode));
                            };
                          },
                        ),
                        child: const Text("Translate"),
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
