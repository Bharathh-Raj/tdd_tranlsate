import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_translate/features/supported_languages/presentation/languages_bloc/bloc.dart';

class LanguageSelectionWidget extends StatelessWidget {
  const LanguageSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Translate to:",
          style: Theme.of(context).textTheme.headline6,
        ),
        BlocBuilder<LanguagesBloc, LanguagesState>(
          builder: (context, state) {
            return state.map(
              initial: (value) => const CircularProgressIndicator(),
              fetched: (value) {
                final List<DropdownMenuItem<dynamic>> languagesList =
                    value.languageList
                        .map((e) => DropdownMenuItem(
                              child: Text(e.name),
                              value: e.code,
                            ))
                        .toList();
                return DropdownButton<dynamic>(
                    items: languagesList,
                    value: value.selectedLangCode,
                    onChanged: (changedValue) {
                      context
                          .read<LanguagesBloc>()
                          .add(LanguagesEvent.putSelectedLang(changedValue));
                    });
              },
              failure: (value) {
                return const Text("Something went wrong");
              },
            );
          },
        ),
      ],
    );
  }
}
