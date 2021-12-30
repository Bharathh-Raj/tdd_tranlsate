import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/detect_language/data/detection_model.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/lang_detection.dart';
import 'package:tdd_translate/features/detect_language/presentation/detect_languages_bloc/bloc.dart';
import 'package:tdd_translate/features/detect_language/presentation/widgets/detected_languages_widget.dart';
import 'package:tdd_translate/features/supported_languages/data/language_model.dart';

import '../../../../helpers/buildMaterialWidget.dart';
import 'detected_languages_widget_test.mocks.dart';

@GenerateMocks([DetectLanguagesBloc])
void main() {
  late MockDetectLanguagesBloc mockBloc;
  late StreamController<DetectLanguagesState> stateStreamController;

  setUp(() {
    mockBloc = MockDetectLanguagesBloc();
    stateStreamController = StreamController<DetectLanguagesState>.broadcast();
    when(mockBloc.stream).thenAnswer((_) => stateStreamController.stream);
  });

  tearDown(() {
    stateStreamController.close();
    mockBloc.close();
  });

  group("Simple cases", () {
    testWidgets("Sized Box should be built on initial state",
        (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(DetectLanguagesState.initial());
      await buildMaterialWidget_BlocProvider<DetectLanguagesBloc>(
          tester: tester, bloc: mockBloc, child: DetectedLanguagesWidget());
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets("CircularProgressIndicator should be built on loading state",
        (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(DetectLanguagesState.loading());
      await buildMaterialWidget_BlocProvider<DetectLanguagesBloc>(
          tester: tester, bloc: mockBloc, child: DetectedLanguagesWidget());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("Text should be built on empty state",
        (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(DetectLanguagesState.empty());
      await buildMaterialWidget_BlocProvider<DetectLanguagesBloc>(
          tester: tester, bloc: mockBloc, child: DetectedLanguagesWidget());
      expect(find.text("Input text to detect"), findsOneWidget);
    });
  });

  group("Success cases", () {
    void setUpDetectedState({bool isReliable = false}) {
      when(mockBloc.state).thenReturn(DetectLanguagesState.detected(
          inputText: "test input",
          detectionList: [
            LangDetection(
                detection: DetectionModel(
                    language: "en", confidence: 0.5, isReliable: isReliable),
                language: LanguageModel(language: "en", name: "English"))
          ]));
    }

    testWidgets("Title Text should be built on detected state",
        (WidgetTester tester) async {
      setUpDetectedState();
      await buildMaterialWidget_BlocProvider<DetectLanguagesBloc>(
          tester: tester, bloc: mockBloc, child: DetectedLanguagesWidget());
      expect(find.text("Detected Languages"), findsOneWidget);
    });

    testWidgets("Card should be built on detected state",
        (WidgetTester tester) async {
      setUpDetectedState();
      await buildMaterialWidget_BlocProvider<DetectLanguagesBloc>(
          tester: tester, bloc: mockBloc, child: DetectedLanguagesWidget());
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets("English text should be built on detected state",
        (WidgetTester tester) async {
      setUpDetectedState();
      await buildMaterialWidget_BlocProvider<DetectLanguagesBloc>(
          tester: tester, bloc: mockBloc, child: DetectedLanguagesWidget());
      expect(find.text("English"), findsOneWidget);
    });

    testWidgets("50% text should be built on detected state",
        (WidgetTester tester) async {
      setUpDetectedState();
      await buildMaterialWidget_BlocProvider<DetectLanguagesBloc>(
          tester: tester, bloc: mockBloc, child: DetectedLanguagesWidget());
      expect(find.text("50%"), findsOneWidget);
    });

    testWidgets(
        "🤔 emoji should be built on detected state with non reliable language",
        (WidgetTester tester) async {
      setUpDetectedState();
      await buildMaterialWidget_BlocProvider<DetectLanguagesBloc>(
          tester: tester, bloc: mockBloc, child: DetectedLanguagesWidget());
      expect(find.text("🤔"), findsOneWidget);
    });

    testWidgets(
        "💯 emoji should be built on detected state with reliable language",
        (WidgetTester tester) async {
      setUpDetectedState(isReliable: true);
      await buildMaterialWidget_BlocProvider<DetectLanguagesBloc>(
          tester: tester, bloc: mockBloc, child: DetectedLanguagesWidget());
      expect(find.text("💯"), findsOneWidget);
    });
  });

  group("Failure case", () {
    testWidgets("Failure text should be built on failed state",
        (WidgetTester tester) async {
      when(mockBloc.state)
          .thenReturn(DetectLanguagesState.failed(FetchFailure()));
      await buildMaterialWidget_BlocProvider<DetectLanguagesBloc>(
          tester: tester, bloc: mockBloc, child: DetectedLanguagesWidget());
      expect(find.text("Remote Connection Failure"), findsOneWidget);
    });
  });
}
