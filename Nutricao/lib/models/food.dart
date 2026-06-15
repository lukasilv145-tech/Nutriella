class Food {
  final String id;
  final String name;
  final String category;
  final double calories; // por 100g
  final double protein; // g por 100g
  final double carbs; // g por 100g
  final double fat; // g por 100g
  final String? emoji;
  final double servingSize; // tamanho padrão em gramas

  Food({
    required this.id,
    required this.name,
    required this.category,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.emoji,
    this.servingSize = 100,
  });

  // Calcular nutrientes baseado na quantidade em gramas
  Map<String, double> getNutrients(double grams) {
    double multiplier = grams / 100;
    return {
      'calories': calories * multiplier,
      'protein': protein * multiplier,
      'carbs': carbs * multiplier,
      'fat': fat * multiplier,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'emoji': emoji,
      'servingSize': servingSize,
    };
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      calories: json['calories'].toDouble(),
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
      emoji: json['emoji'],
      servingSize: json['servingSize']?.toDouble() ?? 100,
    );
  }
}
