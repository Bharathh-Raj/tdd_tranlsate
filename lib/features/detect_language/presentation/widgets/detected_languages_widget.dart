import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_translate/features/detect_language/presentation/detect_languages_bloc/bloc.dart';
import 'package:tdd_translate/features/supported_languages/presentation/languages_bloc/bloc.dart';

class DetectedLanguagesWidget extends StatelessWidget {
  const DetectedLanguagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguagesBloc, LanguagesState>(
      buildWhen: (previous, current) => current is Fetched,
      builder: (context, languagesState) {
        return BlocBuilder<DetectLanguagesBloc, DetectLanguagesState>(
          builder: (context, state) {
            return state.map(
              initial: (_) => const SizedBox(),
              loading: (_) => const CircularProgressIndicator(),
              detected: (value) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: value.detectionList.length,
                    itemBuilder: (context, index) {
                      final String _langName = (languagesState as Fetched)
                          .languageList
                          .firstWhere((element) =>
                              element.code == value.detectionList[index].langCode)
                          .name;
                      return Card(
                          child: ListTile(
                        title: Text(_langName),
                        subtitle: Text(value.detectionList[index].accuracy.toString()),
                        trailing: Text(value.detectionList[index].isReliable.toString()),
                      ));
                    },
                  ),
                );
              },
              failed: (value) => Text(value.failure.messageToDisplay),
            );
          },
        );
      },
    );
  }
}
