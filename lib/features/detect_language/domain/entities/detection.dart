abstract class Detection {
  final String langCode;
  final bool isReliable;
  final double accuracy;

  Detection(
      {required this.langCode,
      required this.isReliable,
      required this.accuracy});

  @override
  String toString() {
    return 'Detection{langCode: $langCode, isReliable: $isReliable, accuracy: $accuracy}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Detection &&
          runtimeType == other.runtimeType &&
          langCode == other.langCode &&
          isReliable == other.isReliable &&
          accuracy == other.accuracy;

  @override
  int get hashCode =>
      langCode.hashCode ^ isReliable.hashCode ^ accuracy.hashCode;
}
