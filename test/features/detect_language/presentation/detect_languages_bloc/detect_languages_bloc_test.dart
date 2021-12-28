import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/detect_language/data/detection_model.dart';
import 'package:tdd_translate/features/detect_language/domain/entities/lang_detection.dart';
import 'package:tdd_translate/features/detect_language/domain/use_cases/detect_lang_use_case.dart';
import 'package:tdd_translate/features/detect_language/presentation/detect_languages_bloc/bloc.dart';
import 'package:tdd_translate/features/supported_languages/data/language_model.dart';
import 'package:tdd_translate/features/supported_languages/domain/use_cases/get_lang_from_code_use_case.dart';

import 'detect_languages_bloc_test.mocks.dart';

@GenerateMocks([DetectLangUseCase, GetLangFromCodeUseCase])
void main() {
  late DetectLanguagesBloc detectLanguagesBloc;
  late MockDetectLangUseCase mockDetectLangUseCase;
  late MockGetLangFromCodeUseCase mockGetLangFromCodeUseCase;

  setUp(() {
    mockDetectLangUseCase = MockDetectLangUseCase();
    mockGetLangFromCodeUseCase = MockGetLangFromCodeUseCase();
    detectLanguagesBloc = DetectLanguagesBloc(
        detectLangUseCase: mockDetectLangUseCase,
        getLangFromCodeUseCase: mockGetLangFromCodeUseCase);
  });

  tearDown(() {
    detectLanguagesBloc.close();
  });

  group("detect event", () {
    test("Initial state should be DetectLanguagesState.initial()", () {
      expect(detectLanguagesBloc.state, isInstanceOf<Initial>());
    });

    void setUpDetectSuccess() {
      when(mockDetectLangUseCase("test")).thenAnswer((_) async => Right(
          [DetectionModel(isReliable: true, confidence: 1, language: "en")]));
    }

    void setUpGetLangFromCodeSuccess() {
      when(mockGetLangFromCodeUseCase("en")).thenAnswer(
          (_) async => const LanguageModel(language: "en", name: "English"));
    }

    blocTest<DetectLanguagesBloc, DetectLanguagesState>(
      "detectLangUseCase must be called",
      build: () => detectLanguagesBloc,
      setUp: () {
        setUpDetectSuccess();
        setUpGetLangFromCodeSuccess();
      },
      act: (bloc) =>
          bloc.add(const DetectLanguagesEvent.detect(inputText: "test")),
      verify: (bloc) => verify(mockDetectLangUseCase("test")),
    );

    blocTest<DetectLanguagesBloc, DetectLanguagesState>(
      "getLangFromCodeUseCase must be called",
      build: () => detectLanguagesBloc,
      setUp: () {
        setUpDetectSuccess();
        setUpGetLangFromCodeSuccess();
      },
      act: (bloc) =>
          bloc.add(const DetectLanguagesEvent.detect(inputText: "test")),
      verify: (bloc) => verify(mockGetLangFromCodeUseCase("en")),
    );

    blocTest<DetectLanguagesBloc, DetectLanguagesState>(
      "Loading state and Detected state must be emitted on detection success",
      build: () => detectLanguagesBloc,
      setUp: () {
        setUpDetectSuccess();
        setUpGetLangFromCodeSuccess();
      },
      act: (bloc) =>
          bloc.add(const DetectLanguagesEvent.detect(inputText: "test")),
      expect: () => <DetectLanguagesState>[
        const DetectLanguagesState.loading(),
        DetectLanguagesState.detected(inputText: "test", detectionList: [
          LangDetection(
              detection: DetectionModel(
                  isReliable: true, confidence: 1, language: "en"),
              language: const LanguageModel(name: "English", language: "en"))
        ])
      ],
    );

    void setUpGetLangFromCodeNull() {
      when(mockGetLangFromCodeUseCase("en")).thenAnswer((_) async => null);
    }

    blocTest<DetectLanguagesBloc, DetectLanguagesState>(
      "Loading state and Detected state with language as null must be emitted on detection success but getLangFromCode returns null",
      build: () => detectLanguagesBloc,
      setUp: () {
        setUpDetectSuccess();
        setUpGetLangFromCodeNull();
      },
      act: (bloc) =>
          bloc.add(const DetectLanguagesEvent.detect(inputText: "test")),
      expect: () => <DetectLanguagesState>[
        const DetectLanguagesState.loading(),
        DetectLanguagesState.detected(inputText: "test", detectionList: [
          LangDetection(
              detection: DetectionModel(
                  isReliable: true, confidence: 1, language: "en"),
              language: null)
        ])
      ],
    );

    group("Failure cases", () {
      void setUpDetectFailure() {
        when(mockDetectLangUseCase("test"))
            .thenAnswer((_) async => Left(FetchFailure()));
      }

      blocTest<DetectLanguagesBloc, DetectLanguagesState>(
        "Loading state and Failure state must be emitted on detection failure",
        build: () => detectLanguagesBloc,
        setUp: setUpDetectFailure,
        act: (bloc) =>
            bloc.add(const DetectLanguagesEvent.detect(inputText: "test")),
        expect: () => <DetectLanguagesState>[
          const DetectLanguagesState.loading(),
          DetectLanguagesState.failed(FetchFailure())
        ],
      );
    });
  });
}
