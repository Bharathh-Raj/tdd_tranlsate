// import 'package:flutter/foundation.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'language.freezed.dart';
// part 'language.g.dart';
//
// @freezed
// class Language with _$Language {
//   const Language._();
//   const factory Language(
//       {required String name,
//       @JsonKey(name: 'language') required String code}) = _Language;
//
//   factory Language.fromJson(Map<String, dynamic> json) =>
//       _$LanguageFromJson(json);
// }
// abstract class Language {
//   String get name;
//   String get language;
// }

abstract class Language {
  final String name;
  final String code;

  const Language({required this.code, required this.name});

  @override
  String toString() {
    return "{name: $name,code: $code}";
  }

  @override
  bool operator ==(Object other) {
    return other is Language && code == other.code && name == other.name;
  }
}
