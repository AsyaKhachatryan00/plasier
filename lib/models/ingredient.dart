class Ingredient {
  final String name;
  final String gram;

  Ingredient({required this.name, required this.gram});

  Map<String, dynamic> toJson() {
    return {'name': name, 'gram': gram};
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(name: json['name'], gram: json['gram']);
  }
}
