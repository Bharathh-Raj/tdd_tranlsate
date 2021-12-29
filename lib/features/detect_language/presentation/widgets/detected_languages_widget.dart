import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/lang_detection.dart';
import 'package:tdd_translate/features/detect_language/presentation/detect_languages_bloc/bloc.dart';

class DetectedLanguagesWidget extends StatelessWidget {
  const DetectedLanguagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetectLanguagesBloc, DetectLanguagesState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox(),
          loading: (_) => Center(child: const CircularProgressIndicator()),
          empty: (_) => const Text("Input text to detect"),
          detected: (value) {
            return Column(
              children: [
                Text(
                  "Detected Languages",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: value.detectionList.length,
                    itemBuilder: (context, index) {
                      final LangDetection langDetection =
                          value.detectionList[index];
                      return Card(
                          child: ListTile(
                        title: Text(langDetection.language?.name ??
                            langDetection.detection.langCode),
                        subtitle: Text((langDetection.detection.accuracy * 100)
                                .toInt()
                                .toString() +
                            "%"),
                        trailing: Text(
                            langDetection.detection.isReliable ? "💯" : "🤔"),
                      ));
                    },
                  ),
                ),
              ],
            );
          },
          failed: (value) => Text(value.failure.messageToDisplay),
        );
      },
    );
  }
}
