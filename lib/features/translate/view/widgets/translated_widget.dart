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
          loading: (_) => const CircularProgressIndicator(),
          translated: (value) {
            return Expanded(
              child: ListView.builder(
                itemCount: value.translationWrapperList.length,
                itemBuilder: (context, index) {
                  final TranslationWrapper translationWrapper =
                      value.translationWrapperList[index];
                  return Card(
                      child: ListTile(
                    title: Text(translationWrapper.translation.translatedText),
                    subtitle: Text(translationWrapper.sourceLang?.name ??
                        translationWrapper.sourceLangCode),
                    trailing: Text(translationWrapper.destLang?.name ??
                        translationWrapper.destLangCode),
                  ));
                },
              ),
            );
          },
          failure: (value) => Text(value.failure.messageToDisplay),
        );
      },
    );
  }
}
