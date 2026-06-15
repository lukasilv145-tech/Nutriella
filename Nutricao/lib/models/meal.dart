class Meal {
  final String id;
  final String type; // 'breakfast', 'lunch', 'dinner', 'snack'
  final DateTime date;
  final List<MealItem> items;

  Meal({
    required this.id,
    required this.type,
    required this.date,
    required this.items,
  });

  double get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
  double get totalProtein => items.fold(0, (sum, item) => sum + item.protein);
  double get totalCarbs => items.fold(0, (sum, item) => sum + item.carbs);
  double get totalFat => items.fold(0, (sum, item) => sum + item.fat);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      type: json['type'],
      date: DateTime.parse(json['date']),
      items: (json['items'] as List).map((item) => MealItem.fromJson(item)).toList(),
    );
  }
}

class MealItem {
  final String foodId;
  final String foodName;
  final double grams;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  MealItem({
    required this.foodId,
    required this.foodName,
    required this.grams,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'grams': grams,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      foodId: json['foodId'],
      foodName: json['foodName'],
      grams: json['grams'].toDouble(),
      calories: json['calories'].toDouble(),
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
    );
  }
}
