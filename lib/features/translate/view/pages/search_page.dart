import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_translate/features/supported_languages/supported_languages.dart';

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
            TextField(
              controller: textEditingController,
              textInputAction: TextInputAction.go,
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
                        items: languagesList, value: "ta", onChanged: (_) {});
                  },
                  failure: (value) {
                    return const Text("Something went wrong");
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Translate"),
            )
          ],
        ),
      ),
    );
  }
}
