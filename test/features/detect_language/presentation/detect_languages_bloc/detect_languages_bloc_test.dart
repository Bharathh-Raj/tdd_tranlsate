import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_translate/core/failure.dart';
import 'package:tdd_translate/features/detect_language/data/detection_model.dart';
import 'package:tdd_translate/features/detect_language/domain/use_cases/detect_lang_use_case.dart';
import 'package:tdd_translate/features/detect_language/presentation/detect_languages_bloc/bloc.dart';

import 'detect_languages_bloc_test.mocks.dart';

@GenerateMocks([DetectLangUseCase])
void main() {
  late DetectLanguagesBloc detectLanguagesBloc;
  late MockDetectLangUseCase mockDetectLangUseCase;

  setUp(() {
    mockDetectLangUseCase = MockDetectLangUseCase();
    detectLanguagesBloc = DetectLanguagesBloc(detectLangUseCase: mockDetectLangUseCase);
  });

  tearDown(() {
    detectLanguagesBloc.close();
  });

  group("detect event", () {
    test("Initial state should be DetectLanguagesState.initial()", () {
      expect(detectLanguagesBloc.state, isInstanceOf<Initial>());
    });

    void setUpDetectSuccess() {
      when(mockDetectLangUseCase("test")).thenAnswer((_) async =>
          Right([DetectionModel(isReliable: true, confidence: 1, language: "en")]));
    }

    test("detectLangUseCase must be called", () async {
      setUpDetectSuccess();
      detectLanguagesBloc.add(const DetectLanguagesEvent.detect(inputText: "test"));
      await untilCalled(mockDetectLangUseCase("test"));
      verify(mockDetectLangUseCase("test"));
    });

    blocTest<DetectLanguagesBloc, DetectLanguagesState>(
      "Loading state and Detected state must be emitted on detection success",
      build: () => detectLanguagesBloc,
      setUp: setUpDetectSuccess,
      act: (bloc) => bloc.add(const DetectLanguagesEvent.detect(inputText: "test")),
      expect: () => <DetectLanguagesState>[
        const DetectLanguagesState.loading(),
        DetectLanguagesState.detected(inputText: "test", detectionList: [
          DetectionModel(isReliable: true, confidence: 1, language: "en")
        ])
      ],
    );

    group("Failure cases", () {
      void setUpDetectFailure() {
        when(mockDetectLangUseCase("test")).thenAnswer((_) async => Left(FetchFailure()));
      }

      blocTest<DetectLanguagesBloc, DetectLanguagesState>(
        "Loading state and Failure state must be emitted on detection failure",
        build: () => detectLanguagesBloc,
        setUp: setUpDetectFailure,
        act: (bloc) => bloc.add(const DetectLanguagesEvent.detect(inputText: "test")),
        expect: () => <DetectLanguagesState>[
          const DetectLanguagesState.loading(),
          DetectLanguagesState.failed(FetchFailure())
        ],
      );
    });
  });
}
