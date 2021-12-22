import 'package:flutter/material.dart';
import 'package:tdd_translate/features/supported_languages/presentation/widgets/language_selection_widget.dart';

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
            const LanguageSelectionWidget(),
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
