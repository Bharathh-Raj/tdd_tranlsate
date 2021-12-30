import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/supported_languages/data/language_model.dart';
import 'package:tdd_translate/features/supported_languages/presentation/languages_bloc/bloc.dart';
import 'package:tdd_translate/features/supported_languages/presentation/widgets/language_selection_widget.dart';

import '../../../../helpers/buildMaterialWidget.dart';
import 'languages_selection_widget_test.mocks.dart';

@GenerateMocks([LanguagesBloc])
void main() {
  late MockLanguagesBloc mockLanguagesBloc;
  late StreamController<LanguagesState> streamController;

  setUp(() {
    mockLanguagesBloc = MockLanguagesBloc();
    streamController = StreamController<LanguagesState>.broadcast();
    when(mockLanguagesBloc.stream).thenAnswer((_) => streamController.stream);
  });

  tearDown(() {
    streamController.close();
    mockLanguagesBloc.close();
  });

  group("Simple cases", () {
    testWidgets("Title should be built", (tester) async {
      when(mockLanguagesBloc.state).thenReturn(LanguagesState.initial());
      await buildMaterialWidget_BlocProvider<LanguagesBloc>(
          tester: tester,
          bloc: mockLanguagesBloc,
          child: LanguageSelectionWidget());
      expect(find.text("Translate to:"), findsOneWidget);
    });

    testWidgets("Initial Case must build CircularProgressIndicator widget",
        (tester) async {
      when(mockLanguagesBloc.state).thenReturn(LanguagesState.initial());
      await buildMaterialWidget_BlocProvider<LanguagesBloc>(
          tester: tester,
          bloc: mockLanguagesBloc,
          child: LanguageSelectionWidget());
      expect(find.byKey(ValueKey("Languages initial state")), findsOneWidget);
    });
  });

  group("Success cases", () {
    void setUpFetchedState({String selectedLangCode = "en"}) {
      when(mockLanguagesBloc.state).thenReturn(LanguagesState.fetched([
        LanguageModel(language: "en", name: "English"),
        LanguageModel(language: "ta", name: "Tamil"),
      ], selectedLangCode));
    }

    testWidgets(
        "DropDownButton with English DropDownMenuItem should be built on fetched state",
        (tester) async {
      setUpFetchedState();
      await buildMaterialWidget_BlocProvider<LanguagesBloc>(
          tester: tester,
          bloc: mockLanguagesBloc,
          child: LanguageSelectionWidget());
      expect(find.byKey(ValueKey("Button with value en")), findsOneWidget);
    });

    testWidgets(
        "DropDownButton with Tamil DropDownMenuItem should be built on fetched state",
        (tester) async {
      setUpFetchedState(selectedLangCode: "ta");
      await buildMaterialWidget_BlocProvider<LanguagesBloc>(
          tester: tester,
          bloc: mockLanguagesBloc,
          child: LanguageSelectionWidget());
      expect(find.byKey(ValueKey("Button with value ta")), findsOneWidget);
    });

    testWidgets("English DropDownMenuItem should be built on fetched state",
        (tester) async {
      setUpFetchedState();
      await buildMaterialWidget_BlocProvider<LanguagesBloc>(
          tester: tester,
          bloc: mockLanguagesBloc,
          child: LanguageSelectionWidget());
      expect(find.byKey(ValueKey("Item is English")), findsOneWidget);
    });

    testWidgets(
        "English and Tamil DropDownMenuItem should be built on fetched state",
        (tester) async {
      setUpFetchedState();
      await buildMaterialWidget_BlocProvider<LanguagesBloc>(
          tester: tester,
          bloc: mockLanguagesBloc,
          child: LanguageSelectionWidget());
      expect(find.byKey(ValueKey("Item is English")), findsOneWidget);
      expect(find.byKey(ValueKey("Item is Tamil")), findsOneWidget);
    });

    // Error in the DropDownMenu Widget https://issueexplorer.com/issue/flutter/flutter/89905
    // testWidgets(
    //     "Tamil DropDownMenuItem should be displayed on DropDownButton changing selected language to Tamil",
    //     (tester) async {
    //   setUpFetchedState();
    //   await buildMaterialWidget_BlocProvider<LanguagesBloc>(
    //       tester: tester,
    //       bloc: mockLanguagesBloc,
    //       child: LanguageSelectionWidget());
    //   expect(find.byKey(ValueKey("Button with value en")), findsOneWidget);
    //   await tester.tap(find.byKey(ValueKey("Button with value en")));
    //   await tester.pump();
    //   await tester.tap(find.byKey(ValueKey("Item is Tamil")));
    //   await tester.pump();
    //   expect(find.byKey(ValueKey("Button with value ta")), findsOneWidget);
    // });
  });

  group("Failure cases", () {
    testWidgets("Title should be built", (tester) async {
      when(mockLanguagesBloc.state)
          .thenReturn(LanguagesState.failure(FetchFailure()));
      await buildMaterialWidget_BlocProvider<LanguagesBloc>(
          tester: tester,
          bloc: mockLanguagesBloc,
          child: LanguageSelectionWidget());
      expect(find.text("Something went wrong"), findsOneWidget);
    });
  });
}
