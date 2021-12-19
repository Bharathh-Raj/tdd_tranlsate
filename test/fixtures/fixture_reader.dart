import 'dart:convert';
import 'dart:io';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

Map<String, dynamic> fixtureAsMap(String name) =>
    json.decode(fixture(name)) as Map<String, dynamic>;
