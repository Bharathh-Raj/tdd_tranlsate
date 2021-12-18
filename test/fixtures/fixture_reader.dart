import 'dart:convert';
import 'dart:io';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

Map<String, dynamic> fixtureAsMap(String name) =>
    json.decode(File('test/fixtures/$name').readAsStringSync()) as Map<String, dynamic>;
