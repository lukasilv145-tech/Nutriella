import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/user_provider.dart';
import '../providers/meal_provider.dart';
import '../models/user.dart';
import '../models/water_intake.dart';
import 'add_meal_screen.dart';
import 'profile_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final mealProvider = Provider.of<MealProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final calorieGoal = user.calculateCalorieGoal();
    final macroGoals = user.calculateMacroGoals();
    final waterGoal = user.calculateWaterGoal();

    final totalCalories = mealProvider.getTotalCaloriesForDate(_selectedDate);
    final totalProtein = mealProvider.getTotalProteinForDate(_selectedDate);
    final totalCarbs = mealProvider.getTotalCarbsForDate(_selectedDate);
    final totalFat = mealProvider.getTotalFatForDate(_selectedDate);
    final totalWater = mealProvider.getWaterIntakeForDate(_selectedDate);

    final calorieProgress = totalCalories / calorieGoal;
    final proteinProgress = totalProtein / macroGoals['protein']!;
    final carbsProgress = totalCarbs / macroGoals['carbs']!;
    final fatProgress = totalFat / macroGoals['fat']!;
    final waterProgress = totalWater / waterGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutriela'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                        });
                      },
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _selectedDate.add(const Duration(days: 1));
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Calorie progress
            _buildProgressCard(
              'Calorias',
              totalCalories,
              calorieGoal,
              'kcal',
              calorieProgress,
              Colors.orange,
            ),
            const SizedBox(height: 12),

            // Macros row
            Row(
              children: [
                Expanded(
                  child: _buildProgressCard(
                    'Proteína',
                    totalProtein,
                    macroGoals['protein']!,
                    'g',
                    proteinProgress,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildProgressCard(
                    'Carboidratos',
                    totalCarbs,
                    macroGoals['carbs']!,
                    'g',
                    carbsProgress,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildProgressCard(
                    'Gorduras',
                    totalFat,
                    macroGoals['fat']!,
                    'g',
                    fatProgress,
                    Colors.yellow,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildProgressCard(
                    'Água',
                    totalWater,
                    waterGoal,
                    'ml',
                    waterProgress,
                    Colors.cyan,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddMealScreen(date: _selectedDate),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Refeição'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _addWater,
                    icon: const Icon(Icons.water_drop),
                    label: const Text('+ Água'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Today's meals
            const Text(
              'Refeições de Hoje',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildMealsList(mealProvider, _selectedDate),
            const SizedBox(height: 20),

            // Statistics button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const StatsScreen()),
                );
              },
              icon: const Icon(Icons.bar_chart),
              label: const Text('Ver Estatísticas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    String title,
    double current,
    double goal,
    String unit,
    double progress,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${current.toStringAsFixed(1)} $unit',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '/ ${goal.toStringAsFixed(1)} $unit',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsList(MealProvider mealProvider, DateTime date) {
    final meals = mealProvider.getMealsForDate(date);

    if (meals.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.restaurant, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'Nenhuma refeição registrada',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: meals.map((meal) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(_getMealIcon(meal.type)),
            title: Text(_getMealName(meal.type)),
            subtitle: Text('${meal.totalCalories.toStringAsFixed(0)} kcal'),
            trailing: Text('${meal.items.length} itens'),
            onTap: () {
              // TODO: Show meal details
            },
          ),
        );
      }).toList(),
    );
  }

  IconData _getMealIcon(String type) {
    switch (type) {
      case 'breakfast':
        return Icons.breakfast_dining;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snack':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  String _getMealName(String type) {
    switch (type) {
      case 'breakfast':
        return 'Café da Manhã';
      case 'lunch':
        return 'Almoço';
      case 'dinner':
        return 'Jantar';
      case 'snack':
        return 'Lanche';
      default:
        return 'Refeição';
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addWater() {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    mealProvider.addWaterIntake(
      WaterIntake(
        date: _selectedDate,
        amount: 250, // Adiciona 250ml (um copo)
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('+250ml de água adicionado!')),
    );
  }
}
