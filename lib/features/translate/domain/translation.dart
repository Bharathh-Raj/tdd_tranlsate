abstract class Translation {
  final String translatedText;
  final String? sourceLangCode;

  Translation({required this.translatedText, required this.sourceLangCode});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Translation &&
          runtimeType == other.runtimeType &&
          translatedText == other.translatedText &&
          sourceLangCode == other.sourceLangCode;

  @override
  int get hashCode => translatedText.hashCode ^ sourceLangCode.hashCode;
}
