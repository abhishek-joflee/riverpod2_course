import 'dart:collection';
import 'dart:convert';

import 'package:collection/collection.dart' show DeepCollectionEquality;
import 'package:flutter/foundation.dart' show ChangeNotifier, immutable;
import 'package:uuid/uuid.dart' show Uuid;

@immutable
class Person {
  Person({
    required this.name,
    required this.age,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  final String name;
  final int age;
  final String uuid;

  @override
  String toString() => 'Person(name: $name, age: $age, uuid: $uuid)';

  String get displayName => '$name ($age years old)';

  factory Person.fromMap(Map<String, dynamic> data) => Person(
        name: data['name'] as String,
        age: data['age'] as int,
        uuid: data['uuid'] as String,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'age': age,
        'uuid': uuid,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Person].
  factory Person.fromJson(String data) {
    return Person.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Person] to a JSON string.
  String toJson() => json.encode(toMap());

  Person copyWith({
    String? name,
    int? age,
    String? uuid,
  }) {
    return Person(
      name: name ?? this.name,
      age: age ?? this.age,
      uuid: uuid ?? this.uuid,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Person) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode ^ uuid.hashCode;
}

class PersonDataModel extends ChangeNotifier {
  final List<Person> _persons = [];

  int get count => _persons.length;

  @override
  String toString() => [...(_persons.map((e) => e.toString()))].toString();

  UnmodifiableListView<Person> get persons => UnmodifiableListView(_persons);

  void add(Person person) {
    _persons.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    _persons.remove(person);
    notifyListeners();
  }

  void update(Person newPerson) {
    final index = _persons.indexWhere((p) => p.uuid == newPerson.uuid);
    if (index >= 0) {
      final oldPerson = _persons[index];
      _persons[index] = oldPerson.copyWith(
        name: newPerson.name,
        age: newPerson.age,
      );
      notifyListeners();
    }
  }
}
