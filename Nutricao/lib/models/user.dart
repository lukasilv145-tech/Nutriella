class User {
  String name;
  int age;
  double weight; // kg
  double height; // cm
  String gender;
  String goal; // 'lose_weight', 'maintain', 'gain_muscle'
  double activityLevel; // 1.2 (sedentary) a 1.9 (very active)
  DateTime createdAt;

  User({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.goal,
    required this.activityLevel,
    required this.createdAt,
  });

  // Calcular TMB (Taxa Metabólica Basal) - Fórmula de Mifflin-St Jeor
  double calculateBMR() {
    if (gender == 'male') {
      return (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      return (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
  }

  // Calcular TDEE (Total Daily Energy Expenditure)
  double calculateTDEE() {
    return calculateBMR() * activityLevel;
  }

  // Calcular meta calórica baseada no objetivo
  double calculateCalorieGoal() {
    double tdee = calculateTDEE();
    switch (goal) {
      case 'lose_weight':
        return tdee - 500; // Déficit de 500 calorias
      case 'gain_muscle':
        return tdee + 300; // Superávit de 300 calorias
      case 'maintain':
      default:
        return tdee;
    }
  }

  // Calcular IMC
  double calculateBMI() {
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  // Calcular metas de macros
  Map<String, double> calculateMacroGoals() {
    double calorieGoal = calculateCalorieGoal();
    double protein, carbs, fat;

    switch (goal) {
      case 'gain_muscle':
        protein = (calorieGoal * 0.30) / 4; // 30% das calorias
        carbs = (calorieGoal * 0.45) / 4; // 45% das calorias
        fat = (calorieGoal * 0.25) / 9; // 25% das calorias
        break;
      case 'lose_weight':
        protein = (calorieGoal * 0.40) / 4; // 40% das calorias
        carbs = (calorieGoal * 0.35) / 4; // 35% das calorias
        fat = (calorieGoal * 0.25) / 9; // 25% das calorias
        break;
      default: // maintain
        protein = (calorieGoal * 0.30) / 4; // 30% das calorias
        carbs = (calorieGoal * 0.40) / 4; // 40% das calorias
        fat = (calorieGoal * 0.30) / 9; // 30% das calorias
    }

    return {
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  // Calcular meta de água (ml)
  double calculateWaterGoal() {
    return weight * 35; // 35ml por kg de peso
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'goal': goal,
      'activityLevel': activityLevel,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      gender: json['gender'],
      goal: json['goal'],
      activityLevel: json['activityLevel'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
