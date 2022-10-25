import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class Film {
  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
  });

  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  @override
  String toString() {
    return '''Film(
      id: $id,
      title: $title,
      description:$description,
      isFavorite: $isFavorite,
    )''';
  }

  factory Film.fromMap(Map<String, dynamic> data) => Film(
        id: data['id'] as String,
        title: data['title'] as String,
        description: data['description'] as String,
        isFavorite: data['isFavorite'] as bool,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'isFavorite': isFavorite,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Film].
  factory Film.fromJson(String data) {
    return Film.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Film] to a JSON string.
  String toJson() => json.encode(toMap());

  Film copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
  }) {
    return Film(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Film) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ description.hashCode ^ isFavorite.hashCode;
}
