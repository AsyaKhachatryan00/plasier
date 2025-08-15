import 'dart:convert';
import 'package:plasier/models/ingredient.dart';

class Recipe {
  final String id;
  final String title;
  final List<Ingredient> ingredients;
  final String formType;
  final double temprature;
  final Duration dryingTime;
  final DateTime createdDate;
  Status status;

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.formType,
    required this.temprature,
    required this.dryingTime,
    required this.createdDate,
    required this.status,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      ingredients: (json['ingredients'] as List)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      formType: json['formType'],
      temprature: json['temprature'],
      dryingTime: Duration(minutes: json['dryingTime']),
      createdDate: json['createdDate'] is DateTime
          ? json['createdDate']
          : DateTime.parse(json['createdDate']),
      status:
          DateTime.now().difference(
                json['createdDate'] is DateTime
                    ? json['createdDate']
                    : DateTime.parse(json['createdDate']),
              ) >=
              Duration(minutes: json['dryingTime'])
          ? Status.ready
          : Status.dries,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ingredients': ingredients.map((e) => e.toJson()).toList(),
    'formType': formType,
    'temprature': temprature,
    'dryingTime': dryingTime.inMinutes,
    'createdDate': createdDate.toIso8601String(),
    'status': status.toString().split('.').last,
  };

  String encode() => jsonEncode(toJson());

  static Recipe decode(String jsonStg) => Recipe.fromJson(jsonDecode(jsonStg));
}

enum Status { ready, dries }

extension StatusExtension on Status {
  String get name {
    switch (this) {
      case Status.ready:
        return 'Bereit';
      case Status.dries:
        return 'Trocknend';
    }
  }
}
