import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_translate/features/translate/domain/translation_wrapper.dart';
import 'package:tdd_translate/features/translate/view/translate_bloc/bloc.dart';

class TranslatedWidget extends StatelessWidget {
  const TranslatedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranslateBloc, TranslateState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox(),
          loading: (_) => Center(child: const CircularProgressIndicator()),
          empty: (_) => Text("Input text to translate"),
          translated: (value) {
            return Column(
              children: [
                Text(
                  "Translated Text",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: value.translationWrapperList.length,
                    itemBuilder: (context, index) {
                      final TranslationWrapper translationWrapper =
                          value.translationWrapperList[index];
                      return Card(
                          child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  translationWrapper.sourceLang?.name ??
                                      translationWrapper.sourceLangCode,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                Icon(
                                  Icons.arrow_right_alt_rounded,
                                  color: Colors.white70,
                                  size: 24,
                                ),
                                Text(
                                  translationWrapper.destLang?.name ??
                                      translationWrapper.destLangCode,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(translationWrapper
                                  .translation.translatedText),
                            ),
                          ],
                        ),
                      ));
                    },
                  ),
                ),
              ],
            );
          },
          failure: (value) => Text(value.failure.messageToDisplay),
        );
      },
    );
  }
}

// class TranslatedTextWidget extends StatelessWidget {
//   const TranslatedTextWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
