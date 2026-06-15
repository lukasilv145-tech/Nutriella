import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/meal.dart';
import '../models/water_intake.dart';

class MealProvider with ChangeNotifier {
  List<Meal> _meals = [];
  List<WaterIntake> _waterIntake = [];

  List<Meal> get meals => _meals;
  List<WaterIntake> get waterIntake => _waterIntake;

  MealProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final mealsJson = prefs.getString('meals');
    if (mealsJson != null) {
      _meals = (jsonDecode(mealsJson) as List)
          .map((m) => Meal.fromJson(m))
          .toList();
    }

    final waterJson = prefs.getString('waterIntake');
    if (waterJson != null) {
      _waterIntake = (jsonDecode(waterJson) as List)
          .map((w) => WaterIntake.fromJson(w))
          .toList();
    }

    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('meals', jsonEncode(_meals.map((m) => m.toJson()).toList()));
    await prefs.setString('waterIntake', jsonEncode(_waterIntake.map((w) => w.toJson()).toList()));
  }

  List<Meal> getMealsForDate(DateTime date) {
    return _meals.where((meal) {
      return meal.date.year == date.year &&
          meal.date.month == date.month &&
          meal.date.day == date.day;
    }).toList();
  }

  double getTotalCaloriesForDate(DateTime date) {
    return getMealsForDate(date).fold(0, (sum, meal) => sum + meal.totalCalories);
  }

  double getTotalProteinForDate(DateTime date) {
    return getMealsForDate(date).fold(0, (sum, meal) => sum + meal.totalProtein);
  }

  double getTotalCarbsForDate(DateTime date) {
    return getMealsForDate(date).fold(0, (sum, meal) => sum + meal.totalCarbs);
  }

  double getTotalFatForDate(DateTime date) {
    return getMealsForDate(date).fold(0, (sum, meal) => sum + meal.totalFat);
  }

  double getWaterIntakeForDate(DateTime date) {
    return _waterIntake
        .where((w) {
          return w.date.year == date.year &&
              w.date.month == date.month &&
              w.date.day == date.day;
        })
        .fold(0, (sum, w) => sum + w.amount);
  }

  Future<void> addMeal(Meal meal) async {
    _meals.add(meal);
    await _saveData();
    notifyListeners();
  }

  Future<void> removeMeal(String mealId) async {
    _meals.removeWhere((m) => m.id == mealId);
    await _saveData();
    notifyListeners();
  }

  Future<void> addWaterIntake(WaterIntake intake) async {
    _waterIntake.add(intake);
    await _saveData();
    notifyListeners();
  }

  Future<void> clearData() async {
    _meals = [];
    _waterIntake = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('meals');
    await prefs.remove('waterIntake');
    notifyListeners();
  }
}
